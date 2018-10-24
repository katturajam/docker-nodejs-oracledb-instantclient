# node-oracle-base

The image built for nodejs with oracle db support.
Extend or Use the image to build your nodejs of oracledb application.

Supported tags and respective Dockerfile links
8.12.0-slim and nodejs oracle db supported from 2.3.0

# Usage to build your apps

```FROM katturaja/docker-node-oracle-base:8.12.0-slim

## BUILD ARGUMENTS AND APPLICATION
ARG NPM_TOKEN
ARG NPM_LOG_LEVEL

## Create app base directory
RUN mkdir -p /src

## Specify the "working directory" for the rest of the Dockerfile
WORKDIR /src

COPY . /src

# clean
RUN npm cache clean -f \
&& npm install --only=prod

EXPOSE 3000
CMD ["node", "server.js"]```
