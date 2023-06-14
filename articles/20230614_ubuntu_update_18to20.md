---
title: "Ubuntu 18.04 LTS のサポート期間が終わったので 20.04 LTSにあげる"
emoji: "💭"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["ubuntu"]
published: true
---

# 18.04 LTSのサポート期間はもうすぎています

Ubuntu 18.04 LTSのサポート期間が2023年5月31日で終了する。あれ今2023年6月じゃん。

ずーっと放置しているUbuntuサーバーのOSバージョンが 18.04 LTSだった事を思い出し、時間のある今のうちにバージョンアップしておく。

# バージョンアップする前にやること

## どんなサービスが動いているか調べる

特に長生きしているサーバーほど、自分が動かしている事を忘れていたサービスがあります。各ユーザーのcrontabやディレクトリを見たり、apacheやnginxの設定、 /var/log/ 以下の状況を見て、動いているサービスをリストアップしましょう。
Dockerで動いているサービスやgoの単体バイナリで動いてるようなものも見逃さないように。
私はtmux上で数年動きつづけるpythonスクリプトを見つけました。

## screenやtmuxの終了

大事な作業の途中のまま放置されたscreenやtmuxセッションがあると、アプデの時に消えて悲しい事になります。プロセスリストを見てもいいかもしれません。

# 作業手順

```
sudo apt update
sudo apt upgrade
```

Dockerサービス再起動していい？とかsshd_config置き換える？とか聞かれるので適当に選択。

```
sudo apt install update-manager
```

なんだかたくさんインストールする

```
sudo reboot
```

なるべくクリーンな状態でアプデしたほうがいいと思うので一旦再起動

> Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 4.15.0-212-generic x86_64)
> 
> - Documentation: [https://help.ubuntu.com](https://help.ubuntu.com/)
> - Management: [https://landscape.canonical.com](https://landscape.canonical.com/)
> - Support: https://ubuntu.com/advantage
> New release '20.04.6 LTS' available.
> Run 'do-release-upgrade' to upgrade to it.

do-release-upgrade しろと表示されるので実行。

```
sudo do-release-upgrade -d
```

実行すると以下のように言われてしまう。

> Checking for a new Ubuntu release
> There is no development version of an LTS available.
> To upgrade to the latest non-LTS develoment release
> set Prompt=normal in /etc/update-manager/release-upgrades.

There is no development version of an LTS available. でぐぐったら -d いらんという情報を得たので

```
sudo do-release-upgrade
```

すると無事すすんだ。

> Third party sources disabled
> 
> Some third party entries in your sources.list were disabled. You can
> re-enable them after the upgrade with the 'software-properties' tool
> or your package manager.

source.list に追加したサードパーティのソースについてはあとで精査する必要があるみたい。

> 9 installed packages are no longer supported by Canonical. You can
> still get support from the community.
> 
> 12 packages are going to be removed. 246 new packages are going to be
> installed. 765 packages are going to be upgraded.
> 
> You have to download a total of 650 M. This download will take about
> 2 minutes with your connection.
> 
> Installing the upgrade can take several hours. Once the download has
> finished, the process cannot be canceled.

途中でnginxやmysql、sshdのconfig上書きするかとかDocker.io再起動していいかとか色々聞かれるのでこたえる

obsolete package消していいかとかも聞かれる

最後に再起動して、以下の画面が出たら作業完了。

> Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-150-generic x86_64)
> 
> - Documentation: [https://help.ubuntu.com](https://help.ubuntu.com/)
> - Management: [https://landscape.canonical.com](https://landscape.canonical.com/)
> - Support: https://ubuntu.com/advantage
> 
> Expanded Security Maintenance for Applications is not enabled.
> 
> 0 updates can be applied immediately.
> 
> 15 additional security updates can be applied with ESM Apps.
> Learn more about enabling ESM Apps service at https://ubuntu.com/esm
> 
> New release '22.04.2 LTS' available.
> Run 'do-release-upgrade' to upgrade to it.

18.04から20.04へのアプデ作業は本当にたくさんの人がやってるのでネット上に情報がたくさんある。なので面倒くさいと思って放置している人もサポート期間すぎちゃってるしあげておくと良いと思います。

ところで、tmuxが右クリックでメニューでるようになっててやべえです。tmux3からこうなってるらしい。
ペーストはShift+右クリックでできる。色々可能性を感じるので、VSCodeをメインにして以来あまり触ってなかったターミナル周りもまたいじってみようかなと思いました。

