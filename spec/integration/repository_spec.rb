# frozen_string_literal: true

require 'elasticsearch'
require 'register_sources_sk/repository'
require 'register_sources_sk/services/es_index_creator'
require 'register_sources_sk/structs/record'

RSpec.describe RegisterSourcesSk::Repository do
  subject { described_class.new(client: es_client, index:) }

  let(:index) { "tmp-#{SecureRandom.uuid}" }
  let(:es_client) { Elasticsearch::Client.new }

  let(:record) do
    RegisterSourcesSk::Record[
      JSON.parse(File.read('spec/fixtures/sk_company_datum.json'))
    ]
  end

  before do
    index_creator = RegisterSourcesSk::Services::EsIndexCreator.new(client: es_client)
    index_creator.create_index(index)
  end

  after do
    es_client.indices.delete(index:)
  end

  describe '#store' do
    it 'stores' do
      records = [record]

      subject.store(records)

      sleep 1 # eventually consistent, give time

      expect(subject.get(record.etag)).to eq record

      # When records do not exist
      expect(subject.get('missing')).to be_nil
    end
  end
end
