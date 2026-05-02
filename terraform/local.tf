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
