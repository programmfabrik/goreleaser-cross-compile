ARG VERSION
FROM goreleaser/goreleaser-cross:${VERSION}

RUN apt update && \
    apt upgrade -y

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get install nodejs

RUN node -v
RUN npm -v

RUN chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

RUN npm install -g sass
