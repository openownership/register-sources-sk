# frozen_string_literal: true

require_relative 'config/elasticsearch'
require_relative 'structs/record'

module RegisterSourcesSk
  class Repository
    ElasticsearchError = Class.new(StandardError)

    SearchResult = Struct.new(:record, :score)

    class SearchResults < Array
      def initialize(arr, total_count: nil, aggs: nil)
        @total_count = total_count || arr.to_a.count
        @aggs = aggs

        super(arr)
      end

      attr_reader :total_count, :aggs
    end

    def initialize(client: Config::ELASTICSEARCH_CLIENT, index: nil)
      @client = client
      @index = index
    end

    attr_reader :client, :index

    def get(etag)
      process_results(
        client.search(
          index:,
          body: {
            query: {
              bool: {
                must: [
                  {
                    match: {
                      etag: {
                        query: etag
                      }
                    }
                  }
                ]
              }
            }
          }
        )
      ).first&.record
    end

    def store(records)
      return true if records.empty?

      operations = records.map do |record|
        raise 'no etag' unless record.etag

        {
          index: {
            _index: index,
            _id: record.etag,
            data: {
              data: record.to_h,
              etag: record.etag
            }
          }
        }
      end

      result = client.bulk(body: operations)

      if result['errors']
        print 'Error result: ', result, "\n\n"
        raise ElasticsearchError, errors: result['errors']
      end

      true
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def build_get_by_bods_identifiers(identifiers)
      icos = [] # record.PartneriVerejnehoSektora.Ico
      ids = [] # sk_record.KonecniUzivateliaVyhod.Id
      identifiers.each do |identifier|
        case identifier.schemeName
        when 'SK Register Partnerov Verejného Sektora'
          ids << identifier.id
        when 'Ministry of Justice Business Register'
          icos << identifier.id
        end
      end

      return if icos.empty? && ids.empty?

      {
        bool: {
          should: icos.map { |ico|
            {
              bool: {
                must: [
                  {
                    nested: {
                      path: 'data.PartneriVerejnehoSektora',
                      query: {
                        bool: {
                          must: [
                            { match: { 'data.PartneriVerejnehoSektora.Ico': { query: ico } } }
                          ]
                        }
                      }
                    }
                  }
                ]
              }
            }
          } + ids.map do |id|
            {
              bool: {
                must: [
                  {
                    nested: {
                      path: 'data.KonecniUzivateliaVyhod',
                      query: {
                        bool: {
                          must: [
                            { match: { 'data.KonecniUzivateliaVyhod.Id': { query: id } } }
                          ]
                        }
                      }
                    }
                  }
                ]
              }
            }
          end
        }
      }
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    private

    def process_results(results)
      hits = results.dig('hits', 'hits') || []
      hits = hits.sort { |hit| hit['_score'] }.reverse # rubocop:disable Lint/UnexpectedBlockArity # FIXME
      total_count = results.dig('hits', 'total', 'value') || 0

      mapped = hits.map do |hit|
        SearchResult.new(map_es_record(hit['_source']), hit['_score'])
      end

      SearchResults.new(
        mapped.sort_by(&:score).reverse,
        total_count:,
        aggs: results['aggregations']
      )
    end

    def map_es_record(record)
      Record[record['data']]
    end
  end
end
