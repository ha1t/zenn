---
title: "数年ぶりにzenn-cliを使ったら Unexpected Token ? になった時の対処方法"
emoji: "🐙"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: ["zenn"]
published: true
---

Windows11で数年ぶりにZenn投稿しようと思い、zenn-cliで

```
npx zenn new:article
```

したら、

```
Unexpected token ?
```

と表示されて記事を作成することができなかった。検索すると、Nodeのバージョンが古いらしい。

```
node -v
```

すると、v10.13.0と表示された。最新がv20らしい。古すぎる…。そもそもWindowsにどうやってNodeを入れたか忘れてしまったが、今ならwingetでなんとかなるのでは？ということで、winget search nodejsしたらLTSがあったので、

```
winget install OpenJS.NodeJS.LTS
```

を実行したら、 v18.16.0がインストールされた。前のバージョンは正しくアンインストールされたのかとか色々気になるが、これでnew:articleしたら無事に動いたのでヨシッ！
