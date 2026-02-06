#!/bin/bash

# DevContainer 開發環境快速啟動腳本

echo "=========================================="
echo "🚀 JBoss DevContainer 開發環境啟動"
echo "=========================================="
echo ""

# 檢查是否在 DevContainer 內
if [ ! -d "/workspace" ]; then
    echo "⚠️  警告: 似乎不在 DevContainer 內運行"
    echo "建議: 在 VS Code 中使用 'Reopen in Container'"
    echo ""
fi

# 步驟 1: 清理舊的建置
echo "📦 步驟 1/5: 清理舊的建置..."
mvn clean
echo "✅ 清理完成"
echo ""

# 步驟 2: 建置 WAR 檔案
echo "🔨 步驟 2/5: 建置 WAR 檔案..."
mvn package -DskipTests
if [ $? -ne 0 ]; then
    echo "❌ 建置失敗！請檢查錯誤訊息。"
    exit 1
fi
echo "✅ 建置完成"
echo ""

# 步驟 3: 檢查 WAR 檔案
echo "🔍 步驟 3/5: 檢查 WAR 檔案..."
if [ -f "target/jboss-demo.war" ]; then
    WAR_SIZE=$(ls -lh target/jboss-demo.war | awk '{print $5}')
    echo "✅ WAR 檔案存在 (大小: $WAR_SIZE)"
else
    echo "❌ WAR 檔案不存在！"
    exit 1
fi
echo ""

# 步驟 4: 停止舊容器（如果有）
echo "🛑 步驟 4/5: 停止舊容器..."
docker-compose -f docker-compose.debug.yml down 2>/dev/null
echo "✅ 舊容器已停止"
echo ""

# 步驟 5: 啟動 WildFly（調試模式）
echo "🚀 步驟 5/5: 啟動 WildFly（調試模式）..."
docker-compose -f docker-compose.debug.yml up -d

if [ $? -ne 0 ]; then
    echo "❌ WildFly 啟動失敗！"
    exit 1
fi
echo "✅ WildFly 已啟動"
echo ""

# 等待應用程式啟動
echo "⏳ 等待應用程式啟動（約 30 秒）..."
echo "   可以使用以下命令查看日誌："
echo "   docker-compose -f docker-compose.debug.yml logs -f wildfly"
echo ""

# 倒數計時
for i in {30..1}; do
    printf "\r   等待中... %2d 秒" $i
    sleep 1
done
printf "\r   等待完成!              \n"
echo ""

# 健康檢查
echo "🏥 健康檢查..."
HEALTH_CHECK=$(curl -s http://localhost:8080/jboss-demo/api/environment/health 2>/dev/null)

if [ $? -eq 0 ] && [[ "$HEALTH_CHECK" == *"WildFly"* ]]; then
    echo "✅ 應用程式運行正常！"
else
    echo "⚠️  應用程式可能還在啟動中，請稍後再試"
    echo "   使用以下命令檢查日誌："
    echo "   docker-compose -f docker-compose.debug.yml logs -f wildfly"
fi
echo ""

# 顯示可用的 API 端點
echo "=========================================="
echo "📡 可用的 API 端點："
echo "=========================================="
echo "✅ 健康檢查:"
echo "   http://localhost:8080/jboss-demo/api/environment/health"
echo ""
echo "✅ 所有環境變數:"
echo "   http://localhost:8080/jboss-demo/api/environment/all"
echo ""
echo "✅ 自訂環境變數:"
echo "   http://localhost:8080/jboss-demo/api/environment/custom"
echo ""
echo "✅ 智能讀取:"
echo "   http://localhost:8080/jboss-demo/api/environment/smart"
echo ""
echo "✅ 方法對比:"
echo "   http://localhost:8080/jboss-demo/api/environment/methods"
echo ""

# 顯示調試資訊
echo "=========================================="
echo "🐛 調試資訊："
echo "=========================================="
echo "Debug Port: 8787"
echo "在 VS Code 中按 F5 開始調試"
echo ""

# 顯示常用命令
echo "=========================================="
echo "🔧 常用命令："
echo "=========================================="
echo "查看日誌:"
echo "  docker-compose -f docker-compose.debug.yml logs -f wildfly"
echo ""
echo "停止服務:"
echo "  docker-compose -f docker-compose.debug.yml down"
echo ""
echo "重新部署:"
echo "  mvn package && docker-compose -f docker-compose.debug.yml up -d --force-recreate"
echo ""
echo "測試 API:"
echo "  ./test-api.sh"
echo ""

echo "=========================================="
echo "🎉 開發環境啟動完成！"
echo "=========================================="
