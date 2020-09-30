FROM python:3-slim

LABEL "com.github.actions.name"="Auto-linter"
LABEL "com.github.actions.description"="Python linter checker"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="green"

# LABEL "repository"="https://github.com/lgeiger/pyflakes-action"
# LABEL "homepage"="https://github.com/lgeiger/pyflakes-action"
# LABEL "maintainer"="Lukas Geiger <lukas.geiger94@gmail.com>"

RUN pip install pyflakes
RUN python --version ; pip --version ; pylint --version

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# CMD ["pyflakes", "."]
