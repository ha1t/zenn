---
title: "Windowsで新規作成にテキストファイルがなくなった時に実行するbatを作った"
emoji: "🐈"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["cmd", "windows"]
published: true
---

Notepadがアップデートされた時におこるのでしょうか、自分のWindows11環境だと、定期的にコンテキストメニューの新規作成からテキストファイルが消滅してしまう現象が発生しています。

解決方法はレジストリを操作すればよくて、具体的な手順は以下の記事で詳細に説明されています。

https://loumo.jp/archives/28108

一度目はこれでやったんですが、二度目ともなるとコマンド一発で対応したいですよね。以下のコマンドをコピーしてbatファイルとして保存したあと管理者として実行すると一発で作れます。

:::message alert
注意: レジストリの変更はシステムに影響を及ぼす可能性があります。このスクリプトを実行する前に、レジストリのバックアップを取ることを強く推奨します。また、このスクリプトは自己責任で使用してください。
:::

```bat:create_shellnew.bat
@echo off

:: .txt ファイルの既定のプログラムを確認
for /f "tokens=2*" %%a in ('reg query "HKEY_CLASSES_ROOT\.txt" /ve') do set DefaultProgram=%%b

:: ShellNew キーを作成（存在しない場合）
reg add "HKEY_CLASSES_ROOT\%DefaultProgram%\ShellNew" /f

:: ShellNew キーに FileName 値を設定
reg add "HKEY_CLASSES_ROOT\%DefaultProgram%\ShellNew" /v "NullFile" /t REG_SZ

taskkill /f /im explorer.exe
start explorer.exe

echo Done.
pause
```

ただ、レジストリをいじるのは危険なので、毎回手入力するのがいいかもしれない。
