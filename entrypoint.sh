#!/bin/bash

set -xe

echo "$KUBE_CONFIG" | base64 -d > /tmp/kube_config
export KUBECONFIG=/tmp/kube_config

sed -i "s/RELEASE_IMAGE/$RELEASE_IMAGE/g" apps/$APPLICATION/$ENVIRONMENT-values.yaml

if [ ${HELM_ACTION} == 'install' ]; then
    helm upgrade $APPLICATION apps/$APPLICATION/ --namespace $KUBE_NAMESPACE -f apps/$APPLICATION/$ENVIRONMENT-values.yaml
fi

if [ ${HELM_ACTION} == 'upgrade' ]; then
    helm upgrade $APPLICATION apps/$APPLICATION/ --namespace $KUBE_NAMESPACE -f apps/$APPLICATION/$ENVIRONMENT-values.yaml
fi
