#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

BIN_DIR=$(cat .bin_dir)

export PATH="${BIN_DIR}:${PATH}"

source "${SCRIPT_DIR}/validation-functions.sh"

if ! command -v oc 1> /dev/null 2> /dev/null; then
  echo "oc cli not found" >&2
  exit 1
fi

if ! command -v kubectl 1> /dev/null 2> /dev/null; then
  echo "kubectl cli not found" >&2
  exit 1
fi

if ! command -v ibmcloud 1> /dev/null 2> /dev/null; then
  echo "ibmcloud cli not found" >&2
  exit 1
fi

export KUBECONFIG=$(cat .kubeconfig)
NAMESPACE=$(jq -r '.cpd_namespace // "gitops-cp-db2"' gitops-output.json)
COMPONENT_NAME=$(jq -r '.name // "my-module"' gitops-output.json)
BRANCH=$(jq -r '.branch // "main"' gitops-output.json)
SERVER_NAME=$(jq -r '.server_name // "default"' gitops-output.json)
LAYER=$(jq -r '.layer_dir // "2-services"' gitops-output.json)
TYPE=$(jq -r '.type // "base"' gitops-output.json)
CPD_NAMESPACE="cp4d"

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

set -e

# sleep so that the db2wh operator and service can be deployed
sleep 5m

check_k8s_namespace "${CPD_NAMESPACE}"
check_k8s_resource "${CPD_NAMESPACE}" "job" "cp-db2-job"



