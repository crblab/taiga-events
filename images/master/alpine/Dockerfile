FROM node:alpine

LABEL maintainer="Cerebro Research Lab <bots.cerebro@gmail.com>"

# Taiga back and events properties
ENV TAIGA_VERSION=master \
    RABBIT_VHOST=/ \
    RABBIT_USER=guest \
    RABBIT_PASSWORD=guest \
    RABBIT_HOST=taigarabbit \
    RABBIT_PORT=5672 \
    TAIGA_EVENTS_SECRET=!!!REPLACE-ME-j1598u1J^U*(y251u98u51u5981urf98u2o5uvoiiuzhlit3)!!! \
    TAIGA_EVENTS_PORT=8888

COPY entrypoint.sh /
COPY config.json /taiga/

WORKDIR /usr/src/taiga-events

# Get Taiga-Events
ADD https://github.com/taigaio/taiga-events/archive/${TAIGA_VERSION}.tar.gz /tmp/taiga-events-${TAIGA_VERSION}.tar.gz

# Install the packages we need
# Install Taiga from tag archive
# Setup symbolic links for configuration files
RUN set -ex; \
    apk add --no-cache \
        curl \
        tar \
    ; \
    chmod 755 /entrypoint.sh; \
    rm -f /etc/nginx/sites-enabled/default; \
    mkdir -p /tmp/taiga-events; \
    tar xzf /tmp/taiga-events-${TAIGA_VERSION}.tar.gz -C /tmp/taiga-events; \
    rm /tmp/taiga-events-${TAIGA_VERSION}.tar.gz; \
    mkdir -p /usr/src/taiga-events; \
    cp -r /tmp/taiga-events/taiga-events-${TAIGA_VERSION}/* /usr/src/taiga-events; \
    rm -rf /tmp/taiga-events; \
    ln -s /taiga/config.json /usr/src/taiga-events/config.json; \
    npm install --production; \
    npm install -g coffee-script

ENTRYPOINT ["/entrypoint.sh"]
CMD ["coffee", "index.coffee"]
