#!/usr/bin/env bash
set -Eeuo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

info() {
  echo -e "${GREEN}INFO: ${1}${NC}"
}

warning() {
  echo -e "${YELLOW}WARNING: ${1}${NC}"
}

error() {
  ERROR_CODE=${2}
  echo -e "${RED}ERROR: ${1}${NC}" >&2
  exit "$ERROR_CODE"
}

if [[ $# -eq 0 ]]; then
  error "No module name provided" 1
fi

if [[ -d "modules/${1}" ]]; then
  error "Module ${1} already exists" 1
fi

mkdir -p "modules/${1}"
pushd "modules/${1}"
touch \
  CHANGELOG.md \
  README.md \
  data.tf \
  locals.tf \
  main.tf \
  outputs.tf \
  providers.tf \
  variables.tf \
  versions.tf
popd

ln -sfn "$(pwd)/modules/.global/global-variables.tf" "modules/${1}/global-variables.tf"
ln -sfn "$(pwd)/modules/.global/global-locals.tf" "modules/${1}/global-locals.tf"

yq -iP ". + {\"modules/${1}\": \"0.0.0\"}" \
  .release-please-manifest.json -o json

yq -iP ".packages += {\"modules/${1}\": {\"package-name\": \"${1//\//-}\"}}" \
  release-please-config.json -o json

git add "modules/${1}"
git add .release-please-manifest.json release-please-config.json
