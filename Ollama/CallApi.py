import os
import requests

# Use localhost when port-forwarding, or the in-cluster DNS when running inside K8s
OLLAMA_URL = os.getenv("OLLAMA_URL", "http://localhost:11434")

# Generate a response
response = requests.post(f"{OLLAMA_URL}/api/generate", json={
    "model": "tinyllama",
    "prompt": "Explain the concept of GitOps in one paragraph",
    "stream": False,
})

data = response.json()
if "response" in data:
    print(data["response"])
else:
    print("Error:", data.get("error", data))

# Chat completion
response = requests.post(f"{OLLAMA_URL}/api/chat", json={
    "model": "tinyllama",
    "messages": [
        {"role": "user", "content": "Write a Python function to parse JSON safely"}
    ],
    "stream": False,
})

data = response.json()
if "message" in data:
    print(data["message"]["content"])
else:
    print("Error:", data.get("error", data))

# can also use OpenAI compatible endpoints
# from openai import OpenAI

# client = OpenAI(
#     base_url="http://ollama.default.svc:11434/v1",
#     api_key="not-needed",
# )

# response = client.chat.completions.create(
#     model="llama3.1:8b",
#     messages=[{"role": "user", "content": "Hello!"}],
# )