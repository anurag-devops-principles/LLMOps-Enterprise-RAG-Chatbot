output "resource_group" {
  value = {
    name     = azurerm_resource_group.resource_group.name
    location = azurerm_resource_group.resource_group.location
    id       = azurerm_resource_group.resource_group.id
  }
}

output "cognitive_account" {
  value = {
    name     = azurerm_cognitive_account.open_ai.name
    id       = azurerm_cognitive_account.open_ai.id
    endpoint = azurerm_cognitive_account.open_ai.endpoint
  }
}

output "cognitive_deployment" {
  value = {
    for key, value in azurerm_cognitive_deployment.deployment_model : key => {
      name = value.name
      id   = value.id
    }
  }
}

output "search_service" {
  value = {
    name     = azurerm_search_service.search_service.name
    id       = azurerm_search_service.search_service.id
    endpoint = azurerm_search_service.search_service.endpoint
  }
}

output "storage_account" {
  value = {
    name = azurerm_storage_account.storage_account.name
    id   = azurerm_storage_account.storage_account.id
  }
}

output "storage_container" {
  value = {
    name = azurerm_storage_container.storage_container.name
    id   = azurerm_storage_container.storage_container.id
  }
}

output "key_vault" {
  value = {
    name = azurerm_key_vault.key_vault.name
    id   = azurerm_key_vault.key_vault.id
  }
}

output "user_identity" {
  value = {
    name = azurerm_user_assigned_identity.user_identity.name
    id   = azurerm_user_assigned_identity.user_identity.id
  }
}