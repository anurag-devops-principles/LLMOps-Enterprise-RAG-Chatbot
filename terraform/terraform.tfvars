open_ai_models = {
  "chat_model" = {
    name    = "gpt-4.1-mini"
    version = "latest"
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
  search_service_ingest = {
    scope                = "search_service_ingest"
    role_definition_name = "search_service_ingest"
  }
  key_vault = {
    scope                = "key_vault"
    role_definition_name = "key_vault"
  }
}
