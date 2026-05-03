open_ai_models = {
  "chat_model" = {
    name    = "gpt-4.1-mini"
    version = "2025-04-14"
  }
  "embedding_model" = {
    name    = "text-embedding-3-small"
    version = "1"
  }
}

role_assignment = {
  open_ai = {
    scope                = "open_ai"
    role_definition_name = "open_ai"
  }
  search_service = {
    scope                = "search_service"
    role_definition_name = "search_service"
  }
  key_vault = {
    scope                = "key_vault"
    role_definition_name = "key_vault"
  }
  storage_account = {
    scope                = "storage_account"
    role_definition_name = "storage_account"
  }
  acr = {
    scope                = "acr"
    role_definition_name = "acr"
  }
}

vault_secrets = {
  openai_endpoint = {
    secret_name = "OPENAI-ENDPOINT"
    value       = "openai_endpoint"
  }
  search_endpoint = {
    secret_name = "SEARCH-ENDPOINT"
    value       = "search_endpoint"
  }
  search_index = {
    secret_name = "SEARCH-INDEX"
    value       = "search_index"
  }
  storage_account = {
    secret_name = "STORAGE-ACCOUNT"
    value       = "storage_account"
  }
  storage_container = {
    secret_name = "STORAGE-CONTAINER"
    value       = "storage_container"
  }
}
