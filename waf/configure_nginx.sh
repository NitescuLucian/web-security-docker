#!/bin/sh -e
export SEC_RULE_ENGINE=${SEC_RULE_ENGINE:-DetectionOnly}
export HTTP_VERSION=${HTTP_VERSION:-1.1}
export TARGET_SCHEME=${TARGET_SCHEME:-http}
export TARGET_PORT=${TARGET_PORT:-80}
export TARGET_HOST=${TARGET_HOST:-proxyapp}
export TARGET_HOST_HEADER=${TARGET_HOST_HEADER:-${TARGET_HOST}}
export CLIENT_MAX_BODY_SIZE=${CLIENT_MAX_BODY_SIZE:-20M}
export SSL_PORT=${SSL_PORT:-443}

REPLACEABLE='$SEC_RULE_ENGINE:$HTTP_VERSION:$TARGET_SCHEME:$TARGET_PORT:$TARGET_HOST:$TARGET_HOST_HEADER:$CLIENT_MAX_BODY_SIZE:$SSL_PORT'

envsubst $REPLACEABLE < /nginx.conf.template > /usr/local/nginx/conf/nginx.conf
envsubst $REPLACEABLE < /modsecurity.conf.template > /usr/local/nginx/conf/modsecurity.conf

/add_self_signed_certs.sh

# Use exec so nginx can get signals directly
exec nginx
