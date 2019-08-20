#
# Builder
#
FROM golang:1.12-alpine as builder
LABEL maintainer "Pierre Verkest <pverkeset@anybox.fr>"
# This dockerfile insall caddy from source and manage plugins we needs
# the image provided by abiosoft contains http.git wich we don't want to use
# but not http.proxyprotocol which we required
# To this is mainly inspired from Abisoft' works
# https://github.com/abiosoft/caddy-docker/blob/master/Dockerfile

ARG version="1.0.3"
ENV GO111MODULE=on

RUN apk add --no-cache curl git \
        && mkdir -p caddy

WORKDIR /go/caddy
COPY caddy.go caddy.go

RUN go mod init caddy \
        && go get -v github.com/caddyserver/caddy@v${version}

# build
RUN go build \
        && mv caddy /go/bin

#
# Final stage
#
FROM alpine:3.10
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
