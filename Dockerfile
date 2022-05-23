ARG JDK_VERSION
FROM openjdk:${JDK_VERSION}-jdk-slim-buster

ARG VERSION
ARG SCALA_VERSION

RUN apt-get update \
    && apt-get install -y curl netcat \
    && cd /root \
    && curl -o kafka.tgz https://archive.apache.org/dist/kafka/${VERSION}/kafka_${SCALA_VERSION}-${VERSION}.tgz \
    && tar -xzf kafka.tgz \
    && rm kafka.tgz \
    && mv kafka_${SCALA_VERSION}-${VERSION} kafka

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 9092
