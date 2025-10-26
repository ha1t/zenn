---
title: "Neovimで特定のWSLディストリビューションを選択してターミナルを開く"
emoji: "🐷"
type: "tech"
topics: ['neovim', 'wsl', 'windows']
published: true
---

## Neovimへの道

20年近くVimを使い込み、`.vimrc`は880行を超えるほどに育ててきました。

https://github.com/ha1t/vimrc/blob/master/vimrc

しかし、ここ10年ほどはマネジメント業務が中心で、コードを書く機会から遠ざかっていました。昨今のAIブームに触発され、再びプライベートでコーディングを始めたのですが、気分はすっかり浦島太郎。長年かけて作り上げたVim環境やプラグインが、現代の開発スタイルに合っているのかを検証するだけでも一苦労です。

情報収集のためにvim-jpを覗いてみると、昨今はVimよりもNeovimの話題が中心。「そんなに違うものか？」と半信半疑でしたが、[Omarchy](https://github.com/Omarchy/omarchy)というディストリビューションにはデフォルトではVimが入っておらずNeovimしかないので試してみたところ、そのリッチな機能とモダンなUIに衝撃を受けました。これはもう、私が知っているVimとは別物です。ついに重い腰を上げ、Neovimへの移行を決意しました。

## 課題：WindowsでWSLターミナルを手軽に開きたい

Neovimに移行して早速便利だと感じたのが、`:terminal`コマンドです。しかし、Windows環境で実行すると、デフォルトでは懐かしのコマンドプロンプト（`cmd.exe`）が起動してしまいます。

せめてPowerShellが起動してほしいという場合は、以下のように設定ファイル（`init.lua`など）に記述することで対応できます。

```lua
vim.opt.shell = "powershell.exe"
vim.opt.shellcmdflag =
  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
```

しかし、私の主な開発環境はWSL上にあります。この設定では、WSLのターミナルを開くたびに設定を書き換える必要があり、非常に面倒です。理想は、複数のWSLディストリビューションの中から、使いたいものを手軽に選んで起動できることでした。

## 解決策：Luaでカスタムコマンドを作成する

そこで、この課題を解決するためのカスタムコマンドを作成することにしました。AI（Claude）にも手伝ってもらい、以下のLuaスクリプトが完成しました。

```lua
-- WSLディストリビューションのリストを取得する関数
local function get_wsl_distro_list()
  -- Windows環境でなければ空のリストを返す
  if vim.fn.has("win32") == 0 then
    return {}
  end

  -- 'wsl --list --quiet' を実行し、結果をリストとして取得
  local output = vim.fn.systemlist("wsl --list --quiet")

  local distros = {}
  for _, line in ipairs(output) do
    -- 💡 修正点: BOM(\239\187\191)、CR(\r)、LF(\n)、NULL文字(\0)を除去
    local distro_name = line
      :gsub("\239\187\191", "") -- UTF-8 BOM
      :gsub("\255\254", "") -- UTF-16 LE BOM
      :gsub("\r", "") -- キャリッジリターン
      :gsub("\n", "") -- ラインフィード
      :gsub("\0", "") -- NULL文字
      :match("^%s*(.-)%s*$") -- 前後の空白を削除

    if distro_name and distro_name ~= "" then
      table.insert(distros, distro_name)
    end
  end

  return distros
end

-- コマンドライン補完のための関数
local function wslterm_complete(ArgLead, CmdLine, CursorPos)
  return get_wsl_distro_list()
end

-- :WslTerminal ユーザーコマンドの定義
vim.api.nvim_create_user_command("WslTerminal", function(opts)
  local distro_name = opts.fargs[1]
  if not distro_name or distro_name == "" then
    print("エラー: ディストリビューション名が指定されていません。")
    return
  end

  local command = "wsl -d " .. distro_name
  -- 2つ目以降の引数は、そのままWSLコマンドに渡す
  if #opts.fargs > 1 then
    local extra_args = table.concat(opts.fargs, " ", 2)
    command = command .. " " .. extra_args
  end
  vim.cmd("terminal " .. command)
end, {
  nargs = "*",
  complete = wslterm_complete,
  desc = "Open a terminal with a specific WSL distribution",
})
```

### コードの解説

このスクリプトは、主に3つの部分から構成されています。

1.  **`get_wsl_distro_list()` 関数**:
    Windows環境下で`wsl --list --quiet`コマンドを実行し、インストールされているWSLディストリビューションの一覧を取得します。ここで重要なのは、コマンドの出力結果を整形する処理です。`wsl`コマンドの出力には、UTF-8のBOM（Byte Order Mark）や不要な改行コードが含まれている場合があり、これらが残っているとディストリビューション名を正しく認識できません。そのため、`gsub`関数と`match`関数を使ってこれらの余分な文字を丁寧に取り除き、クリーンなリストを生成しています。

2.  **`wslterm_complete()` 関数**:
    Neovimのコマンドライン補完機能のための関数です。`:WslTerminal`と入力した後にTabキーを押すと、この関数が呼び出され、`get_wsl_distro_list()`で取得したディストリビューション名が補完候補として表示されます。

3.  **`vim.api.nvim_create_user_command()`**:
    これらを使って、`:WslTerminal`という新しいユーザーコマンドを定義します。このコマンドは、引数で渡されたディストリビューション名を使って`wsl -d <ディストリビューション名>`というコマンドを組み立て、`:terminal`で実行します。これにより、指定したWSL環境のターミナルがNeovim内で開きます。

## 導入方法

上記のLuaスクリプトを、お使いのNeovim設定ファイル（`init.lua`など）にコピー＆ペーストしてください。もし設定をモジュール化している場合は、専用のファイル（例: `lua/custom/wsl.lua`）を作成して`require`で読み込むのがおすすめです。

## 使い方

設定を読み込んだ後、Neovimで以下のようにコマンドを実行します。

```
:WslTerminal
```

コマンドの後にスペースを入力してTabキーを押すと、インストール済みのWSLディストリビューション（`Ubuntu`, `Debian`など）が一覧で表示されます。

そのままディストリビューション名を選択してEnterキーを押せば、その環境のターミナルをNeovim内に新しいウィンドウで開くことができます。

快適なNeovimライフをお過ごしください！

