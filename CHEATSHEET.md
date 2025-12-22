# 🚀 JBoss/WildFly 環境變數速查表

## 📍 快速回答：在哪裡設定環境變數？

| Tomcat | JBoss/WildFly (容器) | JBoss/WildFly (傳統) |
|--------|---------------------|---------------------|
| `META-INF/context.xml` | **`docker-compose.yml`** | **`bin/standalone.conf`** |

---

## 🔧 三種設定方式

### 1️⃣ docker-compose.yml（推薦 - 容器部署）

```yaml
services:
  wildfly:
    environment:
      - APP_NAME=JBoss Demo
      - APP_VERSION=1.0.0
```

**讀取**: `System.getenv("APP_NAME")`

---

### 2️⃣ standalone.conf（推薦 - 傳統部署）

```bash
# 方式 A: 環境變數
export APP_NAME="JBoss Demo"

# 方式 B: System Properties
JAVA_OPTS="$JAVA_OPTS -DAPP_NAME='JBoss Demo'"
```

**讀取**:
- 方式 A: `System.getenv("APP_NAME")`
- 方式 B: `System.getProperty("APP_NAME")`

---

### 3️⃣ standalone.xml（進階 - JNDI）

```xml
<subsystem xmlns="urn:jboss:domain:naming:2.0">
    <bindings>
        <simple name="java:global/env/APP_NAME"
                value="JBoss Demo"
                type="java.lang.String"/>
    </bindings>
</subsystem>
```

**讀取**: `ctx.lookup("java:global/env/APP_NAME")`

---

## 📝 常用命令

### 建置專案
```bash
./build.sh
# 或
mvn clean package
```

### 部署應用
```bash
./deploy.sh
# 或
docker-compose up -d
```

### 查看日誌
```bash
docker-compose logs -f wildfly
```

### 驗證環境變數
```bash
curl http://localhost:8080/jboss-demo/api/environment/custom
```

### 進入容器
```bash
docker exec -it jboss-demo-wildfly bash
echo $APP_NAME
```

---

## 🎯 API 端點速查

| 端點 | 功能 |
|------|------|
| `/api/environment/health` | 健康檢查 |
| `/api/environment/all` | 所有環境變數 |
| `/api/environment/custom` | 自訂環境變數 |
| `/api/environment/smart` | 智能讀取 |
| `/api/environment/methods` | 方法對比 |

---

## 💡 ConfigUtil 使用範例

```java
import com.example.jboss.util.ConfigUtil;

// 智能讀取（推薦）
String name = ConfigUtil.getConfig("APP_NAME", "預設值");

// 指定方式
String v1 = ConfigUtil.getFromSystemEnv("APP_NAME");
String v2 = ConfigUtil.getFromSystemProperty("APP_NAME");
String v3 = ConfigUtil.getFromJNDI("java:global/env/APP_NAME");
```

---

## 📂 檔案位置

| 檔案 | 用途 |
|------|------|
| `docker-compose.yml` | Docker 環境變數 |
| `wildfly-config/standalone.conf` | JBoss 配置（Linux/Mac） |
| `wildfly-config/standalone.conf.bat` | JBoss 配置（Windows） |
| `src/.../util/ConfigUtil.java` | 讀取工具類 |

---

## 🔍 故障排除

### 環境變數沒有生效？

```bash
# 1. 檢查容器環境變數
docker exec jboss-demo-wildfly env | grep APP_NAME

# 2. 檢查日誌
docker-compose logs wildfly | grep APP_NAME

# 3. 透過 API 驗證
curl http://localhost:8080/jboss-demo/api/environment/methods
```

### 重新載入配置

```bash
# 停止並刪除容器
docker-compose down

# 重新建置（如果修改了程式碼）
mvn clean package

# 啟動
docker-compose up -d
```

---

## 📚 詳細文件

- [環境變數設定說明.md](環境變數設定說明.md) - 快速指南
- [STANDALONE_CONF說明.md](STANDALONE_CONF說明.md) - standalone.conf 詳解
- [環境變數設定總覽.md](環境變數設定總覽.md) - 完整對比
- [ENV_CONFIG.md](ENV_CONFIG.md) - 進階指南

---

## ✅ 快速決策樹

```
需要設定環境變數？
│
├─ 使用 Docker？
│  ├─ 是 → 編輯 docker-compose.yml
│  └─ 否 → 編輯 wildfly-config/standalone.conf
│
└─ 需要 JVM 調校？
   ├─ 是 → 使用 standalone.conf
   └─ 否 → 使用 docker-compose.yml
```

---

**🎉 現在您知道如何在 JBoss/WildFly 中設定環境變數了！**
