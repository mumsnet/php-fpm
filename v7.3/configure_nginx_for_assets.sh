#!/usr/bin/env bash

if [ $# -lt 1 -o $# -gt 2 ]; then
  echo "usage: $0 <service url prefix> [ <asset file/folder patterns> ]"
  exit 1
fi

SRV_URL_PREFIX="$1"
ASSET_PATTERNS="assets/css/|assets/js/|assets/images/|assets/fonts/|mix-manifest.json"
if [ $# -eq 2 ]; then
  ASSET_PATTERNS="$2"
fi

if [ "${SRV_URL_PREFIX::1}" != "/" -o "${SRV_URL_PREFIX: -1}" == "/" ]; then
  echo "service url prefix must begin with slash (/) and must NOT end with a slash."
  exit 1
fi

echo "Configuring nginx to strip the prefix before serving assets:"
echo "    SRV_URL_PREFIX = $SRV_URL_PREFIX"
echo "    ASSET_PATTERNS = $ASSET_PATTERNS"
sed -i -e "s%SRV_URL_PREFIX%$SRV_URL_PREFIX%g" -e "s%ASSET_PATTERNS%$ASSET_PATTERNS%g" /etc/nginx/nginx.conf
