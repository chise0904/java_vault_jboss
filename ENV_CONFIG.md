# 🔧 JBoss/WildFly 環境變數設定指南

## Tomcat vs JBoss/WildFly 對比

| 項目 | Tomcat | JBoss/WildFly |
|------|--------|---------------|
| 配置檔案位置 | `webapp/META-INF/context.xml` | 多種方式 (見下方) |
| JNDI 設定 | `<Context>` 標籤 | `standalone.xml` 或 `jboss-web.xml` |
| 環境變數 | `<Environment>` 標籤 | 系統環境變數或 JNDI |

---

## 📍 JBoss/WildFly 環境變數設定方式

### 方式 1: 系統環境變數 (推薦 - 目前使用)

**設定位置**: `docker-compose.yml`

```yaml
services:
  wildfly:
    environment:
      - APP_NAME=JBoss Demo Application
      - APP_VERSION=1.0.0
      - APP_ENVIRONMENT=production
      - DATABASE_URL=jdbc:postgresql://localhost:5432/demodb
      - API_KEY=demo-api-key-12345
```

**讀取方式**:
```java
String appName = System.getenv("APP_NAME");
```

**優點**:
- ✅ 簡單直接
- ✅ 符合 12-Factor App 原則
- ✅ 容器化部署友好
- ✅ 不需修改 WildFly 配置

---

### 方式 2: JNDI 資源 (最接近 Tomcat context.xml)

**設定位置**: `$JBOSS_HOME/standalone/configuration/standalone.xml`

在 `<subsystem xmlns="urn:jboss:domain:naming:2.0">` 區段加入:

```xml
<subsystem xmlns="urn:jboss:domain:naming:2.0">
    <bindings>
        <simple name="java:global/env/APP_NAME"
                value="JBoss Demo Application"
                type="java.lang.String"/>
        <simple name="java:global/env/APP_VERSION"
                value="1.0.0"
                type="java.lang.String"/>
        <simple name="java:global/env/DATABASE_URL"
                value="jdbc:postgresql://localhost:5432/demodb"
                type="java.lang.String"/>
    </bindings>
</subsystem>
```

**讀取方式**:
```java
import javax.naming.InitialContext;

InitialContext ctx = new InitialContext();
String appName = (String) ctx.lookup("java:global/env/APP_NAME");
```

**優點**:
- ✅ 類似 Tomcat context.xml 的概念
- ✅ 可設定多種資料型態
- ✅ 應用程式間可共享
- ❌ 需要修改 WildFly 配置檔

---

### 方式 3: Java System Properties

**設定方式**: 啟動 WildFly 時加上 `-D` 參數

```bash
./standalone.sh -DAPP_NAME="JBoss Demo" -DAPP_VERSION="1.0.0"
```

**或在 Docker Compose 中**:
```yaml
services:
  wildfly:
    command: >
      /opt/jboss/wildfly/bin/standalone.sh
      -b 0.0.0.0
      -DAPP_NAME="JBoss Demo"
      -DAPP_VERSION="1.0.0"
```

**讀取方式**:
```java
String appName = System.getProperty("APP_NAME");
```

---

### 方式 4: web.xml 環境變數 (傳統方式)

**設定位置**: `src/main/webapp/WEB-INF/web.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
         https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">

    <env-entry>
        <env-entry-name>APP_NAME</env-entry-name>
        <env-entry-type>java.lang.String</env-entry-type>
        <env-entry-value>JBoss Demo Application</env-entry-value>
    </env-entry>

    <env-entry>
        <env-entry-name>APP_VERSION</env-entry-name>
        <env-entry-type>java.lang.String</env-entry-type>
        <env-entry-value>1.0.0</env-entry-value>
    </env-entry>

</web-app>
```

**讀取方式**:
```java
import javax.naming.InitialContext;

InitialContext ctx = new InitialContext();
String appName = (String) ctx.lookup("java:comp/env/APP_NAME");
```

---

### 方式 5: 屬性檔案 (Properties File)

**設定位置**: `src/main/resources/application.properties`

```properties
app.name=JBoss Demo Application
app.version=1.0.0
app.environment=production
database.url=jdbc:postgresql://localhost:5432/demodb
api.key=demo-api-key-12345
```

**讀取方式**:
```java
import java.util.Properties;
import java.io.InputStream;

Properties props = new Properties();
InputStream is = getClass().getClassLoader()
    .getResourceAsStream("application.properties");
props.load(is);
String appName = props.getProperty("app.name");
```

---

## 🎯 推薦使用方式

### 開發環境
- **方式 1**: 系統環境變數 (docker-compose.yml)
- 簡單、快速、易於修改

### 測試環境
- **方式 1** 或 **方式 3**: 系統環境變數或 System Properties
- 方便 CI/CD 整合

### 生產環境
- **方式 2**: JNDI 資源 (standalone.xml)
- 安全性高、集中管理
- 配合環境變數加密機制

---

## 💡 使用 ConfigUtil 工具類

我已經建立了 `ConfigUtil.java` 工具類，提供統一的讀取介面:

```java
import com.example.jboss.util.ConfigUtil;

// 智能讀取 (自動嘗試多種方式)
String appName = ConfigUtil.getConfig("APP_NAME", "Default App");

// 或指定讀取方式
String version = ConfigUtil.getFromSystemEnv("APP_VERSION");
String dbUrl = ConfigUtil.getFromJNDI("java:global/env/DATABASE_URL");
```

---

## 📂 相關檔案位置

| 檔案 | 用途 |
|------|------|
| [docker-compose.yml](docker-compose.yml:14-18) | 系統環境變數設定 |
| [src/main/webapp/WEB-INF/jboss-web.xml](src/main/webapp/WEB-INF/jboss-web.xml) | JBoss 應用配置 |
| [wildfly-config/standalone-custom.xml](wildfly-config/standalone-custom.xml) | JNDI 設定範例 |
| [src/main/java/com/example/jboss/util/ConfigUtil.java](src/main/java/com/example/jboss/util/ConfigUtil.java) | 配置工具類 |

---

## ⚙️ 如何修改環境變數

### 修改現有環境變數

1. 編輯 `docker-compose.yml`:
```yaml
environment:
  - APP_NAME=我的新應用名稱  # 修改這裡
  - NEW_VAR=新的變數值        # 加入新變數
```

2. 重新部署:
```bash
docker-compose down
docker-compose up -d
```

3. 驗證:
```bash
curl http://localhost:8080/jboss-demo/api/environment/custom
```

---

## 🔐 安全性建議

### 敏感資訊處理

❌ **不要** 將敏感資訊直接寫在配置檔案中:
```yaml
# 不好的做法
environment:
  - DATABASE_PASSWORD=secret123
  - API_KEY=sk-12345
```

✅ **建議** 使用 Docker Secrets 或環境變數檔案:
```yaml
# 使用 .env 檔案
env_file:
  - .env.production

# 或使用 Docker Secrets
secrets:
  - db_password
  - api_key
```

---

## 📝 總結

**對應關係**:

| Tomcat | JBoss/WildFly |
|--------|---------------|
| `META-INF/context.xml` | `docker-compose.yml` (系統環境變數) |
| `META-INF/context.xml` | `standalone.xml` (JNDI 資源) |
| `META-INF/context.xml` | `WEB-INF/web.xml` (env-entry) |

**目前專案使用**: 方式 1 (系統環境變數) - 在 `docker-compose.yml` 中設定 ✅
