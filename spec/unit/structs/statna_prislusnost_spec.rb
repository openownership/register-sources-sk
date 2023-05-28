require 'register_sources_sk/structs/statna_prislusnost'

RSpec.describe RegisterSourcesSk::StatnaPrislusnost do
  let(:valid_statna_prislusnost) do
    {
      StatistickyKod: "703",
    }
  end

  it 'allows valid' do
    statna_prislusnost = described_class[valid_statna_prislusnost]

    expect(statna_prislusnost).to be_a described_class

    expect(statna_prislusnost.Id).to be_nil
    expect(statna_prislusnost.Meno).to be_nil
    expect(statna_prislusnost.StatistickyKod).to eq "703"
    expect(statna_prislusnost.PlatnostOd).to be_nil
    expect(statna_prislusnost.PlatnostDo).to be_nil
  end
end
