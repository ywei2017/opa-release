#!/bin/bash

SCRIPT_PATH="$(dirname "$0")"
SCRIPT_PATH="$(cd "$SCRIPT_PATH" && pwd)"


if [[ -z "$1" ]]; then
    echo "You must provide version or full path as the only parameter"
    exit 1
fi

declare url=''
if [[ "$1" == http* ]]; then
  url=$1
else
  url="https://github.com/open-policy-agent/opa/releases/download/$1/opa_linux_amd64"
fi

rm -rf /tmp/opa_linux_amd64

curl -k -o /tmp/opa_linux_amd64 -L "$url"; chmod 755 /tmp/opa_linux_amd64

bosh add-blob /tmp/opa_linux_amd64 "opa" --dir="${SCRIPT_PATH}/../../"
rm -f /tmp/opa_linux_amd64

