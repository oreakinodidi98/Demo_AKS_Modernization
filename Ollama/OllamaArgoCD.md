# Deploying Ollama on Kubernetes with ArgoCD

> Run large language models on your cluster the same way you run any other workload  GitOps-managed, GPU-aware, and ready for your team.

---

## Why Ollama

Ollama turns running a large language model into something as simple as pulling a container image. It handles model downloads, quantization, and serving behind a clean REST API — no ML platform expertise required.

**vLLM** is built for maximum throughput in production inference pipelines. **Ollama** is built for ease of use. If your goal is internal tools, dev environments, or giving your team LLM capabilities without the overhead of a full ML serving stack — Ollama is the right choice.

Deploying it through **ArgoCD** means your LLM service is GitOps-managed: version-controlled, declarative, and auditable — the same operational model you already use for everything else on the cluster.

---

## What This Guide Covers

This guide walks through deploying Ollama on Kubernetes with ArgoCD, including:

- **Model management** — downloading, serving, and swapping models
- **GPU configuration** — scheduling onto GPU nodes and setting resource limits
- **Scaling for team use** — making the service reliable for multiple consumers

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                    Developers / Applications                     │
└──────────────────────────┬───────────────────────────────────────┘
                           │ HTTP Requests
                           ▼
              ┌────────────────────────┐
              │        Ingress         │
              └────────────┬───────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │     Ollama Service     │
              └─────┬────────────┬─────┘
                    │            │
          ┌─────────▼──┐    ┌───▼─────────┐
          │ Ollama Pod 1│    │ Ollama Pod 2│
          │             │    │             │
          │  ┌───────┐  │    │  ┌───────┐  │
          │  │  GPU  │  │    │  │  GPU  │  │
          │  └───────┘  │    │  └───────┘  │
          └──────┬──────┘    └──────┬──────┘
                 │                  │
          ┌──────▼──────┐    ┌──────▼──────┐
          │ Model Store │    │ Model Store │
          │    (PVC)    │    │    (PVC)    │
          └─────────────┘    └─────────────┘
```

Each Ollama pod runs a server that handles downloading, loading, and serving models. Every pod gets its own **PVC** for model storage — and models are loaded into **GPU** (or CPU) memory on demand.

---

## Demo Flow

This demo progresses from the simplest deployment to a production-ready setup. Each file builds on the last — start at the top and work your way down.

```
 Simple                                                    Advanced
   │                                                          │
   ▼                                                          ▼
DevDeploy ──► DevDeployScale ──► ProdDeploy ──► PreloadDeploy ──► PreloadDeployConfig
   │               │                │                │                    │
   │               │                │                │                    ▼
   │               │                │                │              model-config
   │               │                │                │              CustomModelfiles
   │               │                │                │
   └───────────────┴────────────────┴────────────────┴──► ingress
                                                          monitor
                                                          CallApi.py
```

---

## Files in This Demo

| File | Purpose |
|---|---|
| `DevDeploy.yaml` | Simplest deployment — single replica, CPU-only, PVC for model storage, ClusterIP service |
| `DevDeployScale.yaml` | Scales to 3 replicas with **ReadWriteMany** shared storage so all pods share the model cache |
| `ProdDeploy.yaml` | Adds **GPU support** — NVIDIA GPU requests, node selector, and tolerations for GPU node pools |
| `PreloadDeploy.yaml` | Adds an **init container** that pulls models (inline script) before the main container starts — no first-request latency |
| `PreloadDeployConfig.yaml` | Same preloading pattern but reads the model list from a **ConfigMap** — easier to maintain |
| `model-config.yaml` | ConfigMap with the model list and pull script used by `PreloadDeployConfig.yaml` |
| `CustomModelfiles.yaml` | Custom Modelfiles that set system prompts and parameters for specific use cases (code assistant, support agent) |
| `ingress.yaml` | Exposes Ollama externally with **TLS**, **basic auth**, and streaming support |
| `monitor.yaml` | CronJob that health-checks Ollama every 5 minutes and alerts Slack if it's down |
| `CallApi.py` | Python examples for calling the Ollama API — basic generation, chat, and OpenAI-compatible endpoints |

---

### Stage 1: Basic Dev Deployment — `DevDeploy.yaml`

The starting point. A single Ollama pod running on **CPU only** with a 100Gi PVC for model storage. Good for kicking the tires — pull a model manually with `ollama pull` and start sending requests.

- 1 replica, no GPU
- `OLLAMA_KEEP_ALIVE=24h` — keeps models in memory between requests
- `OLLAMA_NUM_PARALLEL=4` — handles up to 4 concurrent requests
- Health and readiness probes included

---

### Stage 2: Scaling for Teams — `DevDeployScale.yaml`

Same config, but scaled to **3 replicas** with a **ReadWriteMany** PVC so all pods share one model cache. This avoids every pod downloading models independently.

- 3 replicas behind the same `dev-ollama` service
- Uses `efs` storage class (or any RWX-capable class)
- 200Gi shared storage

---

### Stage 3: GPU-Accelerated — `ProdDeploy.yaml`

Moves inference onto **GPU nodes**. Requests an NVIDIA GPU per pod and targets A10G nodes specifically. This is where you see real performance — a 7B model on GPU is an order of magnitude faster than CPU.

- `nvidia.com/gpu: 1` in requests and limits
- `nodeSelector` targets `NVIDIA-A10G` nodes
- Tolerations let the pod schedule on GPU-tainted nodes
- 16Gi memory request / 32Gi limit to handle model loading

---

### Stage 4: Model Preloading (Inline) — `PreloadDeploy.yaml`

Adds an **init container** that starts Ollama temporarily, pulls all required models, then shuts down — before the main container ever starts. No first-request latency, no surprise downloads.

- Init container pulls: `llama3.1:8b`, `mistral:7b`, `codellama:13b`, `nomic-embed-text`
- Shares the same PVC with the main container
- GPU-enabled (same A10G setup as Stage 3)

---

### Stage 5: Model Preloading (ConfigMap) — `PreloadDeployConfig.yaml` + `model-config.yaml`

Same preloading concept, but the model list and pull script live in a **ConfigMap** instead of being hardcoded in the deployment. Update the model list without touching the deployment manifest.

- `model-config.yaml` — defines the model list and a reusable pull script
- Init container mounts the ConfigMap and runs the script
- Add or remove models by editing one ConfigMap

---

### Custom Modelfiles — `CustomModelfiles.yaml`

Defines **purpose-built models** with custom system prompts and parameters:

- **`code-assistant`** — built on Code Llama 13B, low temperature (0.2) for precise code generation
- **`support-agent`** — built on Llama 3.1 8B, higher temperature (0.7) for natural conversation

Create these with `ollama create code-assistant -f /config/code-assistant.modelfile` inside the pod.

---

### Ingress — `ingress.yaml`

Exposes Ollama outside the cluster with:

- **TLS** termination
- **Basic auth** via a Kubernetes secret
- **Extended timeouts** (300s) — LLM responses can take a while
- **Proxy buffering disabled** — enables streaming responses

---

### Monitoring — `monitor.yaml`

A **CronJob** that runs every 5 minutes, checks Ollama's health endpoint, lists loaded models, and posts to **Slack** if the service is down.

---

### Calling the API — `CallApi.py`

Python examples showing three ways to talk to Ollama:

1. **`/api/generate`** — simple prompt-in, response-out
2. **`/api/chat`** — chat completion with a custom model
3. **OpenAI-compatible endpoint** — use the OpenAI Python SDK with Ollama as the backend (commented example)

---

## ArgoCD Application

This is the ArgoCD Application manifest that manages the Ollama deployment. Point it at your Git repo, and ArgoCD handles the rest — syncing, pruning, and self-healing automatically.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ollama
  namespace: argocd
spec:
  project: ml-platform
  source:
    repoURL: https://github.com/myorg/ml-gitops.git  # Replace with your repo
    targetRevision: main
    path: apps/ollama
  destination:
    server: https://kubernetes.default.svc
    namespace: llm-serving
  syncPolicy:
    automated:
      prune: true       # Remove resources deleted from Git
      selfHeal: true     # Revert manual cluster changes
    syncOptions:
      - CreateNamespace=true
  ignoreDifferences:
    - group: apps
      kind: Deployment
      jsonPointers:
        - /spec/replicas  # Let HPA manage replica count
```

**Key things to note:**

- **`selfHeal: true`** — if someone manually changes something on the cluster, ArgoCD reverts it back to what's in Git
- **`prune: true`** — resources you delete from Git get cleaned up on the cluster automatically
- **`ignoreDifferences` on replicas** — lets your HPA scale pods without ArgoCD fighting it

---

## Best Practices

| Practice | Why It Matters |
|---|---|
| **Preload models with init containers** | First-request downloads cause unacceptable latency — pull models *before* the main container starts |
| **Use persistent storage (PVCs)** | Models survive pod restarts without re-downloading every time |
| **Set `OLLAMA_KEEP_ALIVE`** | Keeps models loaded in memory between requests so you avoid reload latency |
| **Right-size GPU memory** | A 7B model needs ~4GB GPU RAM (quantized). A 13B model needs ~8GB. Over-provision and you waste expensive GPU; under-provision and inference fails |
| **Use custom Modelfiles** | Customize system prompts and parameters for specific use cases instead of tweaking at request time |
| **Authenticate the API** | Never expose Ollama without auth — even internally. Use an ingress auth layer or network policy |
| **Monitor model loading** | Track which models are loaded and how long loading takes so you can catch issues early |
| **Use ReadWriteMany for shared storage** | When running multiple replicas, RWX storage classes let all pods share the same model cache instead of each downloading separately |

---

## Summary

Ollama with ArgoCD gives you a simple, reliable LLM serving platform managed through GitOps. Models are tracked in Git, deployments are automated, and your team gets self-service access to LLM capabilities — without managing GPU infrastructure themselves.