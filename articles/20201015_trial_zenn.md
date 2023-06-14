---
title: "zenn入門 画像はどうやって扱うんだろう？"
emoji: "👌"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: ["zenn"]
published: false
---

# GitHub連携でzennの記事を書くメリット

## コミットログが残せる

執筆途中でどんな内容を書いたのかコミットログを残せるのはメリットになりそう。

# ZennのGitHub連携に挑戦してみるが画像どうするんだろう

Zenn本体は画像をD&DするとMDのURLに展開されるけどGitHub連携しているときに画像はどうやって扱えばいいんだろう？

## zenn.dev uploader を使う
https://zenn.dev/dashboard/uploader から画像をアップロードできるので、それを使ってURLを作る。

![](https://storage.googleapis.com/zenn-user-upload/pq0gax4x94wlohmi6hii0nfwxw8a)

↑の画面に画像をアップロードすると…。

![](https://storage.googleapis.com/zenn-user-upload/1i0u4rmk5w1mhp0t5ul2vrnf169i)

こんな感じで画像が管理されるようになる。

## 画像はGitHub上にバックアップされないの？サービス終了時に画像が取り出せないの困るね？

こまる。なので、GithubActionsとかで記事の公開時にスクレイピングしてGitに保存するようにしたら良さそう。

つまり、この画像の自動バックアップがうまくいけばZennとGitHubを連携しての執筆はいい感じにできそう

# slug について

slugはちゃんとつけたい。

ちゃんとしたslugをつける意味としては、URLを綺麗にしたい。URLを見てある程度内容が推測できるものが好ましいから。あとはVSCodeやGitHub上で見たときにも推測しやすい、ソートを意識した名前にする事で執筆順に並べることができるなどがある。

自分はファイルでのソートなどを考慮して YYYYmmdd_記事名.md とした。

## あとからrenameできるのかな？

GitHub連携している場合はgit mvすればGit上は変わるけど…。
やってみたらいい感じに変わっていた。後からでもgit mvするだけで変更できるみたい。
一度公開した後にURLを変えると前のURLでは参照できなくなるので注意。


