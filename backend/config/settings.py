import os
from functools import lru_cache

from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
from dotenv import load_dotenv

load_dotenv()

SECRET_NAMES = {
    "OPENAI_ENDPOINT": "OPENAI-ENDPOINT",
    "OPENAI_CHAT_DEPLOYMENT": "OPENAI-CHAT-DEPLOYMENT",
    "OPENAI_EMBEDDING_DEPLOYMENT": "OPENAI-EMBEDDING-DEPLOYMENT",
    "SEARCH_ENDPOINT": "SEARCH-ENDPOINT",
    "SEARCH_INDEX": "SEARCH-INDEX",
    "STORAGE_ACCOUNT": "STORAGE-ACCOUNT",
    "STORAGE_CONTAINER": "STORAGE-CONTAINER",
}


@lru_cache(maxsize=1)
def get_credential():
    return DefaultAzureCredential()


@lru_cache(maxsize=1)
def get_secret_client():
    key_vault_url = os.getenv("KEY_VAULT_URL")
    key_vault_name = os.getenv("KEY_VAULT_NAME")

    if not key_vault_url and key_vault_name:
        key_vault_url = f"https://{key_vault_name}.vault.azure.net/"

    if not key_vault_url:
        return None

    return SecretClient(
        vault_url=key_vault_url,
        credential=get_credential()
    )


@lru_cache(maxsize=None)
def get_secret(secret_name):
    client = get_secret_client()
    if not client:
        return None

    return client.get_secret(secret_name).value


def get_setting(name, default=None):
    secret_name = SECRET_NAMES.get(name)

    if secret_name:
        secret_value = get_secret(secret_name)
        if secret_value:
            return secret_value

    env_value = os.getenv(name)
    if env_value:
        return env_value

    return default
