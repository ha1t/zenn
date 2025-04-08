---
title: "超簡単。Pushbullet APIを使おう"
emoji: "👌"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ['php', 'pushbullet']
published: true
---

# プログラムからスマホへの通知ってどれ使うのが正解だっけ？

LINE Notifyが終わってしまったので、自分のスマホにカジュアルに通知を送りたいという時に何を使うのがという問題がでてきた。
今まで使っていた部分はLINE Messaging APIに移行したけど、これには無料で送れるメッセージ数に上限がある。

https://zenn.dev/halt/articles/20241023_line_messaging

というわけで、代替手段の調査も兼ねてPushbulletを使ってみる

# 超簡単につかえる Pushbullet API

アカウントを取得して、通知を受取りたいPCやスマホにPushbulletのアプリを入れたら、以下のURLでCreate Access Tokenを押してトークンを取得する。

https://www.pushbullet.com/#settings/account

あとは以下のドキュメントを参考にコードを書くだけ。

https://docs.pushbullet.com/#create-push

というかPushbullet自体は歴史があってAPIの実装もシンプルなので自分でコードを書かなくてもAIに作ってもらえば大丈夫です。以下のような感じ。

```php:PushbulletNotifier.php
class PushbulletNotifier {
    private $apiKey;
    private $endpoint = 'https://api.pushbullet.com/v2/pushes';

    public function __construct($apiKey) {
        $this->apiKey = $apiKey;
    }

    public function sendNotification($title, $body) {
        $data = array(
            'type' => 'note',
            'title' => $title,
            'body' => $body,
        );

        $ch = curl_init($this->endpoint);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Access-Token: ' . $this->apiKey,
            'Content-Type: application/json',
        ));

        $response = curl_exec($ch);
        curl_close($ch);

        if ($response === false) {
            return 'cURLエラー: ' . curl_error($ch);
        } else {
            $result = json_decode($response, true);
            if (isset($result['error'])) {
                return 'Pushbullet APIエラー: ' . $result['error']['message'];
            } else {
                return 'プッシュ通知を送信しました。';
            }
        }
    }
}
```

# 自分用の通知ならこれでいいかも
ツールとしてもAPIとしても癖のない使い方ができるので、個人で使う通知システムとしてはPushbulletかなり良いのではないでしょうか。

