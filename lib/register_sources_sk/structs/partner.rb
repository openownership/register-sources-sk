# frozen_string_literal: true

require_relative '../types'

module RegisterSourcesSk
  class Partner < Dry::Struct
    transform_keys(&:to_sym)

    attribute? :Id,          Types::Nominal::Integer.optional
    attribute? :CisloVlozky, Types::Nominal::Integer.optional # Insert number
  end
end
