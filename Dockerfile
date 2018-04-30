ARG PAYARA_VERSION=5.181

FROM payara/micro:${PAYARA_VERSION}

COPY payara-config.properties run_payara.sh ${PAYARA_PATH}/

USER root
RUN chmod 755 run_payara.sh && chown -R payara:root /opt/payara && chmod g+w /opt/payara

USER payara

ENTRYPOINT ["/opt/payara/run_payara.sh", "--systemproperties", "payara-config.properties"]
CMD ["--deploymentDir", "/opt/payara/deployments"]

ENV BASE_JAVA_OPTIONS="\
-server \
-Djava.awt.headless=true \
-XX:NewRatio=5 \
-XX:+DisableExplicitGC \
-XX:ParallelGCThreads=2 \
-XX:CICompilerCount=2"

ENV JAVA_MEMORY_OPTIONS="\
-XX:MaxMetaspaceSize=256m \
-Xmx512m \
-Xms256m \
-Xss256k"
