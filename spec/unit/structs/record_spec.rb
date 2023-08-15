require 'register_sources_sk/structs/record'

RSpec.describe RegisterSourcesSk::Record do
  let(:valid_record) do
    {
      Id: 1,
      PartneriVerejnehoSektora: [
        {
          Id: 1,
          Meno: nil,
          Priezvisko: nil,
          DatumNarodenia: nil,
          ObchodneMeno: "Example Slovak Company",
          Ico: "1234567",
          PlatnostOd: "2015-01-01T00:00:00+01:00",
          PlatnostDo: nil,
          Adresa: {
            MenoUlice: "Example Street",
            OrientacneCislo: "1234/1",
            Mesto: "Example Place",
            Psc: "12345",
          },
        },
      ],
      KonecniUzivateliaVyhod: [
        {
          Id: 1,
          Meno: "Example",
          Priezvisko: "Person 1",
          DatumNarodenia: "1950-01-01T00:00:00+02:00",
          PlatnostOd: "2015-01-01T00:00:00+01:00",
          PlatnostDo: nil,
          StatnaPrislusnost: {
            StatistickyKod: "703",
          },
          Adresa: {
            MenoUlice: "Example Street",
            OrientacneCislo: "1234/1",
            Mesto: "Example Place",
            Psc: "12345",
          },
        },
      ],
    }
  end

  it 'allows valid' do
    record = described_class[valid_record]

    expect(record).to be_a described_class

    # expect(record["@odata.context"]).to be_nil
    expect(record.Id).to eq 1
    expect(record.CisloVlozky).to be_nil
    expect(record.PartneriVerejnehoSektora).to eq [
      RegisterSourcesSk::PartneriVerejnehoSektora[
        {
          Id: 1,
          Meno: nil,
          Priezvisko: nil,
          DatumNarodenia: nil,
          ObchodneMeno: "Example Slovak Company",
          Ico: "1234567",
          PlatnostOd: "2015-01-01T00:00:00+01:00",
          PlatnostDo: nil,
          Adresa: {
            MenoUlice: "Example Street",
            OrientacneCislo: "1234/1",
            Mesto: "Example Place",
            Psc: "12345",
          },
        }
      ],
    ]
    expect(record.KonecniUzivateliaVyhod).to eq [
      RegisterSourcesSk::KonecniUzivateliaVyhod[
        {
          Id: 1,
          Meno: "Example",
          Priezvisko: "Person 1",
          DatumNarodenia: "1950-01-01T00:00:00+02:00",
          PlatnostOd: "2015-01-01T00:00:00+01:00",
          PlatnostDo: nil,
          StatnaPrislusnost: {
            StatistickyKod: "703",
          },
          Adresa: {
            MenoUlice: "Example Street",
            OrientacneCislo: "1234/1",
            Mesto: "Example Place",
            Psc: "12345",
          },
        }
      ],
    ]
  end
end
