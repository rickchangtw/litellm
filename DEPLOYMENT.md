# LiteLLM 部署指南

## 目錄
- [基礎配置](#基礎配置)
- [部署檢查清單](#部署檢查清單)
- [問題排查流程](#問題排查流程)
- [維護操作](#維護操作)
- [安全建議](#安全建議)
- [監控建議](#監控建議)

## 基礎配置

### docker-compose.yml
```yaml
version: '3.8'
services:
  litellm-proxy:
    image: ghcr.io/berriai/litellm-database:main-latest
    ports:
      - "4000:4000"
    volumes:
      - ./litellm_config.yaml:/app/config.yaml
    environment:
      - LITELLM_MASTER_KEY=sk-1234
      - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/litellm
      - UI_USERNAME=admin
      - UI_PASSWORD=admin
    depends_on:
      - postgres
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:4000/v1/models"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  postgres:
    image: postgres:latest
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=litellm
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### litellm_config.yaml
```yaml
model_list:
  - model_name: phi3:latest
    litellm_params:
      model: phi3:latest
      api_base: http://host.docker.internal:11434/v1
      api_key: sk-1234
      custom_llm_provider: ollama

general_settings:
  database_url: os.environ/DATABASE_URL
```

## 部署檢查清單

### 部署前檢查
- [ ] 環境變數配置
  - LITELLM_MASTER_KEY（必須以 sk- 開頭）
  - DATABASE_URL（格式：postgresql://user:password@host:port/dbname）
  - UI_USERNAME 和 UI_PASSWORD
- [ ] 配置文件
  - litellm_config.yaml 存在且權限正確
  - 配置文件格式正確
- [ ] 系統檢查
  - 端口 4000 未被佔用
  - 數據庫端口 5432 未被佔用

### 部署後檢查
- [ ] 服務狀態
  ```bash
  docker compose ps
  docker compose logs litellm-proxy
  ```
- [ ] 功能測試
  ```bash
  # API 測試
  curl -H "Authorization: Bearer sk-1234" http://localhost:4000/v1/models
  
  # UI 訪問
  http://localhost:4000/ui
  ```

## 問題排查流程

### 1. 服務啟動問題
```bash
# 檢查容器狀態
docker compose ps

# 檢查日誌
docker compose logs litellm-proxy

# 檢查配置文件
cat litellm_config.yaml
```

### 2. 認證問題
- 檢查 LITELLM_MASTER_KEY 格式
- 確認 UI 認證信息
- 驗證 Authorization header

### 3. 數據庫問題
- 檢查 DATABASE_URL 格式
- 確認數據庫服務狀態
- 驗證數據庫連接

## 維護操作

### 重啟服務
```bash
docker compose down
docker compose up -d
```

### 回滾操作
```bash
docker compose down
docker tag litellm-proxy:latest litellm-proxy:previous
docker compose up -d
```

### 日誌管理
```bash
# 查看實時日誌
docker compose logs -f litellm-proxy

# 清理舊日誌
docker system prune -f
```

## 安全建議

### 環境變數安全
- 使用強密碼
- 定期更換 LITELLM_MASTER_KEY
- 避免在代碼中硬編碼敏感信息

### 容器安全
- 使用非 root 用戶
- 定期更新容器映像
- 限制容器資源使用

### 數據庫安全
- 限制數據庫訪問權限
- 定期備份數據
- 使用強密碼

## 監控建議

### 基本監控
```yaml
services:
  litellm-proxy:
    labels:
      - "prometheus.enable=true"
      - "prometheus.port=4000"
      - "prometheus.path=/metrics"
```

### 日誌監控
- 設置日誌輪轉
- 配置日誌級別
- 監控錯誤日誌

## 常見問題解決

### 1. UI 訪問問題
- 確認 UI_USERNAME 和 UI_PASSWORD 設置
- 檢查瀏覽器緩存
- 嘗試使用無痕模式

### 2. API 調用問題
- 確認 Authorization header 格式
- 檢查 API 端點是否正確
- 驗證請求參數

### 3. 數據庫連接問題
- 檢查數據庫服務狀態
- 驗證數據庫憑證
- 確認網絡連接

## 更新記錄

### 2024-03-21
- 初始版本發布
- 包含基本部署配置和問題排查指南

### 2024-03-22
- 添加安全建議
- 更新監控配置
- 優化文檔結構 