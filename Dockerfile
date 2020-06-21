FROM ubuntu:18.04

ENV CONFLUENT_VERSION=5.0 \
    PROMETHEUS_JMX_EXPORTER_VERSION=0.10 \
    JOLOKIA_VERSION=1.6.0 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    PROMETHEUS_EXPORTER_DIR=/var/lib/prometheus-metrics-exporter

RUN set -x \
    && mkdir -p ${PROMETHEUS_EXPORTER_DIR} \
    && chown -R :root ${PROMETHEUS_EXPORTER_DIR} \
    && chmod -R g+rwx ${PROMETHEUS_EXPORTER_DIR}
# install pre-requisites and Confluent
RUN set -x \
    && apt-get update \
    && apt-get install -y openjdk-8-jre-headless wget netcat-openbsd software-properties-common \
    && wget -qO - http://packages.confluent.io/deb/$CONFLUENT_VERSION/archive.key | apt-key add - \
    && add-apt-repository "deb [arch=amd64] http://packages.confluent.io/deb/$CONFLUENT_VERSION stable main" \
    && apt-get update \
    && apt-get install -y confluent-platform-oss-2.11
# add custom metrics reporters
RUN set -x \
    && wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${PROMETHEUS_JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${PROMETHEUS_JMX_EXPORTER_VERSION}.jar \
    && mv ./jmx_prometheus_javaagent-${PROMETHEUS_JMX_EXPORTER_VERSION}.jar ${PROMETHEUS_EXPORTER_DIR}/jmx_prometheus_javaagent-${PROMETHEUS_JMX_EXPORTER_VERSION}.jar
