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
RUN apt install libssl-dev
RUN apt install libcrypto1.0 libgcc libstdc++
COPY --from=icalialabs/watchman:4-alpine3.4 /usr/local/bin/watchman* /usr/local/bin/
RUN mkdir -p /usr/local/var/run/watchman
RUN touch /usr/local/var/run/watchman/.not-empty

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
