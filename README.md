# LiteLLM Proxy 部署與設定

## 環境變數設定
在 `.env` 檔案中設定以下環境變數：
```
LITELLM_MASTER_KEY=your-master-key
OPENROUTER_API_KEY=your-openrouter-api-key
```

## 設定檔 (litellm_config.yaml)
```yaml
general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
  openrouter_api_key: os.environ/OPENROUTER_API_KEY

model_list:
  - model_name: llama2
    litellm_params:
      model: llama2
      api_base: http://100.94.136.15:11434
      api_type: ollama
```

## Docker 部署
1. 構建映像：
   ```bash
   docker build -t litellm-proxy .
   ```
2. 啟動容器：
   ```bash
   docker run -d --name litellm-proxy -p 4000:4000 -v $(pwd)/litellm_config.yaml:/app/config.yaml --env-file .env litellm-proxy --config /app/config.yaml
   ```

## API 串接
- 呼叫 API 時，請在 HTTP header 加上：
  ```
  Authorization: Bearer your-master-key
  ```
- 範例：
  ```bash
  curl -H "Authorization: Bearer sk-1234" http://localhost:4000/v1/models
  ```

## 支援模型
- OpenAI: gpt-3.5-turbo
- Ollama: llama2 (API base: http://100.94.136.15:11434)

## 注意事項
- 若不需要資料庫功能，請移除 `.env` 中的 `DATABASE_URL`。
- 如需串接其他模型，請在 `litellm_config.yaml` 的 `model_list` 中新增設定。 