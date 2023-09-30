# frozen_string_literal: true

require 'register_sources_sk/types'

require 'register_sources_sk/structs/adresa'
require 'register_sources_sk/structs/partner'
require 'register_sources_sk/structs/statna_prislusnost'

module RegisterSourcesSk
  # End Users Benefits
  class KonecniUzivateliaVyhod < Dry::Struct
    transform_keys(&:to_sym)

    attribute? :Id, Types::Nominal::Integer.optional
    attribute? :Meno, Types::String.optional # Name
    attribute? :Priezvisko, Types::String.optional # Surname
    attribute? :DatumNarodenia, Types::String.optional # Date of birth
    attribute? :TitulPred, Types::String.optional # Title Prev
    attribute? :TitulZa, Types::String.optional # Title ?
    attribute? :JeVerejnyCinitel, Types::Params::Bool.optional # public figure
    attribute? :ObchodneMeno, Types::String.optional # Business name
    attribute? :Ico, Types::String.optional # ?
    attribute? :PlatnostOd, Types::Nominal::DateTime.optional # Valid from
    attribute? :PlatnostDo, Types::Nominal::DateTime.optional # Valid to
    attribute? :Partner, Partner.optional # Partner
    attribute? :StatnaPrislusnost, StatnaPrislusnost.optional # Nationality
    attribute? :PravnaForma, Types::String.optional # Legal form
    attribute? :Adresa, Adresa.optional # Address
  end
end
