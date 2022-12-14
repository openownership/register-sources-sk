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
