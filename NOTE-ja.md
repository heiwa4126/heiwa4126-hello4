# heiwa4126-hello4 メモ

## これは何か

npm プロジェクトを 署名付きで npmjs に公開する練習プロジェクト。
中身は "Hello!"を返す hello()関数だけ。

## 作った手順

1. npm パッケージ作る。
   - TypeScript で書いて mjs,cjs としてビルドするタイプ
   - Test suit は vitest(TypeScript で), formatter/linter は Biome
2. npm で prepatch バージョンとして公開する(まず手動)。
3. GitHub Actions から Trusted publishing で npm にパブリッシュする
   - たぶん GitHub 上で `npm publish` した段階で Sigstore 署名がついてしまう
   - suzuki-shunsuke/pinact, rhysd/actionlint, nektos/act などを使う (あと aquaproj/aqua)
4. ドキュメントをまとめる

## 手動でパブリッシュ

**重要:
npm の Trusted Publishing は 「初回の手動 publish を完全にスキップする」ことはできません。**

まずテストを手動で

```sh
npm run lint
npm run test
npm build
npm pack --dry-run
npm login --auth-type=web # 動作チェック
```

で、

```sh
npm publish --access public
# run-scripts の `prepublishOnly` が先に実行される
```

トークンは `~/.npmrc` に保存されるので、Trusted Publishing 設定後は
`~/.npmrc` を消してしまうのが安全。

### WSL の場合、ブラウザ認証は wslu が便利

[wslutilities/wslu: A collection of utilities for Windows Subsystem for Linux](https://github.com/wslutilities/wslu)

```sh
sudo apt install wslu -y
# 以下の環境変数を.bashrcなどに設定
export BROWSER=wslview
```

## Trusted Publishing の設定

npm の該当プロジェクトの setting で

Publishing access:

- ✅Require two-factor authentication and disallow tokens (recommended)
