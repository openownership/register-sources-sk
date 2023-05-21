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
            index: index,
            body: {
              query: {
                bool: {
                  must: [
                    {
                      match: {
                        "etag": {
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
            index:  {
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
          print "Error result: ", result, "\n\n"
          raise ElasticsearchError, errors: result['errors']
        end

        true
      end

      def get_by_bods_identifiers(identifiers)
        return [] unless identifiers

        # Person Statement
        # RegisterSourcesBods::Identifier.new(
        #   id: sk_record.Id.to_s,
        #   schemeName: 'SK Register Partnerov Verejného Sektora',
        # )

        # Child Entity Statement
        # right_now = Time.zone.now.iso8601
        # @item = record.PartneriVerejnehoSektora.max_by do |p|
        #   p.PlatnostDo.nil? ? right_now : p.PlatnostDo
        # end
        # RegisterSourcesBods::Identifier.new(
        #   scheme: 'SK-ORSR',
        #   schemeName: 'Ministry of Justice Business Register',
        #   id: item.Ico
        # ),

        person_ids = []
        company_ids = []
        identifiers.each do |identifier|
          case identifier.schemeName
          when 'SK Register Partnerov Verejného Sektora'
            person_ids << identifier.id.to_i
          when 'Ministry of Justice Business Register'
            company_ids << identifier.id
          end
        end

        return [] if company_ids.empty? && person_ids.empty?

        process_results(
          client.search(
            index: index,
            body: {
              query: {
                bool: {
                  should: person_ids.map { |person_id|
                    {
                      bool: {
                        must: [
                          {
                            nested: {
                              path: "data",
                              query: {
                                bool: {
                                  must: [
                                    # TODO: filter correct type
                                    { match: { "data.Id": { query: person_id } } },
                                  ]
                                }
                              }
                            }
                          }
                        ]
                      }
                    }
                  } + company_ids.map { |company_id|
                    {
                      bool: {
                        must: [
                          {
                            nested: {
                              path: "data.PartneriVerejnehoSektora",
                              query: {
                                bool: {
                                  must: [
                                    { match: { "data.PartneriVerejnehoSektora.Ico": { query: company_id } } },
                                  ]
                                }
                              }
                            }
                          }
                        ]
                      }
                    }
                  }
                }
              }
            }
          )
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
