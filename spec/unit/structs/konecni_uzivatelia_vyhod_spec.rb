require 'register_sources_sk/structs/konecni_uzivatelia_vyhod'

RSpec.describe RegisterSourcesSk::KonecniUzivateliaVyhod do
  let(:valid_konecni_uzivatelia_vyhod) do
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
  end

  it 'allows valid' do
    konecni_uzivatelia_vyhod = described_class[valid_konecni_uzivatelia_vyhod]

    expect(konecni_uzivatelia_vyhod).to be_a described_class

    expect(konecni_uzivatelia_vyhod.Id).to eq 1
    expect(konecni_uzivatelia_vyhod.Meno).to eq "Example"
    expect(konecni_uzivatelia_vyhod.Priezvisko).to eq "Person 1"
    expect(konecni_uzivatelia_vyhod.DatumNarodenia).to eq "1950-01-01T00:00:00+02:00"
    expect(konecni_uzivatelia_vyhod.PlatnostOd).to eq "2015-01-01T00:00:00+01:00"
    expect(konecni_uzivatelia_vyhod.PlatnostDo).to be_nil

    expect(konecni_uzivatelia_vyhod.StatnaPrislusnost).to be_a RegisterSourcesSk::StatnaPrislusnost
    expect(konecni_uzivatelia_vyhod.StatnaPrislusnost.StatistickyKod).to eq "703"

    expect(konecni_uzivatelia_vyhod.Adresa).to be_a RegisterSourcesSk::Adresa
    expect(konecni_uzivatelia_vyhod.Adresa.MenoUlice).to eq "Example Street"
    expect(konecni_uzivatelia_vyhod.Adresa.OrientacneCislo).to eq "1234/1"
    expect(konecni_uzivatelia_vyhod.Adresa.Mesto).to eq "Example Place"
    expect(konecni_uzivatelia_vyhod.Adresa.Psc).to eq "12345"
  end
end
