FROM logstash:5.6.16

# Image Label
LABEL maintainer="kshuttle.io" \
      description="logstash for kafka input" \
      release="5.6.16"

RUN apt-get update \
    && apt-get install -y gettext-base \
  && echo "#### clean " \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*


# put GeoLite2 database
COPY /GeoLite2/ /GeoLite2/
RUN echo "### get last GeoLite2-City database" \
      && tar -zxvf /GeoLite2/GeoLite2-City_20201027.tar.gz  -C /tmp \
      && cd  /tmp/GeoLite2-City_* \
      && mkdir /config-dir/ \
      && mv GeoLite2-City.mmdb /config-dir/ \
      && rm -rf /tmp/*


COPY /assets/conf/ /config-dir/
COPY README.md    /config-dir/

# metadata

ENV KAFKA_SERVER=localhost:9092 \
    KAFKA_TOPIC=logstash \
    KAFKA_CONSUMER_THREADS=12 \
    KAFKA_GROUPID=logstash \
    KAFKA_SESSION_TIMEOUT_MS=300000 \
    KAFKA_REQUEST_TIMEOUT_MS=400000 \
    KAFKA_MAX_PARTITION_FETCH_BYTES=15728640 \
    EL_HOST=es \
    EL_PORT=9200 \
    EL_INDEX=containers-%{+YYYY.MM.dd} \
    EL_USER=logstash \
    EL_PASSWORD=logstash \
    EL_SSL=true \
    EL_SSL_VERIF_CERT=false\
    OUTPUT_ONLY=false \
    LOG_VERSION=v03 \
    LOGSTASH_OPTIONS= \
    FINGERPRINT_ENABLE=false \
    FINGERPRINT_FIELD=fingerprint \
    FINGERPRINT_SOURCE='["@timestamp","fields.rancher_service_name","message"]' \
    FINGERPRINT_KEY=kafka

WORKDIR /config-dir
#VOLUME [ "/config-dir" ]
COPY /bin/entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["--help"]


#see :  https://stackoverflow.com/questions/57836793/mysterious-filebeat-7-x-pack-issue-using-docker-image
