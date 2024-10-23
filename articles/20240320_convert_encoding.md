---
title: "Chromeで文字化けが発生するWebサイトを文字コードを指定して表示する方法"
emoji: "😽"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["googlechrome"]
published: true
---

文字化けしたサイトの内容をどうしても読みたくてChromeExtensionをインストールしたお話。

# あれっ。文字コードが変更できない

Google Chrome上からは2017年くらいに文字コードを指定できる機能はなくなってしまったようです。
Chromeの親戚であるEdgeも同様にエンコーディング指定のインターフェイスは見つかりません。
文字化けしたサイトを見る、ただそれだけのために他のブラウザを入れるのもちょっと嫌だなあと思って調べたら、専用のChromeExtensionが公開されていました。

[テキストエンコーディング](https://chromewebstore.google.com/detail/bpojelgakakmcfmjfilgdlmhefphglae)

レビューによると、

> サイトへのアクセスを「すべてのサイト」に設定しているとGmailが機能せず一時的なエラー表示になることがあるので、使うとしたら「クリックされた場合のみ」にしておいたほうが良い。

とあるので、拡張機能の設定からそのようにしておきました。セキュリティの観点からもこれはやっておいたほうがよさそうですね。

使い方は簡単で、変更したいページを開いている状態で右クリックすると「テキストエンコーディング」というメニューが追加されているのでそこから変更したいエンコードを指定するだけです。

昔はEUC-JPで運用されていてUTF-8に移行したけど、ちゃんと移行できてなくて一部EUC-JPになっている部分が化けているんだろうなと思って指定したら予想通り。表示されてよかった。