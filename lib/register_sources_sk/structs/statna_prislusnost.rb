require 'register_sources_sk/types'

module RegisterSourcesSk
  class StatnaPrislusnost < Dry::Struct # Nationality
    transform_keys(&:to_sym)

    attribute? :Id, Types::Nominal::Integer.optional
    attribute? :Meno, Types::String.optional # Name
    attribute? :StatistickyKod, Types::String.optional # Statistically Code
    attribute? :PlatnostOd, Types::Nominal::DateTime.optional # Valid from
    attribute? :PlatnostDo, Types::Nominal::DateTime.optional # Valid to
  end
end
