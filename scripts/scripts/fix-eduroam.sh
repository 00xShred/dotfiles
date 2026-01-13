#!/bin/sh
nmcli con modify eduroam \
  802-1x.anonymous-identity "" \
  802-1x.ca-cert /etc/ssl/certs/ca-certificates.crt \
  wifi.mac-address-randomization 1 \
  802-1x.phase1-peapver 0
