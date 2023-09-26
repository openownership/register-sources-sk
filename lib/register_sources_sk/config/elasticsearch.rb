# frozen_string_literal: true

require 'elasticsearch'

module RegisterSourcesSk
  module Config
    ELASTICSEARCH_CLIENT = Elasticsearch::Client.new

    ES_INDEX = 'sk_records'
  end
end
