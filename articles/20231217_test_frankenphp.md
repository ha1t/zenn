---
title: "FrankenPHP v1.0.0 を試す！"
emoji: "🐘"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ['php', "frankenphp"]
published: true
---

# FrankenPHPとは

https://frankenphp.dev/

FrankenPHPとはGo言語で書かれたPHPのアプリケーションサーバーで、これ１つでPHPを動かす事ができます。

もうそのままGoで書けぇ！というツッコミが私の心のなかに出てきましたが
あったら便利だなという気持ちになったので試してみました。

# PHPの課題 - アプリケーションサーバー構築がだるい

:::message
あくまで個人の感想です
:::

平成の話なんですけど、PHPは「静的なHTMLの一部を簡単に動的にする」HTMLと親和性の高いスクリプト言語で「HTML・CSSをサーブする環境である」Apacheやnginxにmod_phpやfcgiで実装されていました。
そのため、ローカルマシン上で開発する場合は、PHPを動かすのに必要なWebサーバーなどを一括で用意できるXAMPPやMAMPというプロダクトを作って環境構築したり、自前で複数バージョンのPHPを動かせるfcgi環境を作ったりしていました。

令和になってDockerを利用した開発環境も出てきましたが、サービスごとに環境を作ったり、環境のメンテナンスをすることは大変です。特にクラウドサービスの台頭により、ローカルの開発環境とリモートの環境の差分が大きくなってきました。

また、PHPの利用目的も「動的にHTMLを生成する」ことだけでなく「JSONなどを返すAPIサーバー」のような役割を持つこともあり、apacheやnginxの下で動かす事に違和感を感じる環境もあるように思います。

その点、FrankenPHPはワンバイナリでも動かせるアプリケーションサーバーのため環境構築のコストをかなり下げることができ、Webサーバーにとらわれない開発が簡単にできるようになりそうです。楽しそうですね。

# WindowsのWSL環境で早速試してみる

提供されているバイナリ形式はLinuxとMacだけなので、WindowsユーザーはWSL経由で動かします。(もちろんDockerでも無問題です)

以下のような感じで手元にfrankenphpをもってきたら

```
$ wget "https://github.com/dunglas/frankenphp/releases/download/v1.0.0/frankenphp-linux-x86_64"
$ mv frankenphp-linux-x86_64 frankenphp
```

以下のようなPHPファイルを用意して

```php:hw.php
<?php
echo "hello world" . PHP_EOL
```

php-cliという引数とともに指定すると実行できます。

```
$ frankenphp php-cli hw.php
hello world
```

簡単ですね。

# SpongeCake をさらっと動かす

主要フレームワークには対応済みという事で、逆にいうと主要でないフレームワークは対応が必要になるのかと思い [SpongeCake](https://github.com/tsukimiya/spongecake/pull/26) で試してみました。
もともとPHP内蔵のWebサーバーが使える設定が含まれているのでそれを流用します。

ざっくりですが、以下のような操作で普通に動きました。webrootディレクトリの上でphp-serverを実行するだけです。

```
git clone https://github.com/tsukimiya/spongecake.git
sudo apt install composer
cd spongecake
composer install
cd app/config
cp core.development.php core.php
cd ../webroot
frankenphp php-server --listen :3000
```

デフォルトのポート番号が80になっているので埋まっている場合は「--listen」を使ってポート番号を指定しましょう。

# さいごに

かなり簡単に使えるようになっています。興味を持ったらまずは試してみましょう。
この記事を書いている間に v1.0.1 が出ていました。これからどんどん便利になっていきそうでワクワクしますね。

