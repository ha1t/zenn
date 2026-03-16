---
title: "PowerShell でも eza を使おう"
emoji: "🌊"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ['powershell', 'eza', 'windows']
published: false
---

![](/images/20260316_01.webp)

Linuxにezaを導入しているときにezaの公式サイトに「winget install eza」という文字が目に入り、それなら使ってみるかという事で導入しました。

## eza とは

[eza](https://eza.rocks/) はRustで書かれた `ls` の現代的な代替ツールです。ファイルをカラー表示してくれたり、Gitのステータスを一緒に表示してくれたりと、標準の `ls` より見やすい出力が得られます。冒頭の画像はこのリポジトリ上で `ls -lha` を実行したものですが、Gitで変更があるファイルには `N`（新規）や `M`（変更）といった情報が表示されています。

## インストール

```powershell
winget install eza-community.eza
```

これだけです。winget最高ですね。インストール後は新しいターミナルを開くと `eza` コマンドが使えるようになります。

## ls で eza が呼ばれるようにする

毎回 `eza` と打つのは面倒なので、`ls` と打てば `eza` が動くように設定します。PowerShellのプロファイルを編集します。

```powershell
notepad $PROFILE
```

ファイルが存在しない場合は新規作成されます。以下の内容を追記してください。

```powershell
# 既存の ls エイリアスを削除
if (Test-Path Alias:ls) { Remove-Item Alias:ls -Force }

# 関数で定義（引数をそのまま eza に渡す）
function ls { eza @args }
```

PowerShellには `ls` が `Get-ChildItem` のエイリアスとして最初から登録されているため、単純に `Set-Alias` で上書きしようとするとエラーになります。そのため、いったんエイリアスを削除してから関数として再定義する形にしています。

実はWindowsには複数バージョンのPowerShellが入っていて、デフォルト的に動いているのが5.1なので、5.1で動く書き方になっています。PowerShell 7を使っている場合も同じ書き方で動きます。

## よく使うオプション

`@args` で引数をそのまま渡しているので、ezaのオプションがそのまま使えます。

```powershell
ls -l        # 詳細表示
ls -la       # 隠しファイルも含めた詳細表示
ls -lha      # ヘッダー付きで人間が読みやすいサイズ表示
ls --tree    # ツリー表示
ls --git     # Gitステータスを表示
```

## アイコン表示（おまけ）

`--icons` オプションを付けるとファイルの種類に応じたアイコンが表示されます。ただし、[Nerd Fonts](https://www.nerdfonts.com/) 対応のフォントをターミナルで使っていないと文字化けするので注意してください。

```powershell
ls --icons
```

デフォルトでアイコンを表示したい場合はプロファイルの関数を変更します。

```powershell
function ls { eza --icons @args }
```

## まとめ

Windowsでも `winget` でさっとインストールして、プロファイルに数行追加するだけで快適なezaライフが送れます。Gitの差分を見ながらファイル一覧を確認できるのが地味に便利です。
