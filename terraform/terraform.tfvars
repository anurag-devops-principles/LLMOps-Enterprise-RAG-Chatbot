open_ai_models = {
  "chat_model" = {
    name    = "gpt-4o-mini"
    version = "2024-07-18"
  }
  "embedding" = {
    name    = "text-embedding-3-small"
    version = "1"
  }
}

key_vault_secrets = {
  "openai-endpoint" = {
    secret_name  = "openai-endpoint"
    secret_value = "openai-endpoint"
  }
  "openai-key" = {
    secret_name  = "openai-key"
    secret_value = "openai-key"
  }
  "search-endpoint" = {
    secret_name  = "search-endpoint"
    secret_value = "search-endpoint"
  }
  "search-key" = {
    secret_name  = "search-key"
    secret_value = "search-key"
  }
}
