package main

import (
	"github.com/caddyserver/caddy/caddy/caddymain"

	// plugins list:
	_ "github.com/mastercactapus/caddy-proxyprotocol"
	_ "github.com/freman/caddy-reauth"
)

func main() {
	// optional: disable telemetry
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
