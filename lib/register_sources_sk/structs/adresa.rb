# frozen_string_literal: true

require_relative '../types'

module RegisterSourcesSk
  # Address
  class Adresa < Dry::Struct
    transform_keys(&:to_sym)

    attribute? :Id,              Types::Nominal::Integer.optional
    attribute? :MenoUlice,       Types::String.optional           # Street name
    attribute? :OrientacneCislo, Types::String.optional           # Orientation number
    attribute? :SupisneCislo,    Types::String.optional           # Register number
    attribute? :Mesto,           Types::String.optional           # City
    attribute? :MestoKod,        Types::String.optional           # City code
    attribute? :Psc,             Types::String.optional
    attribute? :Identifikator,   Types::String.optional           # Identifier
  end
end
