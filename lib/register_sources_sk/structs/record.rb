# frozen_string_literal: true

require 'json'
require 'xxhash'

require_relative '../types'
require_relative 'konecni_uzivatelia_vyhod'
require_relative 'partneri_verejneho_sektora'

module RegisterSourcesSk
  class Record < Dry::Struct
    transform_keys(&:to_sym)

    attribute? :Id,                       Types::Nominal::Integer.optional
    attribute? :CisloVlozky,              Types::Nominal::Integer.optional      # Insert number
    attribute? :PartneriVerejnehoSektora, Types.Array(PartneriVerejnehoSektora) # Public Sector Partners
    attribute? :KonecniUzivateliaVyhod,   Types.Array(KonecniUzivateliaVyhod)   # End Users Benefits

    def etag
      @etag ||= XXhash.xxh64(to_h.to_json).to_s
    end
  end
end
