import os
from azure.search.documents import SearchClient
from azure.search.documents.models import VectorizedQuery
from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv

load_dotenv()

credential = DefaultAzureCredential()

search_client = SearchClient(
    endpoint=os.getenv("SEARCH_ENDPOINT"),
    index_name=os.getenv("SEARCH_INDEX"),
    credential=credential
)


def search_documents(query_embedding):
    vector_query = VectorizedQuery(
        vector=query_embedding,
        k_nearest_neighbors=3,
        fields="embedding"
    )

    results = search_client.search(
        search_text="*",
        vector_queries=[vector_query]
    )

    documents = []
    for result in results:
        documents.append({
            "content": result["content"],
            "score": result["@search.score"]
        })

    return documents
