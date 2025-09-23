---
title: "alacrittyをWindowsで使う時、powershell起動とwsl起動を使いわける"
emoji: "🐥"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["alacritty"]
published: true
---

![](/images/20250923_1.webp)

# Alacrittyの悩み：単一シェル設定の壁

Windows環境で開発をしていると、状況に応じてコマンドプロンプト（バッチ処理の実行）、PowerShell（スクリプト実行やシステム管理）、そしてWSL上のUbuntuシェル（Linuxコマンドや開発環境）を使い分けたい場面が多くあります。しかし、高機能なターミナルエミュレーターであるAlacrittyでは、設定ファイル `alacritty.toml` で指定できるデフォルトシェルは一つだけ。そこで、Alacrittyの設定を工夫し、複数のシェルを使い分けられるようにする方法を考案しました。

# WSL用設定ファイル `alacritty_wsl.toml` の作成

まず、Alacrittyの基本設定ファイル `alacritty.toml` と同じフォルダに、WSL用の設定ファイル `alacritty_wsl.toml` を作成します。このファイルは、既存の `alacritty.toml` をインポートしつつ、シェル設定のみを上書きする形になります。

```toml:alacritty_wsl.toml
# このファイルはAlacrittyでWSLを起動するための設定です。

# [general] セクション: 一般的な設定
[general]
import = [ # 他のTOMLファイルを読み込みます。
"alacritty.toml" # 基本設定はこちらのファイルから継承します。
]

# [terminal] セクション: ターミナルの動作に関する設定
[terminal]
# shell: 起動するシェルを定義します。
# program: 実行するプログラムを指定（ここではwsl.exe）
# args: プログラムに渡す引数を指定。
#   "-d", "Ubuntu": Ubuntuディストリビューションを指定して起動します。
#   "--cd", "~": WSLのホームディレクトリで起動します。
shell = { program = "wsl.exe", args = ["-d", "Ubuntu", "--cd", "~"]}
```

この設定により、`alacritty_wsl.toml` を指定してAlacrittyを起動すると、デフォルトのシェルではなくWSL上のUbuntuシェルが起動するようになります。

# ワンクリック起動！カスタムショートカットの作成
手動でショートカットを作成することも可能ですが、PowerShellスクリプトを使えばより簡単に作成できます。以下のスクリプトを実行することで、デスクトップにWSL起動用のAlacrittyショートカットを作成します。

```powershell:create_alacritty_shortcut.ps1
# デスクトップのパスを取得
$desktopPath = [Environment]::GetFolderPath("Desktop")

# ショートカットオブジェクトを作成（デスクトップに "Alacritty_wsl.lnk" という名前で）
$s = (New-Object -COM WScript.Shell).CreateShortcut("$desktopPath\Alacritty_wsl.lnk")

# Alacritty本体のパスを指定（通常はC:\Program Files\Alacritty\alacritty.exe）
$s.TargetPath = '%ProgramFiles%\Alacritty\alacritty.exe'

# Alacritty起動時にカスタム設定ファイルを指定する引数
# %AppData%\alacritty\alacritty_wsl.toml は通常 C:\Users\YourUserName\AppData\Roaming\alacritty\alacritty_wsl.toml を指します
$s.Arguments = '--config-file %AppData%\alacritty\alacritty_wsl.toml'

# ショートカットを保存
$s.Save()
```

このスクリプトを実行すると、デスクトップに `Alacritty_wsl` という名前のショートカットが作成されます。このショートカットを開くと、alacritty_wsl.toml の設定が適用され、WSLのUbuntuシェルが起動します。

# スムーズな起動！ランチャーからの呼び出し方

これで、使いたいシェルに応じて作成したショートカットを、PowerToys Runやコマンドパレット、Listaryといった各種ランチャーから簡単に呼び出すことができます。たとえば、PowerToys Runで「alacritty wsl」と入力してEnterを押すだけで、WSL環境のAlacrittyをすぐに起動できるようになるでしょう。

便利ですね！
