require 'register_sources_sk/structs/partneri_verejneho_sektora'

RSpec.describe RegisterSourcesSk::PartneriVerejnehoSektora do
  let(:valid_partneri_verejneho_sektora) do
    {
      "Id": 1,
      "Meno": nil,
      "Priezvisko": nil,
      "DatumNarodenia": nil,
      "ObchodneMeno": "Example Slovak Company",
      "Ico": "1234567",
      "PlatnostOd": "2015-01-01T00:00:00+01:00",
      "PlatnostDo": nil,
      "Adresa": {
        "MenoUlice": "Example Street",
        "OrientacneCislo": "1234/1",
        "Mesto": "Example Place",
        "Psc": "12345"
      }
  }
  end

  it 'allows valid' do
    partneri_verejneho_sektora = described_class[valid_partneri_verejneho_sektora]

    expect(partneri_verejneho_sektora).to be_a RegisterSourcesSk::PartneriVerejnehoSektora
    
    expect(partneri_verejneho_sektora.Id).to eq 1
    expect(partneri_verejneho_sektora.Meno).to be_nil
    expect(partneri_verejneho_sektora.Priezvisko).to be_nil
    expect(partneri_verejneho_sektora.DatumNarodenia).to be_nil
    expect(partneri_verejneho_sektora.ObchodneMeno).to eq "Example Slovak Company"
    expect(partneri_verejneho_sektora.Ico).to eq "1234567"
    expect(partneri_verejneho_sektora.PlatnostOd).to eq "2015-01-01T00:00:00+01:00"
    expect(partneri_verejneho_sektora.PlatnostDo).to be_nil
    
    expect(partneri_verejneho_sektora.Adresa).to be_a RegisterSourcesSk::Adresa
    expect(partneri_verejneho_sektora.Adresa.MenoUlice).to eq "Example Street"
    expect(partneri_verejneho_sektora.Adresa.OrientacneCislo).to eq "1234/1"
    expect(partneri_verejneho_sektora.Adresa.Mesto).to eq "Example Place"
    expect(partneri_verejneho_sektora.Adresa.Psc).to eq "12345"
  end
end
