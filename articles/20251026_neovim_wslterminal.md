---
title: "NeoVimでWSLのディストリビューションを選択してターミナルを開く"
emoji: "🐷"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ['neovim']
published: false
---


# NeoVimを使い始めました

20 年近くvimを使ってきて、 .vimrc も880行くらいまで育ててきました。

https://github.com/ha1t/vimrc/blob/master/vimrc

直近10年くらいはマネジメントばかりやっていてコードを書いていなかったのですが、昨今のAIブームにいてもたってもいられず主にプライベートでコードを書き始めているんですが、
現場を離れすぎていて、自分が書いたvimrcや使い込んでいたはずのプラグインが今の時代にあっているか検証するコスト
が大きくなってしまっていたりしてvim-jpに入って情報をキャッチアップしたりしていたのですが、
令和の時代にはみんなvimよりneovimという感じで話をされるので、「そんな違うの？」と思っているところにOmarchyを入れて起動したNeoVimがもう自分の知っているvimとは似ても似つかぬリッチな姿で、ついに重い腰をあげて移行してみることにしたのでした。

# WSLのターミナルを起動したい

` :Terminal ` で、ターミナル起動できるんですが、これが Windows のデフォルトだと、コマンドプロンプト cmd.exe が起動するんですよね。
PowerShellが起動してほしいなら

```lua
vim.opt.shell = "powershell.exe"
vim.opt.shellcmdflag =
  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
```

って書いておけばいいんですが、WSLのターミナルを起動したい場合、いちいちこの値を変更したくないですよね。
というわけでコマンドを作りました。Claudeさんが。

```lua
-- WSLディストリビューションのリストを取得する関数
local function get_wsl_distro_list()
  -- Windows環境かどうかをチェック
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

-- 補完関数
local function wslterm_complete(ArgLead, CmdLine, CursorPos)
  return get_wsl_distro_list()
end

-- ユーザーコマンドの定義
vim.api.nvim_create_user_command("WslTerminal", function(opts)
  local distro_name = opts.fargs[1]
  local command = "wsl -d " .. distro_name
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

# 使い方

` :WslTerminal ` のあと、TABで存在するディストリビューションの一覧を表示してくれて、選択することでそのWSLのターミナルを起動できます。

