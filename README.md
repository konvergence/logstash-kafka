

# Logstash-kafka

**Logstash-kafka** is a docker image based on [logstash]([https://hub.docker.com/r/library/logstash/tags/](https://hub.docker.com/r/library/logstash/tags/)) official image and customized to parse and treat json logs as event streams from kafka for later analysis .

For further reading please refer to [https://12factor.net/logs](https://12factor.net/logs).

The image is aimed to be used along side a Shuttle server and shares it's log directory , but in order to produce an [ephemeral]([https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#containers-should-be-ephemeral](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#containers-should-be-ephemeral)) container you can use it with only a named volume.

```yaml

konvergence/logstash-kafka

```

## Usage

#### Available commands :

`-- run` runs the image

`-- help` shows avaible commands and environement variables.

#### Environement variables

|Variable |Description |Default value |
|--|--|--|
| KAFKA_SERVER|input kafka bootstrap server|`localhost:9092`|
| KAFKA_TOPIC|topics of messages to read from KAFKA|`logstash`|
| EL_HOST| Elasticsearch host. |`es`|
| EL_PORT| Elasticsearch port. |`9200`|
| EL_INDEX|elasticsearch index where logs will be stored.|`containers-%{+YYYY.MM.dd}`|
| EL_USER|elasticsearch user.|`logstash`|
| EL_PASSWORD|elasticsearch password.|`logstash`|
| EL_SSL|enable ssl communication with eslasticsearch.  |`true` |
| EL_SSL_VERIF_CERT|enable ssl certificate verification.|`false`|
| OUTPUT_ONLY| If set to true you will get the logs in the standard output else to elasticsearch. |`false`|
| FINGERPRINT_ENABLE| force document_id with a fingerpint function|`false`|
| FINGERPRINT_FIELD|if the field exist, then use it as document_id|`fingerprint`|
| FINGERPRINT_SOURCE| else force document_id with a fingerpint function|`["@timestamp","fields.rancher_service_name","message"]`|
| FINGERPRINT_KEY| fingerprint key|`kafka`|


#### Stream variables
Allow to create other index, based on criteria

|Variable |Description |Example value |
|--|--|--|
STREAM[1-9]_INDEX| index name of stream [1-9]| `STREAM1_INDEX=backup`|
STREAM[1-9]_FIELD| TAG criteria of stream [1-9]| `STREAM1_FIELD=[docker][container][image]`|
STREAM[1-9]_REGEXP| regexp of value for  criteria of stream [1-9]|`STREAM1_REGEXP=/duplicity/`|



## Getting Started
These instructions will get you a copy of the project on your local machine for development and testing purposes.


## Getting Started

These instructions will get you a copy of the project on your local machine for development and testing purposes.

### Prerequisites

--Docker installed on your local machine.

--Grafana running server for data viz.

### warning about geoip
before send any data, you must define mapping type of geoip into the index

                    "geoip": {
                        "dynamic": true,
                        "properties": {
                            "ip": {
                                "type": "ip"
                            },
                            "latitude": {
                                "type": "half_float"
                            },
                            "location": {
                                "type": "geo_point"
                            },
                            "longitude": {
                                "type": "half_float"
                            }
                        }
                    }

### Installing

A step by step series of examples that tell you have to get a development env running

1. Download or clone the repository.

2. Run elasticsearch first

```

cd test-example/elasticsearch

docker-compose up -d

```

3. Then run shuttle stack

```

cd test-example/shuttle

docker-compose up -d

```

## Running the tests

This section aims to describe how to check if everything works as expected.

1 - Run `docker ps `, you should be able to see 4 running containers (kafka , logstash-kafka and Elasticsearch).

2 - Check **logstash-kafka** logs with `docker logs shuttle_kafka_1` 

3 - to see if kafka and logstash-kfka are linked

> INFO  org.apache.kafka.common.utils.AppInfoParser - Kafka version : 0.10.0.1
> INFO  org.apache.kafka.common.utils.AppInfoParser - Kafka commitId : a7a17cdec9eaa6c5
> INFO  org.apache.kafka.clients.consumer.internals.AbstractCoordinator - Discovered coordinator broker.confluentinc:9092 (id: 2147483646 rack: null) for group logstash.
> INFO  org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - Revoking previously assigned partitions [] for group logstash
> INFO  org.apache.kafka.clients.consumer.internals.AbstractCoordinator - (Re-)joining group logstash

4 - to see if elasticsearch and logstash-kafka are linked.

> INFO logstash.outputs.elasticsearch - New Elasticsearch output {:class=>"LogStash::Outputs::ElasticSearch", :hosts=>["//es:9200"]}

> INFO logstash.agent - Successfully started Logstash API endpoint {:port=>9600}

## Versioning

I use [Github]([https://github.com/](https://github.com/)) for versioning. For the versions available, see the [releases on this repository]([https://github.com/konvergence/logstash-kafka/releases)).

## Authors

* **kShuttle infra team**

