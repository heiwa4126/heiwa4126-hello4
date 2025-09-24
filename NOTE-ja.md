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
   - たぶん `npm publish` の段階で Sigstore 署名がついてしまう
   - suzuki-shunsuke/pinact, rhysd/actionlint, nektos/act などを使う (あと aquaproj/aqua)
4. prepatch から patch までバージョンをあげて npm にパブリッシュする workflow を書く
5. ドキュメントをまとめる
