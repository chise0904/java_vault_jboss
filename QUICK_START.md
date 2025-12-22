# 🚀 Quick Start Guide

## 快速開始指南

### 方法 1: 使用 DevContainer 開發 (推薦)

1. **在 VS Code 中打開專案**:
   ```bash
   cd /Users/chiaminlin/Downloads/JAVA_vault_jboss
   code .
   ```

2. **在容器中重新打開**:
   - 按 `F1` 或 `Cmd+Shift+P`
   - 選擇 "Dev Containers: Reopen in Container"
   - 等待容器建置完成

3. **在 DevContainer 內建置**:
   ```bash
   mvn clean package
   ```

4. **部署** (在主機上執行):
   ```bash
   ./deploy.sh
   ```

5. **訪問應用程式**:
   - 首頁: http://localhost:8080/jboss-demo
   - API: http://localhost:8080/jboss-demo/api/environment/all

---

### 方法 2: 本地開發

#### 前置需求
- JDK 17
- Maven 3.6+
- Docker 和 Docker Compose

#### 步驟

1. **建置 WAR 檔**:
   ```bash
   ./build.sh
   ```
   或
   ```bash
   mvn clean package
   ```

2. **部署到 WildFly**:
   ```bash
   ./deploy.sh
   ```
   或
   ```bash
   docker-compose up -d
   ```

3. **驗證部署**:
   ```bash
   # 健康檢查
   curl http://localhost:8080/jboss-demo/api/environment/health

   # 查看所有環境變數
   curl http://localhost:8080/jboss-demo/api/environment/all

   # 查看自定義環境變數
   curl http://localhost:8080/jboss-demo/api/environment/custom
   ```

---

## 📡 API 端點

| 端點 | 說明 |
|------|------|
| `http://localhost:8080/jboss-demo/` | 首頁 |
| `http://localhost:8080/jboss-demo/api/environment/health` | 健康檢查 |
| `http://localhost:8080/jboss-demo/api/environment/all` | 所有環境變數 (JSON) |
| `http://localhost:8080/jboss-demo/api/environment/custom` | 自定義環境變數 (JSON) |

---

## 🔧 常用命令

### 開發命令

```bash
# 建置專案
mvn clean package

# 執行測試
mvn test

# 清理建置產物
mvn clean
```

### Docker 命令

```bash
# 啟動應用
docker-compose up -d

# 查看日誌
docker-compose logs -f

# 停止應用
docker-compose down

# 重新建置並部署
mvn clean package && docker-compose up -d --force-recreate
```

---

## 🛠️ 自定義環境變數

編輯 `docker-compose.yml` 檔案:

```yaml
environment:
  - APP_NAME=你的應用名稱
  - APP_VERSION=1.0.0
  - APP_ENVIRONMENT=production
  - DATABASE_URL=jdbc:postgresql://localhost:5432/mydb
  - API_KEY=your-api-key
```

然後重新部署:

```bash
docker-compose down
docker-compose up -d
```

---

## 📂 專案結構

```
jboss-demo/
├── src/main/java/com/example/jboss/
│   ├── config/JaxrsApplication.java    # REST 配置
│   ├── model/EnvironmentVariable.java   # 資料模型
│   └── rest/EnvironmentResource.java    # REST API
├── src/main/webapp/
│   ├── WEB-INF/beans.xml               # CDI 配置
│   └── index.html                       # 首頁
├── pom.xml                              # Maven 配置
├── docker-compose.yml                   # Docker Compose 配置
└── build.sh / deploy.sh                 # 建置/部署腳本
```

---

## 🔍 故障排除

### 端口被佔用

修改 `docker-compose.yml`:

```yaml
ports:
  - "8081:8080"  # 改用 8081 端口
```

### WAR 檔案不存在

```bash
mvn clean package
ls -lh target/jboss-demo.war
```

### 容器無法啟動

```bash
docker-compose logs
docker-compose down -v
docker-compose up -d --force-recreate
```

---

## ✅ 完成!

現在你已經有一個完整的 JBoss 專案，包含:

- ✅ 標準 JBoss/WildFly 專案結構
- ✅ DevContainer 開發環境
- ✅ REST API 顯示環境變數
- ✅ Docker Compose 部署配置
- ✅ 自動化建置和部署腳本
