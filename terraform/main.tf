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
  custom_subdomain_name = "${local.name_prefix}-azure-open-ai"

  tags = local.common_tags
}

resource "azurerm_cognitive_deployment" "deployment_model" {
  for_each = var.open_ai_models

  name                 = each.value.name
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

  tags = local.common_tags
}

resource "azurerm_storage_account" "storage_account" {
  name                     = replace("${local.name_prefix}-strg", "-", "")
  location                 = local.region
  resource_group_name      = azurerm_resource_group.resource_group.name
  account_tier             = local.storage.account_tier
  account_replication_type = local.storage.account_replication_type

  tags = local.common_tags
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "${local.name_prefix}-strg-container"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = local.storage.container_access_type
}

resource "azurerm_key_vault" "key_vault" {
  name                = "${local.name_prefix}-kv"
  location            = local.region
  resource_group_name = azurerm_resource_group.resource_group.name

  enabled_for_disk_encryption = local.key_vault.enabled_for_disk_encryption
  soft_delete_retention_days  = local.key_vault.soft_delete_retention_days
  purge_protection_enabled    = local.key_vault.purge_protection_enabled
  sku_name                    = local.key_vault.sku_name

  tenant_id = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = local.key_vault.secret_permissions
  }

  tags = local.common_tags
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  depends_on = [azurerm_cognitive_account.open_ai, azurerm_cognitive_deployment.deployment_model, azurerm_search_service.search_service]
  for_each   = var.key_vault_secrets

  name         = each.value.secret_name
  value        = local.key_vault_secret[each.value.secret_value]
  key_vault_id = azurerm_key_vault.key_vault.id

  tags = local.common_tags
}
