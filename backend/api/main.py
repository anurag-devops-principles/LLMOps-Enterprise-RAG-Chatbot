from fastapi import FastAPI
from services.openai_service import get_chat_response, generate_embedding
from services.search_service import search_documents

app = FastAPI()

@app.get("/")
def health():
    return {"status": "running"}

@app.get("/chat")
def chat(query: str):

    print("\n===== NEW REQUEST =====")
    print("Query:", query)

    # Step 1: Generate embedding
    query_embedding = generate_embedding(query)

    # Step 2: Retrieve documents
    docs = search_documents(query_embedding)

    print("Scores:", [d["score"] for d in docs])

    has_relevant_docs = False

    if docs:
        scores = [d["score"] for d in docs[:2]]
        contents = [d["content"].lower() for d in docs[:2]]

        # Remove weak/common words
        query_words = [w for w in query.lower().split() if len(w) > 3]

        # Keyword validation
        keyword_match = any(
            any(word in content for word in query_words)
            for content in contents
        ) if query_words else False

        print("Keyword match:", keyword_match)

        # Final decision
        if scores and max(scores) > 0.3 and keyword_match:
            has_relevant_docs = True

    # Step 3: Decide RAG vs GPT
    if has_relevant_docs:

        context = "\n\n".join([d["content"] for d in docs[:3]])

        prompt = f"""
        You are an AI assistant answering questions based strictly on provided documents.

        Rules:
        - Answer ONLY using the context
        - If the answer is not clearly present, say: "I don't have enough information"
        - Do NOT guess

        Context:
        {context}

        Question:
        {query}
        """

    else:
        # Fallback to general GPT
        prompt = query

    # Step 4: Get response
    response = get_chat_response(prompt)

    return {"response": response}
