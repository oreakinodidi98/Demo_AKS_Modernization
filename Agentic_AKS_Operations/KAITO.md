# Running AI & LLM Models on AKS with KAITO

**KAITO** — Kubernetes AI Toolchain Operator

## Why KAITO?

- Provisions GPU node pools
- Installs required NVIDIA GPU drivers
- Installs the device plugin for GPU
- Runs the model on GPU VMs using vLLM
- Exposes an endpoint for inference through a Kubernetes service
- Scales to meet customer demand
- Monitors GPU usage
- Supports RAG engine implementation

## Background

KAITO is a CNCF Sandbox project that simplifies and optimizes inference and tuning workloads on Kubernetes. By default, it integrates with **vLLM**, a high-throughput LLM inference engine optimized for serving large models efficiently.

KAITO can also run RAG workloads using the RAG engine, which is based on the Haystack framework.

## Demo

Deploy an LLM model into an AKS cluster using KAITO, then chat with the model.

### Prerequisites

- AKS cluster
- Node pool with NVIDIA GPU (SKU: `Standard_NC24ads_A100_v4` — runs NVIDIA A100 GPU)
- LLM model supported by KAITO

### Infrastructure Setup Notes

- **Spot VMs** — GPU VMs are expensive, so Spot is used for cost savings
- **KAITO installed** via `--enable-ai-toolchain-operator`
- **NAP (Karpenter) disabled** — node pool and VMs are pre-provisioned for full control

## CLI Commands

### Set Variables

```powershell
$RG = "rg-aks-kaito-demo"
$LOCATION = "swedencentral"
$CLUSTER_NAME = "kaito-aks-cluster"
```

### Create Resource Group and AKS Cluster

```powershell
az group create --name $RG --location $LOCATION

az aks create -g $RG -n $CLUSTER_NAME --enable-oidc-issuer --enable-ai-toolchain-operator
```

### Add GPU Node Pool (Spot)

> **Note:** The tag `EnableManagedGPUExperience=true` enables the managed GPU node pool experience.

```powershell
az aks nodepool add --name nc24adsa100g `
    --resource-group $RG `
    --cluster-name $CLUSTER_NAME `
    --node-vm-size Standard_NC24ads_A100_v4 `
    --tags EnableManagedGPUExperience=true `
    --node-count 1 `
    --priority Spot `
    --eviction-policy Delete `
    --enable-cluster-autoscaler `
    --min-count 1 `
    --max-count 3
```

### Connect to the Cluster

```powershell
az aks get-credentials -g $RG -n $CLUSTER_NAME --overwrite-existing
```

### Verify Nodes

```powershell
kubectl get nodes
```

```text
NAME                                  STATUS   ROLES    AGE     VERSION
aks-nc24adsa100-86536742-vmss000000   Ready    <none>   4m3s    v1.33.7
aks-systemnp-35024557-vmss000000      Ready    <none>   9m44s   v1.33.7
aks-systemnp-35024557-vmss000001      Ready    <none>   10m     v1.33.7
```