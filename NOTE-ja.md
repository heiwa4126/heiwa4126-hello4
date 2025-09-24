# heiwa4126-hello4 メモ

## これは何か

npm プロジェクトを 署名付きで npmjs に公開する練習プロジェクト。
中身は "Hello!"を返す hello()関数だけ。

## 作った手順

1. npm パッケージ作る。
   - TypeScript で書いて mjs,cjs としてビルドする
   - Test suit は vitest(TypeScript で), formatter/linter は Biome
3. npmでpreTestPyPI で公開する(手動)。publish も `uv publish`で。twine は使わない
   - 「すべてのプロジェクト」スコープのトークンを使う
4. GitHub Actions 経由で、testPyPI に公開する。
   - TestPyPI 上の既存プロジェクトに対して Trusted publishing 設定する
   - この段階では workflow でも `uv publish` を使う
   - suzuki-shunsuke/pinact, rhysd/actionlint, nektos/act などを使う (あと aquaproj/aqua)
5. Sigstore 署名をつけて testPyPI に公開する
   - workflow を `uv publish` から `pypa/gh-action-pypi-publish` に変更
6. Sigstore 署名をつけて PyPI に公開する
   - PyPI 上で新規プロジェクトとして Trusted publishing を設定
7. ドキュメントをまとめる
