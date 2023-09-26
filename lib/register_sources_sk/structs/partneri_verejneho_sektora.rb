# frozen_string_literal: true

require 'register_sources_sk/types'

require 'register_sources_sk/structs/adresa'
require 'register_sources_sk/structs/partner'
require 'register_sources_sk/structs/statna_prislusnost'

module RegisterSourcesSk
  # Public Sector Partners
  class PartneriVerejnehoSektora < Dry::Struct
    transform_keys(&:to_sym)

    attribute? :Id, Types::Nominal::Integer.optional
    attribute? :Meno, Types::String.optional # Name
    attribute? :Priezvisko, Types::String.optional # Surname
    attribute? :DatumNarodenia, Types::String.optional # Date of Birth
    attribute? :TitulPred, Types::String.optional # Title Prev
    attribute? :TitulZa, Types::String.optional # Title ?
    attribute? :ObchodneMeno, Types::String.optional # Business name
    attribute? :Ico, Types::String.optional
    attribute? :FormaOsoby, Types::String.optional # Person form
    attribute? :PlatnostOd, Types::Nominal::DateTime.optional # Valid from
    attribute? :PlatnostDo, Types::Nominal::DateTime.optional # Valid to
    attribute? :Partner, Partner.optional # Partner
    attribute? :PravnaForma, StatnaPrislusnost.optional # Legal form
    attribute? :Adresa, Adresa.optional # Address
  end
end
