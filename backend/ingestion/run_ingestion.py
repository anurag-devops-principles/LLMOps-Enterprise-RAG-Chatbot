from blob_loader import list_blobs, load_pdf
from chunker import chunk_text
from embedder import generate_embedding
from indexer import create_index, upload_documents

def run():
    create_index()

    all_docs = []
    doc_id = 0

    blobs = list_blobs()

    for blob in blobs:
        text = load_pdf(blob)

        if not text.strip():
            continue

        chunks = chunk_text(text)

        for chunk in chunks:
            embedding = generate_embedding(chunk)

            all_docs.append({
                "id": str(doc_id),
                "content": chunk,
                "embedding": embedding,
                "source": blob
            })

            doc_id += 1

    upload_documents(all_docs)


if __name__ == "__main__":
    run()
