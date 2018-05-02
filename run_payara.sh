#!/bin/sh

DEPLOY_ARG=""
if [ -e "$DEPLOY" ]
then
    DEPLOY_ARG="--deploy $DEPLOY"
elif [ -d "$DEPLOYDIR" ]
then
    DEPLOY_ARG="--deploydir $DEPLOYDIR"
fi

exec java $JAVA_BASE_OPTIONS $JAVA_MEMORY_OPTIONS $JAVA_OPTIONS -jar /opt/payara/payara-micro.jar --logproperties $LOG_PROPERTIES_FILE $DEPLOY_ARG $EXTRA_ARGS $*
