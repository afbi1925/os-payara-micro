#!/bin/sh
exec java $JAVA_BASE_OPTIONS $JAVA_MEMORY_OPTIONS -jar /opt/payara/payara-micro.jar $*
