require 'elasticsearch'

module RegisterSourcesSk
  module Config
    MissingEsCredsError = Class.new(StandardError)

    raise MissingEsCredsError unless ENV['ELASTICSEARCH_HOST']

    ELASTICSEARCH_CLIENT = Elasticsearch::Client.new(
      host: "#{ENV.fetch('ELASTICSEARCH_PROTOCOL', 'http')}://elastic:#{ENV.fetch('ELASTICSEARCH_PASSWORD', nil)}@#{ENV.fetch('ELASTICSEARCH_HOST', nil)}:#{ENV.fetch('ELASTICSEARCH_PORT', nil)}",
      transport_options: { ssl: { verify: (ENV.fetch('ELASTICSEARCH_SSL_VERIFY', false) == 'true') } },
      log: false,
    )

    ES_INDEX = 'sk_records'.freeze
  end
end
