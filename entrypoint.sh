#!/bin/bash

cd /root/kafka

# First, we start zookeper and wait for it to be accessible
bin/zookeeper-server-start.sh config/zookeeper.properties &
while ! nc -z localhost 2181; do
    sleep 1
done

# Then, we can start kafka and wait for it to be ready
if [ ! -z "${KAFKA_ADVERTISED_HOST}" ]; then
    echo "listeners=PLAINTEXT://0.0.0.0:9092" >> config/server.properties
    echo "listener.security.protocol.map=PLAINTEXT:PLAINTEXT" >> config/server.properties
    echo "advertised.listeners=PLAINTEXT://${KAFKA_ADVERTISED_HOST}:9092" \
        >> config/server.properties
elif [ -z "${KAFKA_LISTENERS}" ] || [ -z "${KAFKA_PROTOCOL_MAP}" ] || [ -z "${KAFKA_ADVERTISED_LISTENERS}" ] || [ -z "${KAFKA_INTER_BROKER_LISTENER}" ]; then
    echo "KAFKA_ADVERTISED_HOST defaults to localhost"
    echo "advertised.listeners=PLAINTEXT://localhost:9092" >> config/server.properties
else
    echo "listeners=${KAFKA_LISTENERS}" >> config/server.properties
    echo "listener.security.protocol.map=${KAFKA_PROTOCOL_MAP}" >> config/server.properties
    echo "advertised.listeners=${KAFKA_ADVERTISED_LISTENERS}" >> config/server.properties
    echo "inter.broker.listener.name=${KAFKA_INTER_BROKER_LISTENER}" >> config/server.properties
fi
bin/kafka-server-start.sh config/server.properties &
PID=$!
while ! nc -z localhost 9092; do
    sleep 1
done

# Now we can create the topics
IFS=',' read -ra TOPICS <<< "$KAFKA_CREATE_TOPICS"
for topic in "${TOPICS[@]}"; do
    bin/kafka-topics.sh --create \
        --topic $topic \
        --partitions 3 \
        --replication-factor 1 \
        --bootstrap-server localhost:9092
done

# And then we wait for the Kafka process to finish
wait $PID
