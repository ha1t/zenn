---
title: "alacrittyをWindowsで使う時、powershell起動とwsl起動を使いわける"
emoji: "🐥"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["alacritty"]
published: false
---

# デフォルトシェルが1つしか設定できない問題
Windowsを使っていると、コマンドプロンプトを使いたい場合やPowerShellを使いたい場合、WSL上のUbuntuのシェルを起動したい場合などがありますよね。
でも alacritty の config で設定できるシェルは1つしかない。つかいわけしたいので設定を考えました。

# alacritty_wsl.toml を作ってalacritty.tomlと同じフォルダにおいておく。

以下のファイルを作って、Alacrittyの起動時に --config-file で指定する事でシェルを指定して起動できるようにします。

```toml:alacritty_wsl.toml
# env:
#  TERM: xterm-256color

[general]
import = [
"alacritty.toml"
]

[terminal]
shell = { program = "wsl.exe", args = ["-d", "Ubuntu", "--cd", "~"]}
```

# ショートカットをつくる

alacritty.exe を右クリックしてショートカットの作成をしたあと、プロパティを開いて引数を入れれば良いのですが、PowerShellから以下を実行する事でも作れます。

```powershell:create_alacritty_shortcut.ps1
$desktopPath = [Environment]::GetFolderPath("Desktop")
$s = (New-Object -COM WScript.Shell).CreateShortcut("$desktopPath\Alacritty_wsl.lnk")
$s.TargetPath = '%ProgramFiles%\Alacritty\alacritty.exe'
$s.Arguments = '--config-file %AppData%\alacritty\alacritty_wsl.toml'
$s.Save()
```

# よびだす

あとは使いたいときに PowerToysRunやコマンドパレット、Listaryなんかのランチャで呼ぶとよいです。

