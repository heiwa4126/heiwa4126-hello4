#!/bin/bash
set -e

echo "🔥 Starting smoke test..."

# パッケージディレクトリが存在することを確認
if [ ! -d "../dist" ]; then
    echo "❌ dist/ directory not found. Please run 'npm run build' first."
    exit 1
fi

echo "📦 Installing dependencies..."
npm install --silent

echo "📦 Testing ES Modules API..."
node tests/api-test.mjs

echo "📦 Testing CommonJS API..."
node tests/api-test.cjs

echo "📦 Testing TypeScript API..."
npx tsx tests/api-test.ts

echo "🖥️ Testing CLI..."
./tests/cli-test.sh

echo "✅ All smoke tests passed!"
