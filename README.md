Call all LLM APIs using the OpenAI format [Bedrock, Huggingface, VertexAI, TogetherAI, Azure, OpenAI, Groq etc.]

Build from litellm pip package

Docker, Deployment

Build the docker image
    docker build \
  -f Dockerfile.build_from_pip \
  -t litellm-proxy-with-pip-5 .

Run the docker image
    docker run \
    -v $(pwd)/litellm_config.yaml:/app/config.yaml \
    -e OPENAI_API_KEY="sk-1222" \
    -e DATABASE_URL="postgresql://5711438 \
    -p 4000:4000 \
    litellm-proxy-with-pip-5 \
    --config /app/config.yaml --detailed_debug


