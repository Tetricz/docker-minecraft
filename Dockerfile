# Maintainer https://github.com/Tetricz
ARG OPENJDK_VERSION=16-alpine
# https://hub.docker.com/_/openjdk
FROM openjdk:${OPENJDK_VERSION}

ENV MEMORY=2G \
    JARFILE=server.jar

WORKDIR /minecraft

EXPOSE 25565/tcp 25575/tcp

CMD java -Xmx${MEMORY} -Xms${MEMORY} -jar ${JARFILE}