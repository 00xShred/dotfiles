#!/bin/bash

# Dieses Skript startet die ETH VPN-Verbindung über OpenConnect im Hintergrund.

sudo /usr/bin/openconnect \
  -u gduarte@student-net.ethz.ch \
  --useragent=AnyConnect \
  -g student-net \
  sslvpn.ethz.ch \
  -b
