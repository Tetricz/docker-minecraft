# Maintainer https://github.com/Tetricz
ARG OPENJDK_VERSION=17-alpine
# https://hub.docker.com/_/openjdk
FROM openjdk:${OPENJDK_VERSION}
RUN apk add --no-cache jq curl bash
RUN curl -L https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.14.6/0.10.2/server/jar --output fabric-server-launch.jar
ENV MEMORY=2G

COPY ./update-script.sh /update-script.sh
COPY ./modlist /modlist-example

RUN chmod +x /update-script.sh

EXPOSE 25565/tcp 25565/udp 25575/tcp

ENTRYPOINT [ "/update-script.sh" ]
WORKDIR /minecraft
CMD java -Xmx${MEMORY} -Xms${MEMORY} -jar fabric-server-launch.jar nogui