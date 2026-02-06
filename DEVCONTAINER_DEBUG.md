# 🐛 DevContainer 開發與調試指南

## 📋 前置準備

1. 安裝 VS Code 擴充功能：
   - **Dev Containers** (ms-vscode-remote.remote-containers)
   - **Extension Pack for Java** (vscjava.vscode-java-pack)

2. 確保 Docker Desktop 正在運行

---

## 🚀 快速開始

### 步驟 1: 在 DevContainer 中打開專案

1. 在 VS Code 中打開專案資料夾
2. 按 `F1` 或 `Cmd+Shift+P`
3. 選擇 **"Dev Containers: Reopen in Container"**
4. 等待容器建置完成（首次需要幾分鐘）

### 步驟 2: 建置專案

在 DevContainer 內的終端機執行：

```bash
mvn clean package
```

或使用 VS Code Task：
- 按 `Cmd+Shift+B`（Mac）或 `Ctrl+Shift+B`（Windows/Linux）
- 選擇 **"Maven: Clean & Package"**

### 步驟 3: 啟動 WildFly（調試模式）

```bash
docker-compose -f docker-compose.debug.yml up -d
```

或使用 VS Code Task：
- 按 `Cmd+Shift+P`
- 選擇 **"Tasks: Run Task"**
- 選擇 **"Start WildFly (Debug Mode)"**

### 步驟 4: 查看日誌

```bash
docker-compose -f docker-compose.debug.yml logs -f wildfly
```

等待看到：
```
WildFly Full 26.1.3.Final (WildFly Core 18.1.2.Final) started
```

### 步驟 5: 測試應用程式

```bash
# 健康檢查
curl http://localhost:8080/jboss-demo/api/environment/health

# 查看環境變數
curl http://localhost:8080/jboss-demo/api/environment/custom
```

---

## 🐛 調試 (Debug)

### 方法 1: 使用 VS Code 調試器（推薦）

1. **設置中斷點**：
   - 打開 `EnvironmentResource.java`
   - 在需要調試的行號左側點擊，設置紅點（中斷點）

2. **啟動調試器**：
   - 按 `F5` 或點擊左側調試圖標
   - 選擇 **"Debug (Attach to WildFly)"**

3. **觸發中斷點**：
   ```bash
   curl http://localhost:8080/jboss-demo/api/environment/custom
   ```

4. **調試控制**：
   - `F10` - 單步執行（Step Over）
   - `F11` - 進入函數（Step Into）
   - `Shift+F11` - 跳出函數（Step Out）
   - `F5` - 繼續執行（Continue）

### 方法 2: 手動連接遠端調試

WildFly 已經在端口 **8787** 上啟用調試模式。

在 VS Code 中：
1. 打開 Debug 面板（`Cmd+Shift+D`）
2. 選擇 **"Debug (Attach to WildFly)"**
3. 按 `F5` 開始調試

---

## 🔄 常用工作流程

### 修改程式碼後重新部署

```bash
# 1. 重新建置
mvn clean package

# 2. 重新部署
docker-compose -f docker-compose.debug.yml up -d --force-recreate

# 3. 查看日誌
docker-compose -f docker-compose.debug.yml logs -f wildfly
```

或使用一鍵 Task：
- 按 `Cmd+Shift+P`
- 選擇 **"Tasks: Run Task"**
- 選擇 **"Build & Deploy"**

### 查看 WildFly 管理介面

```bash
# 訪問管理介面
open http://localhost:9990/console

# 預設帳號密碼
# Username: admin
# Password: admin123
```

---

## 📁 專案結構（DevContainer 內）

```
/workspace/                           # 專案根目錄
├── src/main/java/                   # Java 源碼
│   └── com/example/jboss/
│       ├── config/                  # 配置類別
│       ├── model/                   # 資料模型
│       ├── rest/                    # REST API
│       └── util/                    # 工具類別
├── src/main/webapp/                 # Web 資源
│   └── WEB-INF/
├── target/                          # 建置輸出
│   └── jboss-demo.war              # WAR 檔案
├── pom.xml                          # Maven 配置
└── docker-compose.debug.yml         # 調試用 Docker Compose
```

---

## 🔍 故障排除

### 問題 1: WAR 檔案不存在

```bash
# 檢查 WAR 檔案
ls -la target/jboss-demo.war

# 如果不存在，重新建置
mvn clean package
```

### 問題 2: 應用程式沒有部署

```bash
# 檢查部署狀態
docker exec jboss-demo-wildfly-debug ls -la /opt/jboss/wildfly/standalone/deployments/

# 應該看到
# jboss-demo.war
# jboss-demo.war.deployed  ← 成功部署的標記
```

### 問題 3: 404 錯誤

```bash
# 1. 確認 WAR 檔案已建置
ls -la target/jboss-demo.war

# 2. 確認容器正在運行
docker ps | grep wildfly

# 3. 查看部署日誌
docker logs jboss-demo-wildfly-debug | grep -i "deployed"

# 4. 測試根路徑
curl http://localhost:8080/jboss-demo/
```

### 問題 4: 調試器無法連接

```bash
# 1. 檢查調試端口是否開放
docker port jboss-demo-wildfly-debug 8787

# 2. 檢查 WildFly 是否以調試模式啟動
docker logs jboss-demo-wildfly-debug | grep -i "debug"

# 應該看到類似：
# Listening for transport dt_socket at address: 8787
```

### 問題 5: 端口衝突

```bash
# 停止所有相關容器
docker-compose down
docker-compose -f docker-compose.debug.yml down

# 檢查端口占用
lsof -i :8080
lsof -i :8787

# 重新啟動
docker-compose -f docker-compose.debug.yml up -d
```

---

## 🎯 調試技巧

### 1. 條件中斷點

在中斷點上右鍵 → "Edit Breakpoint" → 設置條件
```java
// 例如：只在 key 等於 "APP_NAME" 時中斷
key.equals("APP_NAME")
```

### 2. 日誌點 (Logpoint)

在中斷點上右鍵 → "Add Logpoint"
```java
// 輸出變量值到 Debug Console
key = {key}, value = {value}
```

### 3. 監看變數

在 Debug 面板的 "Watch" 區域添加要監看的表達式：
```java
System.getenv()
ConfigUtil.getConfig("APP_NAME", "default")
```

### 4. 即時修改變數值

在 Debug 模式下，可以在 "Variables" 區域修改變數值進行測試。

---

## 🧪 測試工作流程

### 在 DevContainer 內測試

```bash
# 1. 健康檢查
curl http://localhost:8080/jboss-demo/api/environment/health

# 2. 測試所有環境變數
curl http://localhost:8080/jboss-demo/api/environment/all | jq

# 3. 測試自訂環境變數
curl http://localhost:8080/jboss-demo/api/environment/custom | jq

# 4. 測試智能讀取
curl http://localhost:8080/jboss-demo/api/environment/smart | jq

# 5. 測試方法對比
curl http://localhost:8080/jboss-demo/api/environment/methods | jq
```

### 使用測試腳本

```bash
chmod +x test-api.sh
./test-api.sh
```

---

## 🔧 VS Code 快捷鍵

| 快捷鍵 | 功能 |
|--------|------|
| `F5` | 開始/繼續調試 |
| `F9` | 設置/取消中斷點 |
| `F10` | 單步執行（Step Over） |
| `F11` | 進入函數（Step Into） |
| `Shift+F11` | 跳出函數（Step Out） |
| `Cmd+Shift+B` | 執行建置任務 |
| `Cmd+Shift+P` | 命令面板 |
| `Ctrl+`` | 開啟終端機 |

---

## 📝 環境變數配置（調試模式）

在 `docker-compose.debug.yml` 中配置：

```yaml
environment:
  - APP_NAME=JBoss Demo Application
  - APP_VERSION=1.0.0
  - APP_ENVIRONMENT=development  # 調試模式設為 development
  - DATABASE_URL=jdbc:postgresql://localhost:5432/demodb
  - API_KEY=demo-api-key-12345
```

修改後需要重新部署：
```bash
docker-compose -f docker-compose.debug.yml down
docker-compose -f docker-compose.debug.yml up -d
```

---

## 🎉 成功標誌

當您看到以下輸出時，表示一切正常：

```bash
# 健康檢查
$ curl http://localhost:8080/jboss-demo/api/environment/health
Environment API is running on WildFly

# 環境變數
$ curl http://localhost:8080/jboss-demo/api/environment/custom | jq
[
  {
    "key": "APP_NAME",
    "value": "JBoss Demo Application"
  },
  {
    "key": "APP_VERSION",
    "value": "1.0.0"
  },
  ...
]
```

---

## 📚 相關文件

- [README.md](README.md) - 專案總覽
- [QUICK_START.md](QUICK_START.md) - 快速開始
- [環境變數設定說明.md](環境變數設定說明.md) - 環境變數配置

現在您可以在 DevContainer 中愉快地開發和調試了！🚀
