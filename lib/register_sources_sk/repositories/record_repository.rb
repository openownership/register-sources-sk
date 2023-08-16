require 'register_sources_sk/config/elasticsearch'

require 'register_sources_sk/structs/record'

module RegisterSourcesSk
  module Repositories
    class RecordRepository
      UnknownRecordKindError = Class.new(StandardError)
      ElasticsearchError = Class.new(StandardError)

      SearchResult = Struct.new(:record, :score)

      def initialize(client: Config::ELASTICSEARCH_CLIENT, index: Config::ES_INDEX)
        @client = client
        @index = index
      end

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
                          query: etag,
                        },
                      },
                    },
                  ],
                },
              },
            },
          ),
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
                etag: record.etag,
              },
            },
          }
        end

        result = client.bulk(body: operations)

        if result['errors']
          print "Error result: ", result, "\n\n"
          raise ElasticsearchError, errors: result['errors']
        end

        true
      end

      def get_by_bods_identifiers(identifiers)
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

        return [] if icos.empty? && ids.empty?

        process_results(
          client.search(
            index:,
            body: {
              query: {
                bool: {
                  should: icos.map { |ico|
                    {
                      bool: {
                        must: [
                          {
                            nested: {
                              path: "data.PartneriVerejnehoSektora",
                              query: {
                                bool: {
                                  must: [
                                    { match: { 'data.PartneriVerejnehoSektora.Ico': { query: ico } } },
                                  ],
                                },
                              },
                            },
                          },
                        ],
                      },
                    }
                  } + ids.map do |id|
                    {
                      bool: {
                        must: [
                          {
                            nested: {
                              path: "data.KonecniUzivateliaVyhod",
                              query: {
                                bool: {
                                  must: [
                                    { match: { 'data.KonecniUzivateliaVyhod.Id': { query: id } } },
                                  ],
                                },
                              },
                            },
                          },
                        ],
                      },
                    }
                  end,
                },
              },
              size: 10_000,
            },
          ),
        ).map(&:record)
      end

      private

      attr_reader :client, :index

      def process_results(results)
        hits = results.dig('hits', 'hits') || []
        hits = hits.sort { |hit| hit['_score'] }.reverse

        mapped = hits.map do |hit|
          SearchResult.new(map_es_record(hit['_source']), hit['_score'])
        end

        mapped.sort_by(&:score).reverse
      end

      def map_es_record(record)
        Record[record['data']]
      end
    end
  end
end
