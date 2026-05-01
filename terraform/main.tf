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

  rbac_authorization_enabled = local.key_vault.rbac_authorization_enabled
  soft_delete_retention_days = local.key_vault.soft_delete_retention_days
  purge_protection_enabled   = local.key_vault.purge_protection_enabled

  sku_name = local.key_vault.sku_name

  tenant_id = data.azurerm_client_config.current.tenant_id

  tags = local.common_tags
}

resource "azurerm_user_assigned_identity" "user_identity" {
  name                = "${local.name_prefix}-identity"
  location            = local.region
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each             = var.role_assignment
  scope                = local.role_assignment.scope[each.value.scope]
  role_definition_name = local.role_assigment.rbac_name[each.value.role_definition_name]
  principal_id         = azurerm_user_assignment_identity.user_identity.principal_id
}
