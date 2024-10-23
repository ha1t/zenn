---
title: "LINE Notify APIが終了するのでLINE Messaging APIに移行する"
emoji: "🍣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["php", "api", "line"]
published: false
---

# LINE Notify が終わっちゃう

プログラムからちょろっとPOSTするだけで無料で簡単にLINEにメッセージをおくることができる LINE Notifyですが、サービス終了してしまうそうです。

> https://notify-bot.line.me/closing-announce
> いつもLINE Notifyをご利用いただきありがとうございます。
>
> 2016年9月から開発者の皆様に提供してまいりましたLINE Notifyですが、より良いサービスを提供するため、経営資源を後継の類似プロダクトに集中させることとなり、2025年3月31日にサービスを終了させていただくことになりました。LINEを用いた通知連携サービスとして、長年にわたり多くの皆様にご愛顧いただきましたこと、心より感謝申し上げます。
> 
> LINEを用いてユーザーに通知を送るプロダクトとしては、より多彩な機能を備えたMessaging APIを提供しております。

とのことで、LINE Notifyを使っている場合、代替手段を検討する必要がでてきました。

# LINE Messaging APIってなんだ？

## 料金について

https://www.lycbiz.com/jp/service/line-official-account/plan/ で確認できますが、無料で使える範囲に限りがあって、月間200通となっています。
この200通は送付人数xメッセージ通数でカウントされるので、例えば10人入っているグループにMessaging APIで投稿すると20通で上限に達します。
仲間内で使うサービスを作っている人は結構しんどいかもしれないですね。

私の場合、ほぼ自分への通知で通知の回数も少ないため、ギリギリ LINE Messaging APIでカバーできそうです。

# LINE Notify のコード

今までは以下のようなコードでメッセージを送っていました。簡単ですねえ。
簡単なので、他の言語がいいなって場合はchatgptにお願いすればいい感じにやってくれます。

```php
<?php
// https://notify-bot.line.me/doc/ja/
function notify_line(string $message, string $token)  {
        // 送信データ
        $now = date('[Y-m-d H:i:s]');
        $data = array(
                "message" => "{$date} {$message}",
        );

        // URLエンコードされたクエリ文字列を生成
        $data = http_build_query($data, "", "&");

        // ストリームコンテキストのオプションを作成
        $options = array(
                // HTTPコンテキストオプションをセット
                'http' => array(
                        'method'=> 'POST',
                        'header'=> [
                                'Content-Type: application/x-www-form-urlencoded',
                                'Authorization: Bearer ' . $token,
                        ],
                        'content' => $data
                )
        );

        // ストリームコンテキストの作成
        $context = stream_context_create($options);

        // POST送信
        $contents = file_get_contents('https://notify-api.line.me/api/notify', false, $context);
}

$token = "トークン文字列";
$message = "こんにちはこんにちは！",
notify_line($message, $token);
```

