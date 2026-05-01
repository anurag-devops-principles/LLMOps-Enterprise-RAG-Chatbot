locals {
  environment     = "dev"
  application     = "rag-chatbot"
  owner           = "devops-team"
  project         = "devops-practice"
  region          = "eastus"
  kind            = "OpenAI"
  openai_sku_name = "S0"
  model = {
    format = "OpenAI"
    sku    = "Standard"
  }
  search_service = {
    sku           = "free"
    identity_type = "SystemAssigned"
  }
  storage = {
    account_tier             = "Standard"
    account_replication_type = "LRS"
    container_access_type    = "private"
  }
  key_vault = {
    rbac_authorization_enabled = true
    soft_delete_retention_days = 7
    purge_protection_enabled   = false
    sku_name                   = "standard"
  }
  role_assignment = {
    scope = {
      open_ai               = azurerm_cognitive_account.opne_ai.id
      search_service        = azurerm_search_service.search_service.id
      search_service_ingest = azurerm_search_service.search_service.id
      key_vault             = azurerm_key_vault.key_vault.id
    }
    rbac_name = {
      open_ai               = "Congnitive Service OpenAI User"
      search_service        = "Search Index Data Reader"
      search_service_ingest = "Search Index Data Contributor"
      key_vault             = "Key Vault Secrets User"
    }
  }
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
