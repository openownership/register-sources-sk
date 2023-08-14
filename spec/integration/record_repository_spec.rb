require 'elasticsearch'
require 'register_sources_sk/repositories/record_repository'
require 'register_sources_sk/services/es_index_creator'
require 'register_sources_sk/structs/record'

BodsIdentifier = Struct.new(:id, :schemeName)

RSpec.describe RegisterSourcesSk::Repositories::RecordRepository do
  subject { described_class.new(client: es_client, index:) }

  let(:index) { SecureRandom.uuid }
  let(:es_client) { Elasticsearch::Client.new }

  let(:record) do
    RegisterSourcesSk::Record[
      JSON.parse(File.read('spec/fixtures/sk_company_datum.json'))
    ]
  end

  before do
    index_creator = RegisterSourcesSk::Services::EsIndexCreator.new(
      es_index: index,
      client: es_client,
    )
    index_creator.create_index
  end

  describe '#store' do
    it 'stores' do
      records = [record]

      subject.store(records)

      sleep 1 # eventually consistent, give time

      expect(subject.get(record.etag)).to eq record

      # When records do not exist
      expect(subject.get("missing")).to be_nil
    end
  end

  describe '#get_by_bods_identifiers' do
    it 'retrieves' do
      records = [record]

      subject.store(records)

      sleep 1 # eventually consistent, give time

      id_identifiers = [
        BodsIdentifier.new("3", 'SK Register Partnerov Verejného Sektora'),
      ]
      expect(subject.get_by_bods_identifiers(id_identifiers)).to eq [record]

      ico_identifiers = [
        BodsIdentifier.new("1234567", 'Ministry of Justice Business Register'),
      ]
      expect(subject.get_by_bods_identifiers(ico_identifiers)).to eq [record]

      missing_id_identifiers = [
        BodsIdentifier.new("10", 'SK Register Partnerov Verejného Sektora'),
      ]
      expect(subject.get_by_bods_identifiers(missing_id_identifiers)).to eq []

      missing_ico_identifiers = [
        BodsIdentifier.new("1234568", 'Ministry of Justice Business Register'),
      ]
      expect(subject.get_by_bods_identifiers(missing_ico_identifiers)).to eq []
    end
  end
end
