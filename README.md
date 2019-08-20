[![Build Status](https://travis-ci.org/anybox/caddy-docker.svg?branch=master)](
https://travis-ci.org/anybox/caddy-docker)

# Caddy docker image builder

Caddy docker image (caddy is build from source).

This dockerfile insall [caddy server](https://github.com/caddyserver/caddy)
and plugins from source according our needs.

This works is mainly inspired from **[Abisoft](
https://github.com/abiosoft)**'s works in his [caddy-docker](
https://github.com/abiosoft/caddy-docker) project.

Abiosoft image contains ``http.git`` pligin wich we don't
use. Anybox's image contains ``http.proxyprotocol`` from a different
repo than the one provided by caddy.

## How to use


This is a most basic run using Caddyfile provide in this repo:

```bash
docker run -it anybox/caddy:1.0.3
```

You may mount your own ``Caddyfile`` (the caddy configuration):

```bash
docker run -it \
    -v "$(pwd)/conf/Caddyfile":/etc/caddy/Caddyfile \
    anybox/caddy:1.0.3
```

Consult caddy server to learn about [Caddyfile format](
https://caddyserver.com/docs)

## Image building

This image is build every day by [travis](
https://travis-ci.org/anybox/caddy-docker) and push in case of success
to the [anybox/caddy on docker hub](
https://hub.docker.com/r/anybox/caddy/).
