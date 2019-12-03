FROM pivotalpa/angular-cli:latest
MAINTAINER "Mateusz Lewicki Atos Polska Global Services mateusz.lewicki@atos.net"

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
  && pip install virtualenv \
  && rm -rf /var/cache/apk/*
RUN pip install --upgrade pip
RUN pip install awscli
RUN pip install awscli --upgrade

