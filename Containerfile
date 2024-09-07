FROM ghcr.io/ublue-os/bluefin-cli:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="doug@dougelkin.com"

COPY fs /
RUN bash /build/install.sh
