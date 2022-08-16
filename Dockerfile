ARG VERSION
FROM goreleaser/goreleaser-cross:${VERSION}

RUN apt update && \
    apt upgrade -y

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

RUN apt-get install nodejs

RUN node -v
RUN npm -v

RUN chown -R 1000:1000 "/root/.npm"
RUN npm install -g dart-sass