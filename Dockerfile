# Install Watchman.

FROM alpine:3.8 AS runtime
RUN apk add --no-cache libcrypto1.0 libgcc libstdc++

FROM runtime AS builder
ENV WATCHMAN_VERSION=4.9.0 \
    WATCHMAN_SHA256=1f6402dc70b1d056fffc3748f2fdcecff730d8843bb6936de395b3443ce05322

RUN apk add --no-cache --update ca-certificates openssl
RUN apk add --no-cache \
    automake \
    autoconf \
    bash \
    build-base \
    libtool \
    linux-headers \
    openssl-dev \
    python-dev

RUN cd /tmp \
    && wget -O watchman.tar.gz "https://github.com/facebook/watchman/archive/v${WATCHMAN_VERSION}.tar.gz" \
    && echo "$WATCHMAN_SHA256 *watchman.tar.gz" | sha256sum -c - \
    && tar -xz -f watchman.tar.gz -C /tmp/ \
    && rm -rf watchman.tar.gz

RUN cd /tmp/watchman-${WATCHMAN_VERSION} \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && cd $HOME \
    && rm -rf /tmp/*

FROM runtime AS release
COPY --from=builder /usr/local/bin/watchman* /usr/local/bin/
COPY --from=builder /usr/local/share/doc/watchman-4.9.0 /usr/local/share/doc/watchman-4.9.0
COPY --from=builder /usr/local/var/run/watchman /usr/local/var/run/watchman

# Install Python and Node, and execute the entrypoint.

FROM nikolaik/python-nodejs:latest
RUN apt update -y
RUN apt install -y colordiff
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
