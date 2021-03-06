#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

export KUBECONFIG=$(cat .kubeconfig)
NAMESPACE=$(jq -r '.cpd_namespace // "gitops-cp4d-instance"' gitops-output.json)
COMPONENT_NAME=$(jq -r '.name // "my-module"' gitops-output.json)
BRANCH=$(jq -r '.branch // "main"' gitops-output.json)
SERVER_NAME=$(jq -r '.server_name // "default"' gitops-output.json)
LAYER=$(jq -r '.layer_dir // "2-services"' gitops-output.json)
TYPE=$(jq -r '.type // "base"' gitops-output.json)

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

if [[ ! -f "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml" ]]; then
  echo "ArgoCD config missing - argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
  exit 1
fi

echo "Printing argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
cat "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"

if [[ ! -f "payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml" ]]; then
  echo "Application values not found - payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"
  exit 1
fi

echo "Printing payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"
cat "payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"

count=0
until kubectl get namespace "${NAMESPACE}" 1> /dev/null 2> /dev/null || [[ $count -eq 20 ]]; do
  echo "Waiting for namespace: ${NAMESPACE}"
  count=$((count + 1))
  sleep 15
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for namespace: ${NAMESPACE}"
  exit 1
else
  echo "Found namespace: ${NAMESPACE}. Sleeping for 30 seconds to wait for everything to settle down"
  sleep 30
fi

RESOURCE01="db2oltp"

count=0

SS_COUNT=$(kubectl get statefulset -l icpdsupport/addOnId=${RESOURCE01} -n "${NAMESPACE}"|wc -l)

until [[ `expr ${SS_COUNT} + 0`>0 ]] || [[ $count -eq 26 ]]; do
  echo "Waiting for statefulset  in ${NAMESPACE}"
  SS_COUNT=$(kubectl get statefulset -l icpdsupport/addOnId=${RESOURCE01} -n "${NAMESPACE}"|wc -l)
  echo "SSCount: ${SS_COUNT}"
  count=$((count + 1))
  sleep 45
done
STATEFULSET=$(kubectl get statefulset -l icpdsupport/addOnId=${RESOURCE01} -n "${NAMESPACE}" | grep ${RESOURCE01} | awk -v k="text" '{n=split($0,a," "); print a[1]}')
echo "Waiting for Statefulset: ${STATEFULSET}"
if [[ $count -eq 26 ]]; then
  echo "Timed out waiting for  statefulset ${STATEFULSET} in ${NAMESPACE}"
  kubectl get all -n "${NAMESPACE}" 
  exit 1
fi

#kubectl get all -l icpdsupport/addOnId=${RESOURCE01} -n "${NAMESPACE}"|| exit 1
#kubectl wait --for=condition=complete job/${JOB} || exit 1
kubectl rollout status "statefulset/"${STATEFULSET} -n "${NAMESPACE}" || exit 1

cd ..
rm -rf .testrepo
