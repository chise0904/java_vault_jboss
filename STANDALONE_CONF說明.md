# 📘 standalone.conf 環境變數設定指南

## 🎯 什麼是 standalone.conf？

`standalone.conf` 是 JBoss/WildFly 的**啟動配置檔案**，用於設定：
- JVM 參數（記憶體、GC 等）
- 系統環境變數
- Java System Properties

## 📍 檔案位置

```
JBoss/WildFly 安裝目錄：
  └── bin/
      ├── standalone.conf          ← Linux/Mac 版本
      └── standalone.conf.bat      ← Windows 版本
```

**在 Docker 中的路徑**:
```
/opt/jboss/wildfly/bin/standalone.conf
```

---

## 🔧 環境變數設定方式對比

### 方式 1: 在 standalone.conf 中使用 `-D` 參數（System Properties）

```bash
# 在 standalone.conf 中
JAVA_OPTS="$JAVA_OPTS -DAPP_NAME='JBoss Demo Application'"
JAVA_OPTS="$JAVA_OPTS -DAPP_VERSION='1.0.0'"
```

**讀取方式**:
```java
String appName = System.getProperty("APP_NAME");
```

### 方式 2: 在 standalone.conf 中使用 export（環境變數）

```bash
# 在 standalone.conf 中
export APP_NAME="JBoss Demo Application"
export APP_VERSION="1.0.0"
```

**讀取方式**:
```java
String appName = System.getenv("APP_NAME");
```

### 方式 3: 在 docker-compose.yml 中設定

```yaml
# 在 docker-compose.yml 中
environment:
  - APP_NAME=JBoss Demo Application
  - APP_VERSION=1.0.0
```

**讀取方式**:
```java
String appName = System.getenv("APP_NAME");
```

---

## 📊 三種方式的優先順序

| 優先順序 | 方式 | 設定位置 | 適用場景 |
|---------|------|----------|----------|
| **1️⃣ 最高** | standalone.conf | `$JBOSS_HOME/bin/standalone.conf` | 本地部署、傳統部署 |
| **2️⃣ 中** | Docker 環境變數 | `docker-compose.yml` | 容器化部署 |
| **3️⃣ 低** | standalone.xml | JNDI 配置 | 應用程式級別 |

---

## 🐳 在 Docker 中使用 standalone.conf

### 方法 1: 掛載自訂的 standalone.conf

1. **編輯配置檔案**: [`wildfly-config/standalone.conf`](wildfly-config/standalone.conf)

2. **修改 docker-compose.yml**:
```yaml
volumes:
  - ./target/jboss-demo.war:/opt/jboss/wildfly/standalone/deployments/jboss-demo.war
  - ./wildfly-config/standalone.conf:/opt/jboss/wildfly/bin/standalone.conf  # 加這行
```

3. **重新部署**:
```bash
docker-compose down
docker-compose up -d
```

### 方法 2: 建立自訂 Docker 映像

建立 `Dockerfile`:
```dockerfile
FROM quay.io/wildfly/wildfly:26.1.3.Final-jdk17

# 複製自訂的 standalone.conf
COPY wildfly-config/standalone.conf /opt/jboss/wildfly/bin/standalone.conf

# 複製應用程式
COPY target/jboss-demo.war /opt/jboss/wildfly/standalone/deployments/
```

建置並執行:
```bash
docker build -t my-jboss-app .
docker run -p 8080:8080 my-jboss-app
```

---

## 📝 standalone.conf 範例

我已經為您建立了完整的範例檔案：

### Linux/Mac 版本
檔案: [`wildfly-config/standalone.conf`](wildfly-config/standalone.conf)

```bash
# JVM 記憶體設定
JAVA_OPTS="-Xms512m -Xmx2048m"

# 方法 1: 使用 System Properties
JAVA_OPTS="$JAVA_OPTS -DAPP_NAME='JBoss Demo Application'"
JAVA_OPTS="$JAVA_OPTS -DAPP_VERSION='1.0.0'"
JAVA_OPTS="$JAVA_OPTS -DDATABASE_URL='jdbc:postgresql://localhost:5432/demodb'"

# 方法 2: 使用環境變數
export APP_NAME="JBoss Demo Application"
export APP_VERSION="1.0.0"
export DATABASE_URL="jdbc:postgresql://localhost:5432/demodb"
```

### Windows 版本
檔案: [`wildfly-config/standalone.conf.bat`](wildfly-config/standalone.conf.bat)

```batch
rem JVM 記憶體設定
set "JAVA_OPTS=-Xms512m -Xmx2048m"

rem 方法 1: 使用 System Properties
set "JAVA_OPTS=%JAVA_OPTS% -DAPP_NAME=JBoss Demo Application"
set "JAVA_OPTS=%JAVA_OPTS% -DAPP_VERSION=1.0.0"

rem 方法 2: 使用環境變數
set "APP_NAME=JBoss Demo Application"
set "APP_VERSION=1.0.0"
```

---

## 🔍 如何驗證環境變數是否生效？

### 1. 查看 WildFly 啟動日誌

```bash
docker-compose logs wildfly | grep "APP_NAME"
```

### 2. 透過 API 驗證

```bash
# 使用我們的 API 端點
curl http://localhost:8080/jboss-demo/api/environment/methods
```

會顯示不同讀取方式的結果：
```json
{
  "key": "APP_NAME",
  "systemEnv": "JBoss Demo Application",
  "jndi": null,
  "systemProperty": "JBoss Demo Application",
  "smart": "JBoss Demo Application"
}
```

### 3. 進入容器檢查

```bash
# 進入容器
docker exec -it jboss-demo-wildfly bash

# 檢查環境變數
echo $APP_NAME

# 檢查 standalone.conf
cat /opt/jboss/wildfly/bin/standalone.conf | grep APP_NAME
```

---

## 💡 最佳實務建議

### 開發環境
✅ 使用 **docker-compose.yml** 的 `environment`
- 簡單、快速
- 容易修改和測試

### 測試/生產環境
✅ 使用 **standalone.conf** + 掛載
- 更符合傳統 JBoss 部署方式
- 可以設定完整的 JVM 參數
- 便於維護和版本控制

### 敏感資訊
✅ 使用 **Docker Secrets** 或 **環境變數檔案**
```yaml
env_file:
  - .env.production
secrets:
  - db_password
```

---

## 🆚 對比總結

| 項目 | standalone.conf | docker-compose.yml |
|------|----------------|-------------------|
| **設定方式** | Shell 腳本 | YAML 配置 |
| **JVM 參數** | ✅ 支援 | ❌ 不支援 |
| **環境變數** | ✅ 支援 | ✅ 支援 |
| **System Properties** | ✅ 支援 | ⚠️ 需透過 command |
| **適用場景** | 本地/傳統部署 | 容器化部署 |
| **修改後生效** | 需重啟 WildFly | 需重啟容器 |
| **版本控制** | ✅ 易於版控 | ✅ 易於版控 |

---

## 🚀 快速使用指南

### 選擇 1: 使用 docker-compose.yml（目前方式）

直接編輯 `docker-compose.yml` 即可，無需 standalone.conf。

### 選擇 2: 使用 standalone.conf

1. **啟用 standalone.conf 掛載**:
```bash
# 編輯 docker-compose.yml，取消註解這行：
# - ./wildfly-config/standalone.conf:/opt/jboss/wildfly/bin/standalone.conf
```

2. **編輯 standalone.conf**:
```bash
vim wildfly-config/standalone.conf
```

3. **重新部署**:
```bash
docker-compose down
docker-compose up -d
```

### 選擇 3: 兩者併用（推薦）

```yaml
volumes:
  - ./wildfly-config/standalone.conf:/opt/jboss/wildfly/bin/standalone.conf
environment:
  - APP_NAME=JBoss Demo Application  # Docker 環境變數（較高優先權）
```

在 standalone.conf 中設定預設值，在 docker-compose.yml 中覆寫特定環境的值。

---

## 📚 相關文件

- [ENV_CONFIG.md](ENV_CONFIG.md) - 完整的環境變數設定指南
- [環境變數設定說明.md](環境變數設定說明.md) - 中文快速指南
- [docker-compose.yml](docker-compose.yml) - Docker Compose 配置
- [wildfly-config/standalone.conf](wildfly-config/standalone.conf) - Linux/Mac 配置範例
- [wildfly-config/standalone.conf.bat](wildfly-config/standalone.conf.bat) - Windows 配置範例

---

## ✅ 總結

**您說得對**！`bin/standalone.conf` 確實是 JBoss/WildFly 設定環境變數的**標準方式**。

**在本專案中**：
- 我們目前使用 `docker-compose.yml` 設定環境變數（容器化部署的最佳實務）
- 我已經建立了 `wildfly-config/standalone.conf` 範例供您參考
- 您可以選擇使用 standalone.conf、docker-compose.yml，或兩者併用

**推薦做法**：
- 🐳 **容器化部署**: 使用 `docker-compose.yml`
- 🖥️ **傳統部署**: 使用 `standalone.conf`
- 🔄 **混合模式**: standalone.conf 設定預設值，docker-compose.yml 覆寫環境特定值
