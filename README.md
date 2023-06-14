# zenn

zenn.devのDeploy連携です。mainブランチで更新すると自動的に反映されるようになっています

## 執筆時の注意点 - slug

URLに使われるslugは一度公開すると変更できないので、執筆を開始したらすぐに確定させる。以下のコマンドで最初から確定させてもよい。

```
npx zenn new:article --slug 記事のスラッグ
```

## 画像の管理方法

images/ の下に article と同様の名称のフォルダを作成して、そこに画像を置いたあと、！「」（） で読み込む

## preview

```
npx zenn preview
```

