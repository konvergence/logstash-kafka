#!/bin/sh


if [ "$1" = "--run" ]; then
    envsubst < /config-dir/kafka-"$LOG_VERSION".conf.dist > /config-dir/logstash.conf
    logstash $LOGSTASH_OPTIONS -f /config-dir/logstash.conf
else
    cat  README.md
fi
