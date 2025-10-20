# heiwa4126-hello4 メモ

## これは何か

npm プロジェクトを署名付きで npmjs に公開する練習プロジェクト。
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
npm pkg fix
npm run lint
npm run test
npm run build
npm pack --dry-run
npm login --auth-type=web # 動作チェック
```

で、

```sh
npm publish --access public --tag latest
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

Trusted Publisher の Select your publisher で GitHub Actions ボタン。

- Organization or user: heiwa4126
- Repository: heiwa4126-hello4
- Workflow filename: publish.yml
- Environment name: (最初は空で)

"setup connection" ボタン押す。

## workflow 書く

[Trusted publishing for npm packages | npm Docs](https://docs.npmjs.com/trusted-publishers#github-actions-configuration)
を参考に
[publish.yml](.github/workflows/publish.yml)
を書きました。

## Sigstore 証明がつくと

[npm のプロジェクトのページで](https://www.npmjs.com/package/@heiwa4126/hello4)

- バージョンの横にチェックマークがつく (PyPI のチェックマークにはあまり意味がない)
- ページの底に "Provenance" の節が付く。Rekor へのリンクなど。

## その後

いろいろ改造

- Environment name: `npmjs` にした
- workflow 中に条件入れて、オーナーだけ publish できるようにした
- prerelease (semver 中に`-`がある場合) 対応した。
  prerelease だと npm 上で dev タグになる。
  それ以外は latest
- on.push.tags のところ、少し厳密に。以下参考
  - [on\.push\.<branches\|tags\|branches\-ignore\|tags\-ignore>](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpushbranchestagsbranches-ignoretags-ignore)
  - [フィルター パターンのチート シート](https://docs.github.com/ja/actions/reference/workflows-and-actions/workflow-syntax#filter-pattern-cheat-sheet)

## 今後ローカルから直接 npmjs に発行できないようにしたい

「トークン発行を禁止+ 2FA 必須」にしてローカル publish を塞ぐのがよい。

npm の該当プロジェクトの setting の Publishing access で

- ✅Require two-factor authentication and disallow tokens (recommended)

あと package.json の run scrips の prepublishOnly に "CI じゃない場合はエラーになる" コードを書くのも予防的にあり(今回はやってない)。

```json
{
  "scripts": {
    "prepublishOnly": "node scripts/check-ci.js"
  }
}
```

で、

```js
// scripts/check-ci.js
if (!process.env.CI && !process.env.GITHUB_ACTIONS) {
  console.error("⛔ Local publish is disabled. Please use GitHub Actions (Trusted publishing).");
  process.exit(1);
} else {
  console.log("✅ CI環境からの publish を検出しました。続行します。");
}
```

こんな感じ。
