#
# Builder
#
FROM golang:1.10-alpine as builder
LABEL maintainer "Pierre Verkest <pverkeset@anybox.fr>"
# This dockerfile insall caddy from source and manage plugins we needs
# the image provided by abiosoft contains http.git wich we don't want to use
# but not http.proxyprotocol which we required
# To this is mainly inspired from Abisoft' works
# https://github.com/abiosoft/caddy-docker/blob/master/Dockerfile


ARG version="0.10.12"

RUN apk add --no-cache curl git

# caddy
RUN git clone https://github.com/mholt/caddy --depth 1 -b "v${version}" /go/src/github.com/mholt/caddy \
    && cd /go/src/github.com/mholt/caddy \
    && git checkout -b "v${version}"

# http.proxyprotocol plugin
RUN go get -v -d github.com/petrus-v/caddy-proxyprotocol \
    && printf "package caddyhttp\nimport _ \"github.com/petrus-v/caddy-proxyprotocol\"" > \
        /go/src/github.com/mholt/caddy/caddyhttp/proxyprotocol.go

# builder dependency
RUN git clone https://github.com/caddyserver/builds /go/src/github.com/caddyserver/builds

# build
RUN cd /go/src/github.com/mholt/caddy/caddy \
    && git checkout -f \
    && go run build.go \
    && mv caddy /go/bin

#
# Final stage
#
FROM alpine:3.7
LABEL maintainer "Pierre Verkest <pverkeset@anybox.fr>"

RUN apk add --no-cache openssh-client ca-certificates

# install caddy
COPY --from=builder /go/bin/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html /srv/index.html

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/caddy/Caddyfile", "--log", "stdout"]
