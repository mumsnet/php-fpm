#!/usr/bin/env bash

if [ $# -lt 2 -o $# -gt 4 ]; then
  echo "usage: $0 <service url prefix> <dev | prod> [ <asset file/folder patterns> ]  [ <manifest file patterns> ]"
  exit 1
fi

SRV_URL_PREFIX="$1"
DEPLOY_ENV="$2"

ASSET_PATTERNS="assets/css/|assets/js/|assets/images/|assets/fonts/"
if [ $# -gt 2 ]; then
  ASSET_PATTERNS="$3"
fi

MANIFEST_PATTERNS="mix-manifest.json"
if [ $# -gt 3 ]; then
  MANIFEST_PATTERNS="$4"
fi

if [ "${SRV_URL_PREFIX::1}" != "/" -o "${SRV_URL_PREFIX: -1}" == "/" ]; then
  echo "service url prefix must begin with slash (/) and must NOT end with a slash."
  exit 1
fi

if [ "$DEPLOY_ENV" != "dev" -a "$DEPLOY_ENV" != "prod" ]; then
  echo "dev or prod are the only accepted values for the 2nd parameter."
  exit 1
fi

MAX_AGE=31536000
if [ "$DEPLOY_ENV" == "dev" ]; then
  MAX_AGE="no-store"
fi

echo "Configuring nginx to strip the prefix before serving assets:"
echo "    SRV_URL_PREFIX    = $SRV_URL_PREFIX"
echo "    ASSET_PATTERNS    = $ASSET_PATTERNS"
echo "    MANIFEST_PATTERNS = $MANIFEST_PATTERNS"
echo "    Cache-Control     = $MAX_AGE"
sed -i \
  -e "s%SRV_URL_PREFIX%$SRV_URL_PREFIX%g" \
  -e "s%ASSET_PATTERNS%$ASSET_PATTERNS%g" \
  -e "s%MANIFEST_PATTERNS%$MANIFEST_PATTERNS%g" \
  -e "s%31536000%$MAX_AGE%g" \
  /etc/nginx/nginx.conf
