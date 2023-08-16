# Register Sources SK

Register Sources SK is designed for inclusion as a library for use with the beneficial ownership data from the Public Sector Partners Register collected by the Ministry of Justice of the Slovak Republic.

There are two primary purposes for this library:

- Providing typed objects for the JSON-line data. It makes use of the dry-types and dry-struct gems to specify the different object types allowed in the data returned.
- For use with an Elasticsearch database for
persisting the DK records. This functionality includes creating a mapping for indexing the possible fields observed as well as functions for storage and retrieval.

This library does not perform any ingestion of the DK records, which is the purpose of the register_ingester_sk gem.

## Configuration

Install and boot [register-v2](https://github.com/openownership/register-v2).

Configure your environment using the example file:

```sh
cp .env.example .env
```

As an initial setup stage, the index should be created:
```
require 'register_sources_sk/services/es_index_creator'

index_creator = RegisterSourcesSk::Services::EsIndexCreator.new
index_creator.create_company_record_index
```

## Testing

Run the tests:

```sh
docker compose run sources-sk test
```
