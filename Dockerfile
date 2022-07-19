FROM python:3.9-slim-buster

LABEL org.opencontainers.image.title="Repo Keeper" \
      org.opencontainers.image.description="Configuration Keeper for GitHub Repositories." \
      org.opencontainers.image.url="https://github.com/OLeonardoRodrigues/repo-keeper/blob/main/README.md" \
      org.opencontainers.image.documentation="https://github.com/OLeonardoRodrigues/repo-keeper/wiki" \
      org.opencontainers.image.source="https://github.com/OLeonardoRodrigues/repo-keeper" \
      org.opencontainers.image.licenses="GPL-3.0-only" \
      org.opencontainers.image.vendor="Leonardo Rodrigues de Oliveira - OLeonardoRodrigues" \
      org.opencontainers.image.base.name="registry.hub.docker.com/python/python:3.9-slim-buster" \
      org.opencontainers.image.base.digest="sha256:a32a3204b2b44f3e7e699e5b4af1a5784b6a9b8a4f4446dbb8a3aa65375a8d7d"

WORKDIR /app

ENV PYTHONPATH /app

ENV GH_CONFIG_DIR /app/gh_config

RUN useradd -m python

RUN mkdir /app/gh_config \
    && chown -R python:python /app/gh_config \
    && chmod +w /app/gh_config

COPY --chown=python:python requirements.txt ./

RUN pip3 install -r requirements.txt

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install curl -y \
    && apt-get install git -y \
    && curl -L https://github.com/cli/cli/releases/download/v2.7.0/gh_2.7.0_linux_amd64.deb \
    > gh_2.7.0_linux_amd64.deb \
    && dpkg -i ./gh_2.7.0_linux_amd64.deb

COPY --chown=python:python src repo_keeper

USER python

CMD [ "python3.9", "-m" , "repo_keeper"]
