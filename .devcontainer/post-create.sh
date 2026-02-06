#!/bin/bash

echo "=========================================="
echo "DevContainer 初始化..."
echo "=========================================="

# 建置專案（失敗不阻擋容器啟動）
echo "🔨 建置專案..."
if mvn clean package -f /workspaces/*/pom.xml 2>&1; then
    echo "✅ 專案建置成功！"
else
    echo "⚠️ 專案建置失敗，可稍後手動執行 mvn clean package"
fi

echo "✅ DevContainer 初始化完成！"
