@echo off
rem =========================================================================
rem
rem  WildFly standalone 啟動配置檔案 (Windows)
rem
rem  此檔案用於設定 JVM 參數和環境變數
rem  路徑: %JBOSS_HOME%\bin\standalone.conf.bat
rem
rem =========================================================================

rem JVM 記憶體設定
set "JAVA_OPTS=-Xms512m -Xmx2048m"

rem JVM 性能調優參數
set "JAVA_OPTS=%JAVA_OPTS% -XX:MetaspaceSize=256m"
set "JAVA_OPTS=%JAVA_OPTS% -XX:MaxMetaspaceSize=512m"
set "JAVA_OPTS=%JAVA_OPTS% -Djava.net.preferIPv4Stack=true"

rem JVM GC 設定
set "JAVA_OPTS=%JAVA_OPTS% -XX:+UseG1GC"
set "JAVA_OPTS=%JAVA_OPTS% -XX:+UseStringDeduplication"

rem =========================================================================
rem 應用程式環境變數設定 (使用 -D 參數)
rem =========================================================================

rem 方法 1: 使用 System Properties (推薦)
set "JAVA_OPTS=%JAVA_OPTS% -DAPP_NAME=JBoss Demo Application"
set "JAVA_OPTS=%JAVA_OPTS% -DAPP_VERSION=1.0.0"
set "JAVA_OPTS=%JAVA_OPTS% -DAPP_ENVIRONMENT=production"
set "JAVA_OPTS=%JAVA_OPTS% -DDATABASE_URL=jdbc:postgresql://localhost:5432/demodb"
set "JAVA_OPTS=%JAVA_OPTS% -DAPI_KEY=demo-api-key-12345"

rem 資料庫連線設定
set "JAVA_OPTS=%JAVA_OPTS% -DDB_HOST=localhost"
set "JAVA_OPTS=%JAVA_OPTS% -DDB_PORT=5432"
set "JAVA_OPTS=%JAVA_OPTS% -DDB_NAME=demodb"
set "JAVA_OPTS=%JAVA_OPTS% -DDB_USER=dbuser"

rem 日誌設定
set "JAVA_OPTS=%JAVA_OPTS% -Dlogging.level=INFO"
set "JAVA_OPTS=%JAVA_OPTS% -Dlog.path=C:\wildfly\logs"

rem =========================================================================
rem 方法 2: 使用環境變數
rem =========================================================================

set "APP_NAME=JBoss Demo Application"
set "APP_VERSION=1.0.0"
set "APP_ENVIRONMENT=production"
set "DATABASE_URL=jdbc:postgresql://localhost:5432/demodb"
set "API_KEY=demo-api-key-12345"

rem =========================================================================
rem WildFly 特定設定
rem =========================================================================

set "JAVA_OPTS=%JAVA_OPTS% -Djboss.bind.address=0.0.0.0"
set "JAVA_OPTS=%JAVA_OPTS% -Djboss.bind.address.management=0.0.0.0"

rem 當 OOM 時產生 heap dump
set "JAVA_OPTS=%JAVA_OPTS% -XX:+HeapDumpOnOutOfMemoryError"
set "JAVA_OPTS=%JAVA_OPTS% -XX:HeapDumpPath=%TEMP%\wildfly-heapdump.hprof"

rem =========================================================================
rem 除錯設定（開發環境使用）
rem =========================================================================

rem 如果需要除錯，取消下面的註解
rem set "JAVA_OPTS=%JAVA_OPTS% -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8787"

rem =========================================================================
rem 輸出設定資訊（除錯用）
rem =========================================================================
echo ==========================================
echo WildFly Configuration
echo ==========================================
echo JAVA_OPTS: %JAVA_OPTS%
echo APP_NAME: %APP_NAME%
echo APP_VERSION: %APP_VERSION%
echo ==========================================
