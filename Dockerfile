FROM openjdk:18-alpine

ENV GRADLE_VERSION 7.4
ENV GRADLE_HOME /opt/gradle/gradle-$GRADLE_VERSION
ENV PATH $GRADLE_HOME/bin:$PATH

RUN apk add --no-cache tar
RUN apk add --no-cache bash

RUN mkdir opt/gradle

RUN cd /usr/local && \
    wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
    unzip gradle-$GRADLE_VERSION-bin.zip -d /opt/gradle && \
    rm gradle-$GRADLE_VERSION-bin.zip

COPY build.gradle.kts .
COPY settings.gradle.kts .
COPY src src
RUN $GRADLE_HOME/bin/gradle clean build
ENV JAR_FILE build/libs/glotonas-0.0.1-SNAPSHOT.jar

ENV JAVA_OPTS "-Xms1024m -Xmx2048m -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8081"

EXPOSE 8081
ENTRYPOINT exec java $JAVA_OPTS -jar $JAR_FILE