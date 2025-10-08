[//]: ![logo](img/logo.png)

# Istio Deployer Overview
This repository contains an approach to installing istio in the clouds with restrictions on downloading installation resources and loading Docker images. Customization is carried out using basic istio tools and IstioOperator CR.

### Usage of istio-operator.yaml
1. Purpose
Declarative configuration: You can specify your desired Istio setup in YAML, can enable/disable components, set resource limits, customize ingress gateways, meshConfig, etc.
Repeatability: Easily recreate identical environments by applying the same CR.

2. Sample istio-operator.yaml with explanations (we use template for automation)
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
How to customize:
- Enabling/disabling components: Set enabled: true/false for components like istioCni, pilot, egressGateways, etc.
- Configuring gateways: Customize ports, types, and hosts.
- Mesh settings: Use meshConfig to set global parameters.
- Resource limits: Use values to specify CPU/memory requests/limits.


### local developmnet

- Build docker image with the version of istio required to install
``` 
docker build --build-arg ISTIO_VERSION=1.27.1 -t istio-deployer:latest 
```

- Create IstioOperator CR with your configuration and wrap it into config map. The result should be placed to '.\helm-templates\istio-deployer\templates' folder

- Login to kubernetes cluster 

- Deploy the result to cluster
```
helm install istio-deployer ./helm-templates/istio-deployer
```


You can validate helm sources before deployment with command
```
helm template render .\helm-templates\istio-deployer\ --values .\helm-templates\istio-deployer\values.yaml > install.yaml
```
And apply processed file (install.yml) instead of helm install usage

The kubernetes job will run istio deployment in case of valid profile used 