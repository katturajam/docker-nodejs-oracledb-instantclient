FROM katturaja/docker-node-oracle-base:8.12.0-slim

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