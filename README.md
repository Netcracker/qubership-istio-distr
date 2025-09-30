[//]: ![logo](img/logo.png)

# Istio Deployer Overview
This repository contains an approach to installing istio in the clouds with restrictions on downloading installation resources and loading Docker images. Customization is carried out using basic istio tools, using IstioOperator CR.

### Usage of profiles.yaml
1. Purpose
Declarative configuration: You specify your desired Istio setup in YAML, can enable/disable components, set resource limits, customize ingress gateways, meshConfig, etc.
Repeatability: Easily recreate identical environments by applying the same CR.

2. Basic Workflow
From scratch it is necessary to install CRD for IstioOperator first
```
kubectl apply -f ./helm-templates/istio-deployer/crds/istio-operator.yaml
```
It is not necessary in case of manual installation, since version 1.24.0 istiocl is intended to use this CR only directly, but for case we have any automation for CR applying, need to prepare environment

Create your IstioOperator CR (profiles.yaml) with your configuration.
Apply it to your cluster:
```
kubectl apply -f profiles.yaml
```
Then run deployment Job it will install or update Istio components according to your spec.

```
helm install istio-deployer ./helm-templates/istio-deployer
```

3. Sample profiles.yaml with explanations (we use template for automation)
```
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: my-istio
  namespace: istio-system
spec:
  profile: ambient
  meshConfig:
    defaultConfig:
      proxyMetadata:
        ISTIO_META_DNS_CAPTURE: "true"  # Enable DNS capture
  components:
    ingressGateways:
      - name: istio-ingressgateway
        enabled: true
        k8s:
          service:
            type: LoadBalancer  # Expose via LoadBalancer
    pilot:
      enabled: true # Install and enable Istio control-plane
    cni:
      enabled: true  # Install and enable Istio CNI plugin
```

4. How to customize
Enabling/disabling components: Set enabled: true/false for components like istioCni, pilot, egressGateways, etc.
Configuring gateways: Customize ports, types, and hosts.
Mesh settings: Use meshConfig to set global parameters.
Resource limits: Use values to specify CPU/memory requests/limits.

Summary
The IstioOperator CR is a flexible way to manage Istio installation and configuration declaratively.
It supports granular customization of components, mesh settings, and resources.
Use it to ensure consistent, repeatable deployments.