# 使用 Python 3.9 slim 版本作為基礎映像
FROM python:3.9-slim

# 設置工作目錄
WORKDIR /app

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# 複製依賴文件
COPY requirements.txt .

# 安裝 Python 依賴
RUN pip install --no-cache-dir -r requirements.txt

# 複製應用程序代碼
COPY . .

# 設置環境變數
ENV PYTHONUNBUFFERED=1
ENV PORT=4000

# 暴露端口
EXPOSE 4000

# 啟動命令
ENTRYPOINT ["litellm"]
CMD ["--port", "4000"] 