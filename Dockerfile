FROM oven/bun:alpine AS build

WORKDIR /srv
COPY bun.lock package.json /srv/

RUN \
    bun install

COPY . /srv/

RUN \
    bun run --bun build && \
    bun build --outdir=srv --target=bun --production --minify server.ts && \
    cp -r dist/client srv/

FROM oven/bun:alpine
COPY --from=build /srv/srv/ /srv/

EXPOSE 3000
WORKDIR /srv/
ENV DOCKER_ENV=true

CMD ["bun", "server.js"]