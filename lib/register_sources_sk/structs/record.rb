require 'json'
require 'xxhash'

require 'register_sources_sk/types'
require 'register_sources_sk/structs/partneri_verejneho_sektora'
require 'register_sources_sk/structs/konecni_uzivatelia_vyhod'

module RegisterSourcesSk
  class Record < Dry::Struct
    transform_keys(&:to_sym)

    attribute? :"@odata.context", Types::String.optional
    attribute? :Id, Types::Nominal::Integer.optional
    attribute? :CisloVlozky, Types::Nominal::Integer.optional # Insert number
    attribute? :PartneriVerejnehoSektora, Types.Array(PartneriVerejnehoSektora) # Public Sector Partners
    attribute? :KonecniUzivateliaVyhod, Types.Array(KonecniUzivateliaVyhod) # End Users Benefits

    def etag
      @etag ||= XXhash.xxh64(to_h.to_json).to_s
    end
  end
end
