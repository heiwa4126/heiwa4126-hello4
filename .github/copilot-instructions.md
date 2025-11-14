# AI Coding Agent Instructions for @heiwa4126/hello4

## Project Overview

これは TypeScript で書かれた npm パッケージで、**Sigstore 署名付き GitHub Actions Trusted Publishing の実装例**として作られています。機能的には単純な hello world ライブラリですが、プロジェクトの本質は**モダンな npm パッケージ公開パイプライン**の実装にあります。

## Architecture & Build System

### Dual Module System (ESM + CJS)

このプロジェクトは ESM と CommonJS の両方をサポートします:

- **ESM ビルド**: `tsconfig.esm.json` → `dist/esm/*.js` (型定義含む)
- **CJS ビルド**: `tsconfig.cjs.json` → `dist/cjs/*.cjs`
- **重要**: CJS ファイルは `.js` → `.cjs` へリネームされる (`rename-cjs` スクリプト)

`package.json` の exports フィールドで両方のモジュールシステムをサポート:

```json
"exports": {
  ".": {
    "types": "./dist/esm/hello.d.ts",
    "import": "./dist/esm/hello.js",
    "require": "./dist/cjs/hello.cjs"
  }
}
```

### ビルドフロー

```bash
npm run build  # ESM → CJS → rename-cjs の順に実行
```

**なぜこの順序か**: CJS ビルドが `.js` を生成し、それを `.cjs` にリネームする必要があるため。

## Critical Developer Workflows

### テストと公開前チェック

```bash
npm run lint          # Biome でコードチェック
npm test              # Vitest でテスト実行
npm run smoke-test    # 実際の dist ファイルを3形式(mjs/cjs/ts)でテスト
npm run prepublishOnly # lint + test + clean + build + smoke-test
```

**重要**: `prepublishOnly` は `npm publish` 時に自動実行されます。ローカルでの手動テストには使えます。

### 公開ワークフロー

**ローカルからの直接公開は非推奨**です。GitHub Actions の Trusted Publishing を使用:

1. バージョンを更新: `npm version [patch|minor|major|prerelease]`
2. タグをプッシュ: `git push --follow-tags`
3. GitHub Actions が自動的に npmjs へ公開

**タグ形式**:

- 通常リリース: `v1.2.3`
- プレリリース: `v1.2.3-rc.1` (ハイフン含む) → npm では `dev` タグ

### Trusted Publishing の仕組み

`.github/workflows/publish.yml` が以下を実装:

- **OIDC 認証**: `id-token: write` パーミッション + `npm publish` (トークン不要)
- **オーナー制限**: `if: github.repository_owner == github.actor`
- **プレリリース判定**: バージョン文字列に `-` があれば `--tag dev`
- **Sigstore 署名**: Trusted Publishing 使用時に自動付与

## Project Conventions

### Import 文での拡張子

TypeScript のソースコードでも **`.js` 拡張子を明示**:

```typescript
import { hello } from "./hello.js";  // ✓ 正しい
import { hello } from "./hello";     // ✗ 避ける
```

理由: ESM として実行時に正しく解決されるため

### テストファイルの配置

- テストファイル: `test/*.test.ts`
- ビルド対象から除外: `tsconfig.*.json` の `exclude` に `**/*.test.ts`

### 例示ファイル (examples/)

`examples/` には 3 形式のテストファイル:

- `test1.mjs`: ESM として直接実行
- `test2.cjs`: CommonJS として実行
- `test3.ts`: TypeScript として tsx で実行

これらは `smoke-test` スクリプトで実行され、ビルド成果物の動作確認に使用

## Tooling

- **テスト**: Vitest (TypeScript ネイティブサポート)
- **Linter/Formatter**: Biome (`.biome.jsonc` で設定)
- **TypeScript**: strict モードで 3 つの tsconfig (base, esm, cjs)

## Security & Access Control

### npm への公開制限

プロジェクト設定で推奨:

- "Require two-factor authentication and disallow tokens" を有効化
- これにより、Trusted Publishing 経由のみが公開可能に

### 環境変数とシークレット

- GitHub Actions では `environment: npmjs` を使用
- ローカルの `~/.npmrc` は Trusted Publishing 設定後に削除推奨

## Key Files Reference

- `NOTE-ja.md`: プロジェクトの詳細な日本語ドキュメント (設計判断の理由など)
- `.github/workflows/publish.yml`: Trusted Publishing の実装
- `package.json`: scripts の `prepublishOnly` に全チェックフロー
- `tsconfig.*.json`: 3 つの設定で dual module をサポート

## When Modifying This Project

- 新機能追加時も `src/hello.ts` と `test/hello.test.ts` のペアを維持
- ビルド変更時は `smoke-test` スクリプトで 3 形式の動作確認必須
- GitHub Actions 変更時は `nektos/act` などでローカルテスト推奨
