# LLMOps Enterprise RAG Chatbot

Enterprise RAG chatbot platform using Azure OpenAI, Azure AI Search, Azure Blob Storage, FastAPI, Terraform, and GitHub Actions.

## Overview

This repository contains a minimal Retrieval-Augmented Generation application:

- A FastAPI chatbot API in `backend/api/main.py`
- Azure OpenAI chat and embedding clients in `backend/services`
- PDF ingestion from Azure Blob Storage in `backend/ingestion`
- Azure AI Search vector index creation and document upload
- Terraform for Azure OpenAI, Azure AI Search, Storage, Key Vault, Managed Identity, Container Apps environment, and ACR
- GitHub Actions workflows for Terraform plan, apply, security scanning, and destroy

## Repository Structure

```text
.
├── backend
│   ├── api
│   │   └── main.py
│   ├── ingestion
│   │   ├── blob_loader.py
│   │   ├── chunker.py
│   │   ├── embedder.py
│   │   ├── indexer.py
│   │   └── run_ingestion.py
│   ├── services
│   │   ├── openai_service.py
│   │   └── search_service.py
│   └── requirements.txt
├── frontend
│   ├── index.html
│   └── static
│       ├── app.js
│       └── styles.css
├── terraform
│   ├── main.tf
│   ├── local.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variable.tf
└── .github/workflows
```

## Prerequisites

- Python 3.11+
- Azure CLI authenticated with access to the target subscription
- Terraform 1.5+
- Docker, if running the API in a container
- Azure permissions to create and access:
  - Azure OpenAI
  - Azure AI Search
  - Storage Account and Blob Container
  - Key Vault
  - Managed Identity
  - Container Registry

The Python code uses `DefaultAzureCredential`, so local development normally works after:

```bash
az login
az account set --subscription "<subscription-id>"
```

## Configuration With Key Vault

Create a local `.env` file from the example:

```bash
cp .env.example .env
```

For normal usage, `.env` only needs the Key Vault reference:

```bash
KEY_VAULT_NAME="<key-vault-name>"
```

You can also use the full vault URL:

```bash
KEY_VAULT_URL="https://<key-vault-name>.vault.azure.net/"
```

When `KEY_VAULT_NAME` or `KEY_VAULT_URL` is set, the application reads these configuration values from Azure Key Vault:

```text
OPENAI-ENDPOINT
OPENAI-CHAT-DEPLOYMENT
OPENAI-EMBEDDING-DEPLOYMENT
SEARCH-ENDPOINT
SEARCH-INDEX
STORAGE-ACCOUNT
STORAGE-CONTAINER
```

The same values can still be set directly as environment variables for local debugging:

```bash
OPENAI_ENDPOINT="https://<azure-openai-resource>.openai.azure.com/"
OPENAI_CHAT_DEPLOYMENT="chat_model"
OPENAI_EMBEDDING_DEPLOYMENT="embedding_model"
SEARCH_ENDPOINT="https://<search-service>.search.windows.net"
SEARCH_INDEX="rag-index"
STORAGE_ACCOUNT="<storage-account-name>"
STORAGE_CONTAINER="<blob-container-name>"
```

`BLOB_CONTAINER` is also supported as a fallback for older local config.

## Provision Azure Resources

Review the Terraform settings first:

```bash
cd terraform
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

Apply when ready:

```bash
terraform apply
```

Useful outputs include the Azure OpenAI endpoint, Azure AI Search endpoint, Storage Account name, Storage Container name, and managed identity details.

## Run The App Locally

Install dependencies:

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Start FastAPI from the `backend` directory:

```bash
uvicorn api.main:app --reload --host 0.0.0.0 --port 8000
```

Open the frontend:

```text
http://localhost:8000
```

Check health:

```bash
curl http://localhost:8000/health
```

Ask a question:

```bash
curl "http://localhost:8000/chat?query=What%20does%20this%20document%20say%20about%20security%3F"
```

## Run Ingestion

Upload PDF files into the configured Azure Blob Storage container, then run from the `backend` directory:

```bash
cd backend
python -m ingestion.run_ingestion
```

The ingestion script will:

1. Create or update the Azure AI Search index.
2. List PDFs from Blob Storage.
3. Extract text from each PDF.
4. Split text into overlapping chunks.
5. Generate embeddings with Azure OpenAI.
6. Upload documents into Azure AI Search.

## Run With Docker

Build the API image:

```bash
docker build -t llmops-rag-chatbot .
```

Run the API:

```bash
docker run --rm -p 8000:8000 --env-file .env llmops-rag-chatbot
```

Open:

```text
http://localhost:8000
```

## GitHub Actions

The repository includes two manual workflows:

- `.github/workflows/terraformWorkflow.yaml`: Terraform lint, security scans, validate, plan, and optional apply
- `.github/workflows/terraformDestroy.yaml`: Terraform destroy plan and apply

Required repository secret:

```text
AZURE_CREDENTIALS
```

## Current Limitations

- No application deployment resource is defined yet for Container Apps or AKS.
- No Kubernetes manifests or GitOps controller configuration are present yet.
- No automated Python tests or RAG evaluation suite are present yet.
- Retrieval uses a simple vector search plus keyword validation gate.
- Ingestion currently handles PDF text extraction only.
