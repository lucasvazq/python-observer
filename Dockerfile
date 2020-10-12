FROM nikolaik/python-nodejs:latest

LABEL "com.github.actions.name"="Python-Observant"
LABEL "com.github.actions.description"="A tool to check python code."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="green"

LABEL "repository"="https://github.com/lucasvazq/python-observant"
LABEL "homepage"="https://github.com/lucasvazq/python-observant"
LABEL "maintainer"="Lucas Vazquez <lucas5zvazquez@gmail.com>"

RUN apt update -y
RUN apt install -y colordiff
RUN apt install -y watchman

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
