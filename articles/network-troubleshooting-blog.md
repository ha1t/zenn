# 一部のWebサイトにしか繋がらない？二重ルーター環境で起きた3つの問題と解決法

## はじめに

ある日、自宅のWi-Fiで「Gmailは見えるのにYahoo!が見えない」という不思議な現象に遭遇しました。調査を進めると、二重ルーター環境特有の問題が3つも重なっていたことが判明。同じような環境の方の参考になればと思い、トラブルシューティングの過程をまとめます。

## 環境

```
インターネット
    ↓
E-WMTA（SoftBank光 光BBユニット）192.168.11.1
    ↓ DMZ設定
Buffalo WSR-1500AX2S 192.168.5.1
    ↓
PC / スマートフォン
```

Buffaloルーターを挟んでいる理由は、Tailscaleのsubnet router用にスタティックルートを設定する必要があったためです。E-WMTAにはスタティックルート機能がありません。

## 症状

- Gmail（gmail.com）は表示できる
- Yahoo! JAPAN（search.yahoo.co.jp）は表示できない
- 一部のアプリ（bitFlyerなど）がWi-Fiだと起動しない
- ドラクエウォークのWebViewがタイムアウトする

## 問題1: LANポートとWANポートの接続ミス

### 調査

まずDNSを疑いましたが、`nslookup`では正常に名前解決できていました。

```powershell
nslookup search.yahoo.co.jp
# → 183.79.249.124 が返ってくる（正常）
```

次に接続テストを実施。

```powershell
Test-NetConnection -ComputerName gmail.com -Port 443
# → TcpTestSucceeded : True（IPv6経由で成功）

Test-NetConnection -ComputerName search.yahoo.co.jp -Port 443
# → TcpTestSucceeded : False（IPv4で失敗）
```

ここで気づきました。**IPv6は通るのにIPv4が通らない**。

Buffaloの管理画面を確認すると：

| 項目 | 状態 |
|------|------|
| 接続方法 | 停止中 |
| 有線リンク | 切断 |

### 原因

E-WMTAのLANポートから**BuffaloのLANポート**に接続していました。正しくは**BuffaloのWANポート**に接続する必要がありました。

### 解決

ケーブルをBuffaloのWANポートに挿し直して、IPv4接続が復活。

### なぜIPv6だけ動いていたのか

IPv6はE-WMTAからRA（Router Advertisement）で配布されており、Buffaloを経由せずに端末まで届いていたためです。IPv4はBuffaloのルーティングが必要でしたが、WAN側が切断状態だったため通信できませんでした。

## 問題2: スマートフォンにIPv6が来ない

IPv4が復活した後、PCでは快適に通信できるようになりましたが、スマートフォンではまだ不安定でした。

### 調査

スマートフォンで https://test-ipv6.com/ にアクセスすると**0/10**。IPv6が来ていませんでした。

一方、PCでは同じテストで10/10。この差は何か？

### 原因

Buffaloがルーターモードで動作しているため、E-WMTAからのIPv6 RA（Router Advertisement）がスマートフォンまで届いていませんでした。PCにIPv6が来ていたのは、おそらく接続タイミングや有線/無線の違いによるものと思われます。

### 解決

Buffaloの管理画面で**NDプロキシ**を有効化しました。

1. Internet → IPv6
2. 「NDプロキシを使用する」を選択

### NDプロキシとは

ND（Neighbor Discovery）はIPv6版のARPのようなプロトコルです。NDプロキシを有効にすると、BuffaloがIPv6のNDメッセージを中継・代理応答し、E-WMTAと端末があたかも直接通信しているかのように振る舞います。

これにより「BuffaloはIPv4だけルーティングし、IPv6はE-WMTAに任せる」という構成が実現できます。

## 問題3: MTUの不一致

IPv6も来るようになりましたが、まだ一部のアプリで問題が続いていました。

- ドラクエウォークのWebViewがタイムアウト
- bitFlyerアプリがWi-Fiだと起動しない
- モバイルデータ（4G）では問題なく動作

### 原因

BuffaloのInternet側MTU値が**1500**に設定されていましたが、SoftBank光（IPv6 IPoE）では回線のMTUが1460程度です。

MTUが大きすぎると、パケットの断片化が発生したり、PMTUD（Path MTU Discovery）がうまく動作しない場合にパケットが破棄されます。特にHTTPSのTLSハンドシェイクのような大きめのパケットで影響が出やすいです。

### 解決

Buffaloの管理画面でMTUを変更しました。

1. Internet → Internet
2. 拡張設定 → Internet側MTU値
3. **1500 → 1460** に変更

これで全てのアプリが正常に動作するようになりました。

## まとめ

| 問題 | 症状 | 原因 | 解決 |
|------|------|------|------|
| LANポート誤接続 | IPv6サイトのみ表示可能 | WAN→LANポートに誤接続 | WANポートに接続し直す |
| IPv6が端末に届かない | スマホでIPv6テスト0/10 | ルーターがRAをブロック | NDプロキシを有効化 |
| アプリがタイムアウト | 特定アプリがWi-Fiで動かない | MTU 1500が大きすぎ | MTUを1460に変更 |

## 教訓

1. **「一部だけ繋がる」はプロトコルの違いを疑う** - 今回はIPv6だけ動いていました
2. **二重ルーター環境ではIPv6の扱いに注意** - NDプロキシやパススルーの設定が必要
3. **MTUは回線に合わせる** - 特にIPoE環境では1500より小さい値が適切なことが多い
4. **モバイルデータとの比較で切り分け** - Wi-Fi固有の問題かどうかがすぐわかる

## 調査に使ったコマンド

```powershell
# DNS解決の確認
nslookup example.com

# TCP接続テスト（PowerShell）
Test-NetConnection -ComputerName example.com -Port 443

# ネットワーク設定の確認
ipconfig /all

# 経路の確認
tracert 192.168.11.1
```

二重ルーター環境は設定が複雑になりがちですが、一つずつ切り分けていけば必ず原因にたどり着けます。この記事が同じような問題で困っている方の助けになれば幸いです。
