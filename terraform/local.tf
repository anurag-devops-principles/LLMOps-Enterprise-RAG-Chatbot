data "azurerm_client_config" "current" {}

locals {
  environment = "dev"
  application = "rag-chatbot"
  owner       = "devops-team"
  project     = "devops-practice"
  region      = "eastus"
}

locals {
  name_prefix = "${local.environment}-${local.application}"
}

locals {
  common_tags = {
    "environment" = local.environment
    "owner"       = local.owner
    "project"     = local.project
    "application" = local.application
  }
}

locals {

  openai = {
    kind = "OpenAI"
    sku  = "S0"
  }

  model = {
    format = "OpenAI"
    sku    = "Standard"
  }

  search_service = {
    sku                          = "free"
    identity_type                = "SystemAssigned"
    local_authentication_enabled = false
  }

  storage = {
    account_tier                    = "Standard"
    account_replication_type        = "LRS"
    container_access_type           = "private"
    allow_nested_items_to_be_public = false
  }

  key_vault = {
    rbac_authorization_enabled = true
    soft_delete_retention_days = 7
    purge_protection_enabled   = false
    sku_name                   = "standard"
  }

  role_assignment = {

    scope = {
      open_ai         = azurerm_cognitive_account.open_ai.id
      search_service  = azurerm_search_service.search_service.id
      key_vault       = azurerm_key_vault.key_vault.id
      storage_account = azurerm_storage_account.storage_account.id
      acr             = azurerm_container_registry.acr.id
    }

    rbac_name = {
      open_ai         = "Cognitive Services OpenAI User"
      search_service  = "Search Index Data Contributor"
      key_vault       = "Key Vault Secrets User"
      storage_account = "Storage Blob Data Contributor"
      acr             = "AcrPull"
    }

  }

  key_vault_secret = {
    openai_endpoint             = azurerm_cognitive_account.open_ai.endpoint
    openai_chat_deployment      = "chat_model"
    openai_embedding_deployment = "embedding_model"
    search_endpoint             = azurerm_search_service.search_service.endpoint
    search_index                = "rag-index"
    storage_account             = azurerm_storage_account.storage_account.name
    storage_container           = azurerm_storage_container.storage_container.name
  }

  acr = {
    sku           = "Basic"
    admin_enabled = false
  }

}
