# Register Sources SK

Register Sources SK is designed for inclusion as a library for use with the beneficial ownership data from the Public Sector Partners Register collected by the Ministry of Justice of the Slovak Republic.

There are two primary purposes for this library:

- Providing typed objects for the JSON-line data. It makes use of the dry-types and dry-struct gems to specify the different object types allowed in the data returned.
- For use with an Elasticsearch database for
persisting the DK records. This functionality includes creating a mapping for indexing the possible fields observed as well as functions for storage and retrieval.

This library does not perform any ingestion of the DK records, which is the purpose of the register_ingester_dk gem.

## Configuration

The gem requires connection to an Elasticsearch Cluster. It has been tested with ES version v7.17.

These credentials should be set in some ENV variables:
```
ELASTICSEARCH_HOST=
ELASTICSEARCH_PORT=443
ELASTICSEARCH_PROTOCOL=https
ELASTICSEARCH_SSL_VERIFY=true
ELASTICSEARCH_PASSWORD=
```

As an initial setup stage, the index should be created:
```
require 'register_sources_sk/services/es_index_creator'

index_creator = RegisterSourcesSk::Services::EsIndexCreator.new
index_creator.create_company_record_index
```

## Testing

The tests are executed using Docker and Docker Compose. To trigger the tests, run:
```
bin/test
```

Note: If the integration tests fail due to connection failure, it is probable the container is taking a while to start - check the ES container is healthy and try again.
