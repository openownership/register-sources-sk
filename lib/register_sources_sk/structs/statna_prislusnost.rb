# frozen_string_literal: true

require_relative '../types'

module RegisterSourcesSk
  # Nationality
  class StatnaPrislusnost < Dry::Struct
    transform_keys(&:to_sym)

    attribute? :Id,             Types::Nominal::Integer.optional
    attribute? :Meno,           Types::String.optional            # Name
    attribute? :StatistickyKod, Types::String.optional            # Statistically Code
    attribute? :PlatnostOd,     Types::Nominal::DateTime.optional # Valid from
    attribute? :PlatnostDo,     Types::Nominal::DateTime.optional # Valid to
  end
end
