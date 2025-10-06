# zenn

zenn.devのDeploy連携です。mainブランチで更新すると自動的に反映されるようになっています

# 環境構築について
https://zenn.dev/zenn/articles/install-zenn-cli を参考にしてZenn CLIを入れる。

node環境を手元におきたくない場合、Docker Imageを使って環境構築することもできる。WSLのUbuntuでpodman環境を作ってpodman-compose buildして初期セットアップコマンドを実行したらmakeコマンドでやる。

# コマンドについて

## 新規記事の雛形を作成

```bash
new_article.bat
make article
```

## previewサーバーの起動

```bash
preview.bat
make run
```

# その他

## 執筆時の注意点 - slug

URLに使われるslugは一度公開すると変更できないので、執筆を開始したらすぐに確定させる。new:articleの際に --slug で最初から確定させてもよい。

```bash
npx zenn new:article --slug 記事のスラッグ
```

slugは記事のファイル名でもあるので、new_article.bat を実行したあとにarticles以下にできるファイルのファイル名を手で変更しても良い。

## 画像の管理方法

images/ の下に article と同様の名称のフォルダを作成して、そこに画像を置いたあと、！「」（） で読み込む

show_link.bat で画像リンクの一覧が出せるのでコピペする。

