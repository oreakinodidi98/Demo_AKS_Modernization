# AKS Modernization & AI Operations — Demo Repository

> Scripts, manifests, and step-by-step guides for running production-grade AKS workloads — from cluster provisioning and app modernization to GPU-powered AI inference and agentic operations.

---

## What This Repo Covers

This is a hands-on demo repository. Each folder is a self-contained scenario with its own setup scripts, manifests, and documentation. The focus areas break down into four pillars:

| Pillar | Folders | What You Get |
|---|---|---|
| **AI & LLM on Kubernetes** | `AKS_KAITO/`, `AKS_Ollama/`, `AKS_Ray/` | Deploy and serve LLM models, run distributed AI/ML training and inference on AKS |
| **Agentic AKS Operations** | `Agentic_AKS_Operations/`, `AKS_Agent/`, `AKS_CLI/` | AI-powered cluster management, troubleshooting, and agent skills |
| **App Modernization & Migration** | `AKS_APPMod/`, `AKS_App_Routing/`, `AKS_Appgateway/`, `AGC_Migration_Utility/` | Containerize apps, migrate ingress controllers, modernize with Copilot |
| **Infrastructure & Platform** | `AKS_terraform/`, `AKS_Automatic/`, `ARO/`, `ARO_MCP/`, `AKS_SelfHostedGHActionRunners/`, `policies/` | Terraform IaC, AKS Automatic, Azure Red Hat OpenShift, CI/CD runners, OPA policies |

---

## Repo Structure

### [`AKS_KAITO/`](AKS_KAITO/)
Deploy LLM models on AKS using the **Kubernetes AI Toolchain Operator**. KAITO handles GPU node provisioning, NVIDIA driver installation, vLLM inference engine setup, and service exposure — all from a single `Workspace` CRD. Includes workspace manifests for Phi-4, DeepSeek, GPT-OSS, and SmolLM2 models.

- [`AKS_KAITO/RAG/`](AKS_KAITO/RAG/) — RAG applications using KAITO's RAGEngine backed by the Haystack framework
- [`AKS_KAITO/headlamp/`](AKS_KAITO/headlamp/) — KAITO with Headlamp UI for visual cluster and model management

### [`AKS_Ollama/`](AKS_Ollama/)
Run open-source LLMs on Kubernetes using **Ollama** — the easy-to-use, self-hosted alternative. Covers CPU and GPU deployments, model management, and scaling.

- [`AKS_Ollama/OllamaArgoCD/`](AKS_Ollama/OllamaArgoCD/) — GitOps-managed Ollama deployments with ArgoCD, including dev/prod configurations, ingress, monitoring, and Python API scripts

### [`AKS_Ray/`](AKS_Ray/)
**AI and ML workloads on AKS using Ray and KubeRay.** Covers distributed training with Ray Train, model serving with Ray Serve, data processing with Ray Data, and BlobFuse storage integration. Includes Terraform IaC for cluster provisioning, RayCluster manifests, RayJob specs, and autoscaling configuration.

### [`Agentic_AKS_Operations/`](Agentic_AKS_Operations/)
Agentic AI for Kubernetes operations. Shows how to move from *AI-assisted search* to *AI-native action* — where agents have authenticated, real-time access to cluster state via MCP (Model Context Protocol). Covers the AKS Agentic CLI, MCP server architecture, and the skills + context + action layer model.

### [`AKS_Agent/`](AKS_Agent/)
**Agent Skills for AKS** — modular packages that give AI agents (GitHub Copilot, Claude, Gemini) domain-specific AKS expertise. Covers best practices, troubleshooting playbooks, and Day-0 checklists that activate only when relevant.

### [`AKS_CLI/`](AKS_CLI/)
Setup guides for the **AKS Agentic CLI** in both deployment modes:
- **Client mode** — runs locally via Docker using your Azure credentials (dev/testing)
- **Cluster mode** — deploys the agent as a pod inside AKS using Helm (production/shared environments)

### [`AKS_APPMod/`](AKS_APPMod/)
**Application Modernization** demo using the Spring PetClinic application. Uses GitHub Copilot app modernization to assess, remediate, and containerize a Spring Boot app for AKS — including Dockerfile generation, Kubernetes manifests, and passwordless Azure database authentication.

### [`AKS_App_Routing/`](AKS_App_Routing/)
**Ingress migration** from a self-managed (BYO) Nginx Ingress Controller to the AKS-managed App Routing Add-On. The standalone Nginx Ingress Controller was retired in March 2026 — this demo shows the complete zero-downtime migration path using parallel running.

### [`AKS_Appgateway/`](AKS_Appgateway/)
**Application Gateway for Containers (AGC)** — deploy the AGC ALB controller into your AKS cluster. Covers managed and bring-your-own deployment strategies.

### [`AGC_Migration_Utility/`](AGC_Migration_Utility/)
**AGC Migration Utility** — tooling to assess and migrate Nginx ingress configurations to Azure Application Gateway for Containers. Includes example YAML manifests and a PowerShell script to run dry-run migration reports.

### [`AKS_terraform/`](AKS_terraform/)
**Terraform IaC** for provisioning an AKS cluster with supporting infrastructure — Key Vault, Log Analytics, Application Insights. Modular structure with separate modules for AKS, Key Vault, and monitoring.

### [`AKS_Automatic/`](AKS_Automatic/)
**AKS Automatic** cluster provisioning via Terraform. AKS Automatic is the fully managed, opinionated AKS experience — Microsoft handles node management, scaling, and security configuration. IaC included for repeatable deployments.

### [`ARO/`](ARO/)
**Azure Red Hat OpenShift** setup notes and scripts. Covers cluster provisioning, VNet/subnet requirements, and Red Hat Developer Lightspeed — AI-powered application modernization using Migration Toolkit for Applications (MTA).

### [`ARO_MCP/`](ARO_MCP/)
**MCP server setup for ARO** — configure the Azure MCP Server to give AI agents authenticated access to Azure Red Hat OpenShift resources via VS Code.

### [`AKS_SelfHostedGHActionRunners/`](AKS_SelfHostedGHActionRunners/)
**Self-hosted GitHub Actions runners on Kubernetes** using Actions Runner Controller (ARC). Scale runners dynamically inside your cluster — jobs spin up pods, pods die when done. No idle compute, no per-minute billing.

### [`policies/`](policies/)
**OPA Rego policies** for container security — e.g., enforcing that all Dockerfile base images must come from `mcr.microsoft.com`.

---

## Prerequisites

Most demos require some combination of:

| Requirement | Details |
|---|---|
| **Azure CLI** | `az` installed and authenticated |
| **kubectl** | Connected to your AKS cluster |
| **Helm 3** | For chart-based deployments |
| **Docker Desktop** | For local container builds and client-mode agents |
| **PowerShell** | Scripts are written for PowerShell |

Each folder's own documentation lists the specific prerequisites for that demo.

---

## Getting Started

1. Clone the repo
2. Pick the scenario you want to run
3. Read the folder's documentation (`demo.md`, `readme.md`, or the relevant `.md` file)
4. Run the setup script (`setup.ps1` or equivalent)

Most demos are designed to be run independently — you don't need to follow a specific order.
