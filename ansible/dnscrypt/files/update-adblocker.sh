#!/bin/bash
DEST="/etc/dnscrypt-proxy/blacklist.txt"
SRC="https://download.dnscrypt.info/blacklists/domains/mybase.txt"
wget --timeout=10 --tries=5 -qO "${DEST}" "${SRC}" 
