Running AI & LLM models on AKS with KAITO

KAITO-> Kubernetes AI Toolkint Operatot
Run AI and LLM Models on AKS

Why KAITO:
Provisions GPU NodePools
Helps install required Nvidia GPU drivers
Install device Plugin for GPU
un the model on the GPU Vms using vLLM
Expose an endpoint for the inferance through Kubernetes service
Scale to meet customer demand 
Monitor GPU usage
RAG engine implementation 

Demo:

Use Kaito Deploy LLM model into AKS cluster
Pre req:
AKS Cluster
Node pool with NVIDIA GPU
sku Standard_NC24ads_A100_v4 that runs Nvidia A100 GPU
LLM model to KAITO
chat with model

background:
KAITO is a CNCF Sandbox project that simplifies and optimizes your inference and tuning workloads on Kubernetes. By default, it integrates with vLLM, a high-throughput LLM inference engine optimized for serving large models efficiently.

KAITO can also run RAG workloads using RAG engine which is based on Haystack framework

infra TF set up:
Spot VM as gpu VMs are expensive
instals KAITO also
Dissabled NAP (running Karpenter) -> as already provisioned my own node pool and VMs so for full control 

CLI commands:

$RG = "rg-aks-kaito-demo"
$LOCATION = "swedencentral"
$CLUSTER_NAME = "kaito-aks-cluster"

az group create --name $RG --location $LOCATION

az aks create -g $RG -n $CLUSTER_NAME --enable-oidc-issuer
# --enable-ai-toolchain-operator

# add nodepool to the cluster with sku Standard_NC24ads_A100_v4 and type spot
# enable managed GPU Nodepool through tag `EnableManagedGPUExperience=true`
az aks nodepool add --name nc24adsa100g `
    --resource-group $RG `
    --cluster-name $CLUSTER_NAME `
    --node-vm-size Standard_NC24ads_A100_v4 `
    --tags EnableManagedGPUExperience=true `
    --node-count 1 `
    --priority Spot `
    --eviction-policy Delete `
    --enable‐cluster‐autoscaler `
    --min‐count 1 `
    --max‐count 3

az aks get-credentials -g $RG -n $CLUSTER_NAME --overwrite-existing

kubectl get nodes
# NAME                                  STATUS   ROLES    AGE     VERSION
# aks-nc24adsa100-86536742-vmss000000   Ready    <none>   4m3s    v1.33.7
# aks-systemnp-35024557-vmss000000      Ready    <none>   9m44s   v1.33.7
# aks-systemnp-35024557-vmss000001      Ready    <none>   10m     v1.33.7