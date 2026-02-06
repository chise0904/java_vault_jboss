# 🚀 DevContainer 快速開始指南

## 📋 步驟總覽

1. 在 DevContainer 中打開專案
2. 執行快速啟動腳本
3. 開始開發和調試

---

## 🎯 快速啟動（3 分鐘）

### 1️⃣ 在 VS Code 中打開 DevContainer

```bash
# 打開專案
cd /Users/chiaminlin/Downloads/JAVA_vault_jboss
code .
```

然後：
- 按 `F1` 或 `Cmd+Shift+P`
- 選擇 **"Dev Containers: Reopen in Container"**
- 等待容器建置完成

### 2️⃣ 執行快速啟動腳本

在 DevContainer 終端機中：

```bash
./dev-start.sh
```

這個腳本會自動：
- ✅ 清理舊的建置
- ✅ 建置 WAR 檔案
- ✅ 啟動 WildFly（調試模式）
- ✅ 等待應用程式啟動
- ✅ 執行健康檢查

### 3️⃣ 驗證部署

```bash
curl http://localhost:8082/jboss-demo/api/environment/health
```

應該看到：
```
Environment API is running on WildFly
```

---

## 🐛 開始調試

### 方法 1: 一鍵調試（推薦）

1. 在 `EnvironmentResource.java` 中設置中斷點
2. 按 `F5` 啟動調試器
3. 選擇 **"Debug (Attach to WildFly)"**
4. 執行 API 請求觸發中斷點：
   ```bash
   curl http://localhost:8080/jboss-demo/api/environment/custom
   ```

### 方法 2: 使用 VS Code Task

- 按 `Cmd+Shift+P`
- 選擇 **"Tasks: Run Task"**
- 選擇 **"Start WildFly (Debug Mode)"**

---

## 📡 測試 API

### 使用 curl

```bash
# 健康檢查
curl http://localhost:8080/jboss-demo/api/environment/health

# 所有環境變數
curl http://localhost:8080/jboss-demo/api/environment/all | jq

# 自訂環境變數
curl http://localhost:8080/jboss-demo/api/environment/custom | jq

# 智能讀取
curl http://localhost:8080/jboss-demo/api/environment/smart | jq

# 方法對比
curl http://localhost:8080/jboss-demo/api/environment/methods | jq
```

### 使用測試腳本

```bash
./test-api.sh
```

---

## 🔄 開發工作流程

### 修改程式碼後

```bash
# 方法 1: 手動重新部署
mvn clean package
docker compose -f docker-compose.debug.yml up -d --force-recreate

# 方法 2: 使用快速啟動腳本
./dev-start.sh
```

### 查看日誌

```bash
docker compose -f docker-compose.debug.yml logs -f wildfly
```

### 停止服務

```bash
docker compose -f docker-compose.debug.yml down
```

---

## 🔍 故障排除

### 問題: 404 Not Found

```bash
# 1. 檢查 WAR 檔案
ls -la target/jboss-demo.war

# 2. 重新建置
mvn clean package

# 3. 檢查部署狀態
docker exec jboss-demo-wildfly-debug ls -la /opt/jboss/wildfly/standalone/deployments/

# 4. 查看日誌
docker compose -f docker-compose.debug.yml logs wildfly | grep -i deployed
```

### 問題: 調試器無法連接

```bash
# 檢查調試端口
docker port jboss-demo-wildfly-debug 8787

# 檢查 WildFly 日誌
docker logs jboss-demo-wildfly-debug | grep -i "Listening for transport"
```

### 問題: 端口衝突

```bash
# 停止所有容器
docker compose -f docker-compose.debug.yml down

# 檢查端口占用
lsof -i :8080
lsof -i :8787

# 終止佔用進程
kill -9 <PID>
```

---

## 🎯 快速命令參考

| 命令 | 說明 |
|------|------|
| `./dev-start.sh` | 一鍵啟動開發環境 |
| `./test-api.sh` | 測試所有 API 端點 |
| `mvn clean package` | 建置 WAR 檔案 |
| `docker-compose -f docker-compose.debug.yml logs -f` | 查看日誌 |
| `docker-compose -f docker-compose.debug.yml down` | 停止服務 |
| `F5` (VS Code) | 開始調試 |
| `F9` (VS Code) | 設置中斷點 |

---

## 📚 詳細文件

- [DEVCONTAINER_DEBUG.md](DEVCONTAINER_DEBUG.md) - 完整的調試指南
- [README.md](README.md) - 專案總覽
- [環境變數設定說明.md](環境變數設定說明.md) - 環境變數配置

---

## ✅ 成功檢查清單

- [ ] DevContainer 已啟動
- [ ] WAR 檔案已建置（`target/jboss-demo.war`）
- [ ] WildFly 容器正在運行（`docker ps`）
- [ ] 健康檢查通過（`curl http://localhost:8080/jboss-demo/api/environment/health`）
- [ ] API 返回 JSON 資料
- [ ] 調試器可以連接（端口 8787）

---

## 🎉 現在可以開始開發了！

祝您編碼愉快！🚀
