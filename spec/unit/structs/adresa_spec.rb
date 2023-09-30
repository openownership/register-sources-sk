# frozen_string_literal: true

require 'register_sources_sk/structs/adresa'

RSpec.describe RegisterSourcesSk::Adresa do
  let(:valid_adresa) do
    {
      MenoUlice: 'Example Street',
      OrientacneCislo: '1234/2',
      Mesto: 'Example Place',
      Psc: '12345'
    }
  end

  it 'allows valid' do
    adresa = described_class[valid_adresa]

    expect(adresa).to be_a described_class

    expect(adresa.MenoUlice).to eq 'Example Street'
    expect(adresa.OrientacneCislo).to eq '1234/2'
    expect(adresa.Mesto).to eq 'Example Place'
    expect(adresa.Psc).to eq '12345'
  end
end
