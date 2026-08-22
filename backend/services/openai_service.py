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

def get_chat_response(query):
    response = client.chat.completions.create(
        model=get_setting("OPENAI_CHAT_DEPLOYMENT"),
        messages=[
            {"role": "system", "content": "You are a helpful assistant"},
            {"role": "user", "content": query}
        ]
    )
    return response.choices[0].message.content

def generate_embedding(text):
    response = client.embeddings.create(
        model=get_setting("OPENAI_EMBEDDING_DEPLOYMENT", "embedding_model"),
        input=text
    )
    return response.data[0].embedding
