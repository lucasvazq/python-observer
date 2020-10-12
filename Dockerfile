FROM nikolaik/python-nodejs:latest

LABEL "com.github.actions.name"="Auto-linter"
LABEL "com.github.actions.description"="Python linter checker"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="green"

LABEL "repository"="https://github.com/lucasvazq/auto-linter"
LABEL "homepage"="https://github.com/lucasvazq/auto-linter"
LABEL "maintainer"="Lucas Vazquez <lucas5zvazquez@gmail.com>"

RUN python --version
RUN pip --version
# RUN apt update -y
RUN apt install -y colordiff

ENTRYPOINT ["/bin/echo", "Hello world"]
# COPY entrypoint.sh /
# RUN chmod +x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]
