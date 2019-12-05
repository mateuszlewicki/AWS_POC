FROM node:current-alpine
MAINTAINER "Mateusz Lewicki Atos Polska Global Services mateusz.lewicki@atos.net"
# install angular-cli as node user
RUN chown -R node:node /usr/local/lib/node_modules \
  && chown -R node:node /usr/local/bin

USER node
RUN npm install -g @angular/cli

# set npm as default package manager for root
USER root
#RUN ng set --global packageManager=npm

# install chromium for headless browser tests
ENV CHROME_BIN=/usr/bin/chromium-browser
RUN apk add --no-cache chromium udev ttf-freefont


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

