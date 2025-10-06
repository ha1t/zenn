---
title: "Macbook Pro 2013-late に Omarchy を入れる"
emoji: "📌"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ['omarchy']
published: true
---

:::message
使っていく上で学んだ情報を随時追記していきます
:::

![](/images/20251001_01.webp)

# Omarchy というのがすごいらしい
DHH が力を入れている簡単に使えるArch Linuxベースで最初から色々なものが入っているOSパッケージ。
最近のどんどん高くなるパソコンを買わなくても古いパソコンでも仕事ができるようになるらしい。

ずっと無職で働いていなかった私もそろそろ仕事ができるようにならないとと思ったけれど、手元のノートパソコンは Macbook Pro 2013-late という10年以上も前のもの。OSのサポートはすでに終了していてバージョンもあげられないしAppStoreもまともに機能してません。

仕方ないなぁ。新しくノートパソコン買うしかないのかー? Webエンジニアは未だにmacが主流らしいぞという事で調べるとスタートが164800円。無職がサッと買えるような値段じゃねぇ。

というわけで試すしかない Hey! Omarchy!

https://omarchy.org/

# インストール手順

入れるパソコンによって手順は異なるので公式サイトをみながらやってほしいのですが、私の場合は、

- WindowsでイメージをダウンロードしてRufusでUSBディスクに書き込み
- Command + R を押しながらMacの電源をいれてUSBブート
- あとはでてくるウィザードに沿って選択

で特に事故る事なくセットアップできました。

最初はやめたくなったときのリカバリ手順とかその準備とか調べていたんですが、ここまで古いmacを復元したところで使い道はないので途中で考えるのをやめました。Macがつかいたいなら新しいのを買います。

# 日本語入力できるようにする

必要なアプリは最初から入っていて、アプリだけじゃなくて設定もされているのでNeoVimとかすんごいかっこいいのがでてくるし、ターミナルもリッチですが、日本語入力系は入ってないので手動で入れる必要があります。

アプリを入れたい場合、Omarchyの中身はArch Linuxなので、Archの流儀を調べてその通りにやってみるとだいたいうまくいきます。

ちょうど komagata さんが画像付きで記事を書いてくださっているのでこの通りにやればよいです。

https://docs.komagata.org/6308

私の場合はSKKが使いたかったので、 ` fcitx5-skk ` をmozcの代わりに入れて設定しました。

# KeePass を入れる

KeePass系はもともとLinuxフレンドリーなので特に苦労せず入ります。

```
sudo pacman -S keepassxc
```

# Slack を入れる
これもコマンド一発でいけます。

```
yay -S slack-desktop
```

# OneDrive を使えるようにする

いろいろプロダクトがあるようなのですが、AIに聞いた感じだと https://github.com/abraunegg/onedrive が良いらしい。たしかに更新されてる。

## onedrive-abraunegg の Install

```
yay -S onedrive-abraunegg
```

インストールしたら初期設定が必要なのですが、基本的には公式のdocsに沿ってセットアップをしていけばOKです。私の場合は以下のようなことをやりました。

## 認証

最初に ` onedrive ` コマンドを実行するとブラウザログイン用のURLがでてきて、Microsoftアカウントでログインすると真っ白な画面になる。アドレスバーのURLをコピーしてターミナルに戻すと設定成功

## config の設定

`nvim $HOME/.config/onedrive/config ` を実行して新しくconfigファイルを作り、中に

```
threads = "4"
```

と記入。デフォルト値は8ですが、古いMacBookの場合、4core  なのでそれにあわせて。
ここを変更しないとsyncするときに警告がでます。

## sync_list の設定

オンデマンド更新じゃなくてフルダウンロードするので共有するディレクトリを絞るために sync_list を設定します。これも初期だとファイル自体存在しないので、 ` nvim $HOME/.config/onedrive/sync_list ` として、共有フォルダを指定します。
ルートにあるファイルを共有したくない場合は sync_list じゃなくて config で設定するようです。

## syncの実行

configやsync_list を変更したら --resync をつけないといけないそうです。

```
onedrive --sync --resync
```

で無事に共有できました。

<!-- ## service として実行する -->

# webcamを有効にする
Macbook ProについてるWebカメラですが、初期セットアップが終わった段階では認識しません。
リモートワークに使うならカメラは使えないと困りますよね。というわけで調べてみると、他のディストリビューションの情報ですが、動かないよーみたいな記事がいくつか見つかり震えていました。

https://forum.endeavouros.com/t/macbook-pro-13-inch-early-2013-facetimehd-webcam-is-not-working/34170

が最終的には https://github.com/patjak/facetimehd/wiki/Installation#get-started-on-arch を見つけて

```
yay -S  facetimehd-dkms facetimehd-data
```

でパッケージをインストールしたあと、本体を再起動したらあっさり認識させる事ができました。これはありがたい。ドライバを作ってくれた作者に感謝ですね。

# いまのところのまとめ

自分はLinuxディストリビューションは dapper drakeのころから Ubuntu 一筋だったのでArchベースと聞いてちゃんと使えるのか不安でしたが、最近はAIもあるし、ぐぐりながらAIに聞いて適当にやってるうちになんとかなりそうという印象になりました。

まだまだメインPCにするほど慣れてはいないので使いこんでいってこのページの内用を充実させていこうと思います。



