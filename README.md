# Docker NodeJs + Oracledb instantclient base image

Nodejs with oracledb instantclient library used to build the docker image.

Extend the docker image as a base image to build your nodejs of oracledb application.

Supported tags and respective Dockerfile links

[Nodejs 8.12.0-slim](https://hub.docker.com/_/node/ "Docker nodejs") + [node-oracledb](https://github.com/oracle/node-oracledb "Oracle Node JS Client") supported from 2.3.0.


# Usage to build your apps

```
FROM katturaja/docker-nodejs-oracledb-instantclient:8.12.0-slim
# Create app base directory
RUN mkdir -p /src

# Specify the "working directory" for the rest of the Dockerfile
WORKDIR /src

COPY . /src

# clean
RUN npm cache clean -f \
&& npm install --only=prod

EXPOSE 3000
CMD ["node", "server.js"]
```
