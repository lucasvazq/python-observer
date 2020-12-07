# Stage I: Runtime =============================================================

# Step 1: Begin with Alpine 3.8:
FROM alpine:3.8 AS runtime

# Step 2: Install watchman runtime dependencies:
RUN apk add --no-cache libcrypto1.0 libgcc libstdc++

# Stage II: Builder ============================================================

# Step 3: Begin from runtime stage image:
FROM runtime AS builder

# Step 4: Install the watchman build dependencies' dependencies :)
RUN apk add --no-cache --update ca-certificates openssl

# Step 5: Install the watchman build dependencies:
RUN apk add --no-cache \
 automake \
 autoconf \
 bash \
 build-base \
 libtool \
 linux-headers \
 openssl-dev \
 python-dev

# Step 6: Set environment variables:
ENV WATCHMAN_VERSION=4.9.0 \
    WATCHMAN_SHA256=1f6402dc70b1d056fffc3748f2fdcecff730d8843bb6936de395b3443ce05322

# Step 7: Download watchman source code:
RUN cd /tmp \
 && wget -O watchman.tar.gz "https://github.com/facebook/watchman/archive/v${WATCHMAN_VERSION}.tar.gz" \
 && echo "$WATCHMAN_SHA256 *watchman.tar.gz" | sha256sum -c - \
 && tar -xz -f watchman.tar.gz -C /tmp/ \
 && rm -rf watchman.tar.gz

# Step 8: Build watchman from source:
RUN cd /tmp/watchman-${WATCHMAN_VERSION} \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make install \
 && cd $HOME \
 && rm -rf /tmp/*

# Stage III: Release ===========================================================

# Step 9: Begin with the runtime stage image:
FROM runtime AS release

# Step 10: Copy the compiled executable:
COPY --from=builder /usr/local/bin/watchman* /usr/local/bin/

# Step 11: Copy the documentation:
COPY --from=builder /usr/local/share/doc/watchman-4.9.0 /usr/local/share/doc/watchman-4.9.0

# Step 12: Copy the runtime directories:
COPY --from=builder /usr/local/var/run/watchman /usr/local/var/run/watchman






# Start from whatever image you are using - this is a node app example:
# // FROM node:8-alpine

# Install the packages required for watchman to work properly:
# // RUN apk add --no-cache libcrypto1.0 libgcc libstdc++

# Copy the watchman executable binary directly from our image:
# // COPY --from=icalialabs/watchman:4-alpine3.4 /usr/local/bin/watchman* /usr/local/bin/

# Create the watchman STATEDIR directory:
# RUN mkdir -p /usr/local/var/run/watchman \
#  && touch /usr/local/var/run/watchman/.not-empty

# (Optional) Copy the compiled watchman documentation:
# // COPY --from=icalialabs/watchman:4-alpine3.4 /usr/local/share/doc/watchman* /usr/local/share/doc/

FROM nikolaik/python-nodejs:latest

LABEL "repository"="https://github.com/lucasvazq/python-observant"
LABEL "homepage"="https://github.com/lucasvazq/python-observant"
LABEL "maintainer"="Lucas Vazquez <lucas5zvazquez@gmail.com>"
LABEL "com.github.actions.name"="Python-Observant"
LABEL "com.github.actions.description"="A useful tool for checking python code."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="green"

RUN apt update -y
RUN apt install -y colordiff

# Install watchman
# RUN apt install libssl-dev
# RUN apt install libcrypto1.0 libgcc libstdc++
# COPY --from=icalialabs/watchman:4-alpine3.4 /usr/local/bin/watchman* /usr/local/bin/
# RUN mkdir -p /usr/local/var/run/watchman
# RUN touch /usr/local/var/run/watchman/.not-empty

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
