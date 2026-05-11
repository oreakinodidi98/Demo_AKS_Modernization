# RAG Applications with KAITO RAGEngine

**RAG** — Retrieval Augmented Generation

RAG combines LLMs with external knowledge sources so the model can retrieve real data before generating a response. Instead of relying purely on what the model was trained on, RAG pulls relevant information from a knowledge base or database and feeds it into the LLM — giving you more accurate, contextually relevant answers.

---

## Demo

Build a RAG application on AKS using KAITO's RAGEngine, backed by a sample e-commerce store.

### Prerequisites

- AKS cluster with GPU node pool
- KAITO installed via Helm

### Deploy the Workspace

Deploy the KAITO workspace and check the status:

```bash
kubectl get workspace workspace-phi-4-mini-instruct
```

### Deploy the Sample Application

Deploy the AKS Store Demo — a simple online store that sells pet supplies. We'll use this application and its product data to build a RAG application that can answer questions about the products available in the store.

```bash
kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/aks-store-demo/refs/heads/main/aks-store-quickstart.yaml
```

Get the external IP for the store front:

```bash
kubectl get service store-front -ojsonpath='{.status.loadBalancer.ingress[0].ip}'
```

---

## What is the KAITO RAGEngine?

A custom resource that simplifies the deployment and management of RAG workloads on Kubernetes. It lets you deploy RAG applications that retrieve information from external knowledge sources and use it to enhance responses from LLMs.

### How a RAG Workflow Works

In a RAG workflow, you have a knowledge base (like a database or an index) and an LLM. Data is indexed in a vector database, which allows for efficient retrieval of relevant information based on the user's query.

### Key Components

| Component | What It Does |
|---|---|
| **Knowledge Base** | A source of information that can be indexed and queried to retrieve relevant data |
| **Vector Database** | Stores indexed data in a format that allows for efficient similarity search |
| **Embedding Model** | Converts text into vector representations, which are then stored in the vector database |
| **Inference Service** | Provides access to an LLM for generating responses based on the retrieved information |

### How KAITO RAGEngine Simplifies This

KAITO RAGEngine wraps all of these components into a single CRD — the vector database, embedding model, and inference service are all configured in one place. By default, it uses the **Faiss** vector database and the **BAAI general embedding (bge)** model, but you can configure it to use other embedding models as needed.

When building your RAG application, instead of calling the inference service directly, you interact with the `/query` endpoint of the RAGEngine instance. This endpoint handles retrieving relevant information from the knowledge base, passes it to the inference service, and returns the generated response.