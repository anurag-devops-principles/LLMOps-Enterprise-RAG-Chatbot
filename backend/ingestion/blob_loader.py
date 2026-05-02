from azure.storage.blob import BlobServiceClient
from azure.identity import DefaultAzureCredential
import os
from io import BytesIO
from pypdf import PdfReader
from dotenv import load_dotenv

load_dotenv()

credential = DefaultAzureCredential()


def get_blob_service():
    return BlobServiceClient(
        account_url=f"https://{os.getenv('STORAGE_ACCOUNT')}.blob.core.windows.net",
        credential=credential
    )


def list_blobs():
    service = get_blob_service()
    container_client = service.get_container_client(os.getenv("BLOB_CONTAINER"))

    blobs = [blob.name for blob in container_client.list_blobs()]

    print(f"Found {len(blobs)} files in container")

    return blobs


def load_pdf(blob_name):
    service = get_blob_service()

    blob_client = service.get_blob_client(
        container=os.getenv("BLOB_CONTAINER"),
        blob=blob_name
    )

    print(f"Downloading: {blob_name}")

    pdf_bytes = blob_client.download_blob().readall()

    reader = PdfReader(BytesIO(pdf_bytes))

    text = ""
    for page in reader.pages:
        text += page.extract_text() or ""

    print(f"Loaded: {blob_name} ({len(text)} chars)")

    return text
