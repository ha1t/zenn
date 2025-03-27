---
title: "ダブルクリックでBluetoothを再起動できるようにした"
emoji: "😸"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: ['bat']
published: true
---

自宅のWindows PCの話です。

Bluetoothのマウスの認識が不安定で定期的につながらなくなるのでサービスの再起動をしていたのですが、何度も手動でやるのが面倒になったのでダブルクリックでサービス再起動できるようにしました。

利用するPCの管理者権限を持っている事が前提になりますが、以下のバッチファイルを実行するといい感じにBluetoothを再起動してくれます。

```batch:restart_bluetooth.bat
@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c net stop bthserv && net start bthserv && echo Bluetooth Support Service を再起動しました。 && pause","","runas",1)(window.close)
```

サービスの再起動には管理者権限が必要になりますが、コマンドプロンプトを管理者権限で起動してから実行するのは面倒だし、バッチファイルに管理者権限を付与するのは嫌だったのでRunasを使って昇格のダイアログを出す形にしました。

あまり必要になるケースはないと思いますが似たような事で悩んでいる方はつかってみてください。
