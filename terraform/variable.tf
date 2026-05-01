variable "subscription_id" {
  type    = string
  default = "bd7b142b-030a-46e3-8a31-579ffb9d2046"
}

variable "open_ai_models" {
  type = map(object({
    name    = string
    version = string
  }))
}

variable "role_assignment" {
  type = map(object({
    scope                = string
    role_definition_name = string
  }))
}
