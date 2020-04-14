#!/bin/bash


if [ "$1" = "--run" ]; then

    envsubst < /config-dir/kafka-"$LOG_VERSION".conf.dist > /config-dir/logstash.conf


# add outputs stream
    for (( i = 1; ; i++ )); do
      VAR_STREAM_INDEX="STREAM${i}_INDEX"
      VAR_STREAM_FIELD="STREAM${i}_FIELD"
      VAR_STREAM_REGEXP="STREAM${i}_REGEXP"
    
      if [ ! -n "${!VAR_STREAM_INDEX}" ]; then
        break
      fi
    
       export STREAM_INDEX=${!VAR_STREAM_INDEX}
       export STREAM_FIELD=${!VAR_STREAM_FIELD}
       export STREAM_REGEXP=${!VAR_STREAM_REGEXP}


       envsubst < /config-dir/output-stream-"$LOG_VERSION".conf.dist >> /config-dir/logstash.conf

    done

# close of output section
     echo '}' >>  /config-dir/logstash.conf

# run logstash
    logstash $LOGSTASH_OPTIONS -f /config-dir/logstash.conf

else
    cat  README.md
fi
