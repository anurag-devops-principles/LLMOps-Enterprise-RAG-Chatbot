import os
from azure.search.documents import SearchClient
from azure.search.documents.indexes import SearchIndexClient
from azure.search.documents.indexes.models import (
    SearchIndex,
    SimpleField,
    SearchableField,
    SearchField,
    SearchFieldDataType,
    VectorSearch,
    VectorSearchProfile,
    HnswAlgorithmConfiguration
)

from config.settings import get_credential, get_setting

credential = get_credential()


def create_index():
    client = SearchIndexClient(
        endpoint=get_setting("SEARCH_ENDPOINT"),
        credential=credential
    )

    fields = [
        SimpleField(name="id", type="Edm.String", key=True),

        SearchableField(
            name="content",
            type="Edm.String"
        ),

        SearchableField(
            name="source",
            type="Edm.String"
        ),

        SearchField(
            name="embedding",
            type=SearchFieldDataType.Collection(SearchFieldDataType.Single),
            searchable=True,
            vector_search_dimensions=1536,
            vector_search_profile_name="vector-profile"
        )
    ]

    vector_search = VectorSearch(
        profiles=[
            VectorSearchProfile(
                name="vector-profile",
                algorithm_configuration_name="hnsw-config"
            )
        ],
        algorithms=[
            HnswAlgorithmConfiguration(
                name="hnsw-config"
            )
        ]
    )

    index = SearchIndex(
        name=get_setting("SEARCH_INDEX"),
        fields=fields,
        vector_search=vector_search
    )

    client.create_or_update_index(index)

    print("Index created or updated successfully")


def upload_documents(documents):
    client = SearchClient(
        endpoint=get_setting("SEARCH_ENDPOINT"),
        index_name=get_setting("SEARCH_INDEX"),
        credential=credential
    )

    result = client.upload_documents(documents)

    success_count = sum(1 for r in result if r.succeeded)
    fail_count = len(result) - success_count

    print(f"Success: {success_count}")
    print(f"Failed: {fail_count}")

    if fail_count > 0:
        for r in result:
            if not r.succeeded:
                print("Document ID:", r.key)
                print("Error:", r.error_message)
