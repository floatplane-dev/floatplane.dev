# Docs:
# https://docs.docker.com/engine/reference/builder/

# Debian image
FROM debian

# Install Git
RUN apt-get update
RUN apt-get --yes install git
RUN apt-get --yes install curl
# RUN apt-get --yes install awscli

# Install NVM and Node
# Inspired from https://hub.docker.com/r/rubensa/nvm-dev/dockerfile
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=7.10.1
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}\
 && . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}\
 && . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}\
 && node --version && npm --version

# Install Yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
ENV PATH="/root/.yarn/bin:/root/.config/yarn/global/node_modules/.bin:${PATH}"
RUN yarn --version
