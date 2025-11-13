#!/bin/bash
set -e

echo "🔥 Testing CLI..."

# ローカルにインストールされたパッケージのCLIを直接実行
output=$(node node_modules/@heiwa4126/hello4/esm/main.js)
echo "CLI Output: $output"

# 期待する出力と比較
expected="Hello!"
if [ "$output" != "$expected" ]; then
    echo "❌ Expected '$expected', got: '$output'"
    exit 1
fi

echo "✅ CLI test passed!"
