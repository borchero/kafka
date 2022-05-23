# Kafka

This repository provides a Docker image that bundles together Apache Kafka and Zookeeper. This
allows to easily use Apache Kafka in CI pipelines without the need to set up a dedicated Zookeeper
service container.

## Usage

The Kafka Docker container can be run as follows, exposing the Kafka broker on port `9092`:

```bash
docker run -p 9092:9092 ghcr.io/borchero/kafka:latest
```

## Customization

You can customize the behavior of the Kafka Docker container by setting environment variables:

- `KAFKA_ADVERTISED_HOST`: The hostname that Kafka should listen to. Defaults to `localhost`.
- `KAFKA_CREATE_TOPICS`: A list of comma-separated topic names that are automatically created after
  Kafka has started up. Each topic is created with 3 partitions and a replication factor of 1.
  Defaults to no topics.
- `KAFKA_LISTENERS`, `KAFKA_PROTOCOL_MAP`, `KAFKA_ADVERTISED_LISTENERS`,
  `KAFKA_INTER_BROKER_LISTENER`: These variables should be set in tandem (instead of
  `KAFKA_ADVERTISED_HOST`) to specify the configurations values `listeners`,
  `listener.security.protocol.map`, `advertised.listeners`, and `inter.broker.listener.name`,
  respectively.
