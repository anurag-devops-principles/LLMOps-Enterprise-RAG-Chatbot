terraform {
  backend "azurerm" {
    resource_group_name  = "bootstrapresource-rg"          # Can also be set via `ARM_ACCESS_KEY` environment variable.
    storage_account_name = "bootstrapresourcestrg"         # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "bootstrapresource-tfstate"     # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "rag.chatbot.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}
