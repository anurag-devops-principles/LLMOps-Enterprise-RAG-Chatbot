from openai import AzureOpenAI
from azure.identity import get_bearer_token_provider

from config.settings import get_credential, get_setting

credential = get_credential()

token_provider = get_bearer_token_provider(
    credential,
    "https://cognitiveservices.azure.com/.default"
)

client = AzureOpenAI(
    azure_endpoint=get_setting("OPENAI_ENDPOINT"),
    azure_ad_token_provider=token_provider,
    api_version="2024-02-01"
)


def generate_embedding(text):
    response = client.embeddings.create(
        model=get_setting("OPENAI_EMBEDDING_DEPLOYMENT", "embedding_model"),
        input=text
    )

    return response.data[0].embedding
