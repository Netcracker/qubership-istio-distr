#!/bin/bash

cd /workspace

if ! kubectl get IstioOperator; then
 kubectl apply -f /workspace/crds/istio-operator.yaml
fi

kubectl get IstioOperator istio-ambient-install -n istio-system -o yaml > istio-install.yaml

cat istio-install.yaml

istioctl install -y -f istio-install.yaml \