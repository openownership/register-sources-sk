# frozen_string_literal: true

require 'register_sources_sk/repository'

BodsIdentifier = Struct.new(:id, :schemeName)

RSpec.describe RegisterSourcesSk::Repository do
  subject { described_class.new(client:, index:) }

  let(:client) { double 'client' }
  let(:index) { double 'index' }

  let(:record_data) do
    {
      Id: 1,
      PartneriVerejnehoSektora: [
        {
          Id: 1,
          Meno: nil,
          Priezvisko: nil,
          DatumNarodenia: nil,
          ObchodneMeno: 'Example Slovak Company',
          Ico: '1234567',
          PlatnostOd: '2015-01-01T00:00:00+01:00',
          PlatnostDo: nil,
          Adresa: {
            MenoUlice: 'Example Street',
            OrientacneCislo: '1234/1',
            Mesto: 'Example Place',
            Psc: '12345'
          }
        }
      ],
      KonecniUzivateliaVyhod: [
        {
          Id: 1,
          Meno: 'Example',
          Priezvisko: 'Person 1',
          DatumNarodenia: '1950-01-01T00:00:00+02:00',
          PlatnostOd: '2015-01-01T00:00:00+01:00',
          PlatnostDo: nil,
          StatnaPrislusnost: {
            StatistickyKod: '703'
          },
          Adresa: {
            MenoUlice: 'Example Street',
            OrientacneCislo: '1234/1',
            Mesto: 'Example Place',
            Psc: '12345'
          }
        }
      ]
    }
  end

  describe '#get' do
    context 'when client has data' do
      it 'retrieves data' do
        etag = 'abc123'

        hits = [
          {
            '_source' => { 'data' => record_data },
            '_score' => 0.5
          }
        ]

        expect(client).to receive(:search).with(
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
        ).and_return({
                       'hits' => {
                         'hits' => hits
                       }
                     })

        results = subject.get(etag)

        expect(results).to eq RegisterSourcesSk::Record[record_data]
      end
    end
  end

  describe '#store' do
    context 'when empty records given' do
      it 'does nothing' do
        expect(client).not_to receive(:bulk)

        subject.store([])
      end
    end

    context 'when records provided' do
      let(:record) { RegisterSourcesSk::Record[record_data] }

      context 'with errors' do
        it 'raises error' do
          expect(client).to receive(:bulk).with(
            body: [
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
            ]
          ).and_return(
            'errors' => ['some errors']
          )

          expect do
            subject.store([record])
          end.to raise_error described_class::ElasticsearchError
        end
      end

      context 'without errors' do
        it 'does not error' do
          expect(client).to receive(:bulk).with(
            body: [
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
            ]
          ).and_return({})

          expect do
            subject.store([record])
          end.not_to raise_error
        end
      end
    end
  end

  describe '#build_get_by_bods_identifiers' do
    it 'builds query for searching by bods identifiers' do
      identifiers = [
        BodsIdentifier.new('3', 'SK Register Partnerov Verejného Sektora'),
        BodsIdentifier.new('1234567', 'Ministry of Justice Business Register')
      ]

      query = subject.build_get_by_bods_identifiers(identifiers)

      expect(query).to eq(
        {
          bool: {
            should: [
              {
                bool: {
                  must: [
                    {
                      nested: {
                        path: 'data.PartneriVerejnehoSektora',
                        query: {
                          bool: {
                            must: [
                              {
                                match: {
                                  'data.PartneriVerejnehoSektora.Ico': {
                                    query: '1234567'
                                  }
                                }
                              }
                            ]
                          }
                        }
                      }
                    }
                  ]
                }
              },
              {
                bool: {
                  must: [
                    {
                      nested: {
                        path: 'data.KonecniUzivateliaVyhod',
                        query: {
                          bool: {
                            must: [
                              {
                                match: {
                                  'data.KonecniUzivateliaVyhod.Id': {
                                    query: '3'
                                  }
                                }
                              }
                            ]
                          }
                        }
                      }
                    }
                  ]
                }
              }
            ]
          }
        }
      )
    end
  end
end
