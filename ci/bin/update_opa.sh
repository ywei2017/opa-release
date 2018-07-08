#!/bin/bash

SCRIPT_PATH="$(dirname "$0")"
SCRIPT_PATH="$(cd "$SCRIPT_PATH" && pwd)"

local version

version=${1}

rm -r /tmp/opa_linux_amd64

wget --directory-prefix=/tmp -c "https://github.com/open-policy-agent/opa/releases/download/${version}/opa_linux_amd64"

bosh add-blob /tmp/opa_linux_amd64 "opa" --dir="${SCRIPT_PATH}/../../"

