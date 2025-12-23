#!/bin/bash

echo "=========================================="
echo "JBoss Demo API 測試腳本"
echo "=========================================="
echo ""

# 設定 API 基礎 URL
BASE_URL="http://localhost:8082/jboss-demo/api/environment"

echo "1. 測試健康檢查端點..."
echo "----------------------------------------"
curl -s "${BASE_URL}/health"
echo -e "\n"

echo "2. 測試 /all 端點（原始輸出）..."
echo "----------------------------------------"
RESPONSE=$(curl -s "${BASE_URL}/all")
echo "$RESPONSE"
echo -e "\n"

echo "3. 檢查 HTTP 狀態碼..."
echo "----------------------------------------"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}/all")
echo "HTTP Status: $HTTP_CODE"
echo -e "\n"

echo "4. 檢查 Content-Type..."
echo "----------------------------------------"
curl -s -I "${BASE_URL}/all" | grep -i "content-type"
echo -e "\n"

echo "5. 測試 /custom 端點..."
echo "----------------------------------------"
curl -s "${BASE_URL}/custom"
echo -e "\n"

echo "6. 嘗試格式化 JSON（如果有效）..."
echo "----------------------------------------"
if command -v jq &> /dev/null; then
    curl -s "${BASE_URL}/custom" | jq . 2>&1
else
    echo "jq 未安裝，跳過格式化"
fi
echo -e "\n"

echo "=========================================="
echo "測試完成"
echo "=========================================="
