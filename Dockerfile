# Maintainer https://github.com/Tetricz
ARG OPENJDK_VERSION=17-alpine
# https://hub.docker.com/_/openjdk
FROM openjdk:${OPENJDK_VERSION}
RUN apk add --no-cache jq curl bash
ENV MEMORY=2G

COPY ./update-script.sh /update-script.sh
COPY ./modlist /modlist-example

RUN chmod +x /update-script.sh

EXPOSE 25565/tcp 25565/udp 25575/tcp

ENTRYPOINT [ "/update-script.sh" ]
CMD java -Xmx${MEMORY} -Xms${MEMORY} -jar fabric-server-launch.jar nogui