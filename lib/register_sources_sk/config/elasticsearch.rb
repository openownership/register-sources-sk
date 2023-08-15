require 'elasticsearch'

module RegisterSourcesSk
  module Config
    ELASTICSEARCH_CLIENT = Elasticsearch::Client.new

    ES_INDEX = 'sk_records'.freeze
  end
end
