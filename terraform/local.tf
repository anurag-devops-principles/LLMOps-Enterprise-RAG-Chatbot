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
    sku           = "standard"
    identity_type = "SystemAssigned"
  }
  storage = {
    account_tier             = "Standard"
    account_replication_type = "LRS"
    container_access_type    = "private"
  }
  key_vault = {
    enabled_for_disk_encryption = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    sku_name                    = "standard"
    secret_permissions          = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  }
  key_vault_secret = {
    openai-endpint  = azurerm_cognitive_account.open_ai.endpoint
    openai-key      = azurerm_cognitive_account.open_ai.key1
    search-endpoint = azurerm_search_service.search_service.endpoint
    search-key      = azurerm_search_service.search_service.primary_key
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
