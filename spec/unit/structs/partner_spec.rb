require 'register_sources_sk/structs/partner'

RSpec.describe RegisterSourcesSk::Partner do
  let(:valid_partner) do
    {
      "Id": 123,
      "CisloVlozky": 456
    }
  end

  it 'allows valid' do
    partner = described_class[valid_partner]

    expect(partner).to be_a RegisterSourcesSk::Partner
    
    expect(partner.Id).to eq 123
    expect(partner.CisloVlozky).to eq 456
  end
end
