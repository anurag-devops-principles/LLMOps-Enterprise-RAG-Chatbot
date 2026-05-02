import os
from openai import AzureOpenAI
from azure.identity import DefaultAzureCredential, get_bearer_token_provider
from dotenv import load_dotenv

load_dotenv()

credential = DefaultAzureCredential()

token_provider = get_bearer_token_provider(
    credential,
    "https://cognitiveservices.azure.com/.default"
)

client = AzureOpenAI(
    azure_endpoint=os.getenv("OPENAI_ENDPOINT"),
    azure_ad_token_provider=token_provider,
    api_version="2024-02-01"
)


def generate_embedding(text):
    response = client.embeddings.create(
        model="embedding_model", 
        input=text
    )

    return response.data[0].embedding
