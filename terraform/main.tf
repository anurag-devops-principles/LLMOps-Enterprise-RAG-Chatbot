resource "azurerm_resource_group" "resource_group" {
  name     = "${local.name_prefix}-rg"
  location = local.region

  tags = local.common_tags
}

resource "azurerm_cognitive_account" "open_ai" {
  name                  = "${local.name_prefix}-azure-open-ai"
  location              = local.region
  resource_group_name   = azurerm_resource_group.resource_group.name
  kind                  = local.kind
  sku_name              = local.openai_sku_name
  custom_subdomain_name = "${local.name_prefix}-azure-openai"

  tags = local.common_tags
}

resource "azurerm_cognitive_deployment" "deployment_model" {
  for_each = var.open_ai_models

  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.open_ai.id

  model {
    format  = local.model.format
    name    = each.value.name
    version = each.value.version
  }

  sku {
    name = local.model.sku
  }
}

resource "azurerm_search_service" "search_service" {
  name                = "${local.name_prefix}-search"
  location            = local.region
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = local.search_service.sku
  identity {
    type = local.search_service.identity_type
  }

  local_authentication_enabled = local.search_service.local_authentication_enabled

  tags = local.common_tags
}

resource "azurerm_storage_account" "storage_account" {
  name                            = replace("${local.name_prefix}-strg", "-", "")
  location                        = local.region
  resource_group_name             = azurerm_resource_group.resource_group.name
  account_tier                    = local.storage.account_tier
  account_replication_type        = local.storage.account_replication_type
  allow_nested_items_to_be_public = local.storage.allow_nested_items_to_be_public

  tags = local.common_tags
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "${local.name_prefix}-strg-container"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = local.storage.container_access_type
}
