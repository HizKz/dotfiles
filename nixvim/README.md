# Nixvim Config

Nixvimで生成する宣言的なNeovim設定です。LazyVim、`lazy.nvim`、Masonを使わず、
プラグイン、Treesitter parser、LSP、formatter、linterをflakeで固定します。

## 並行検証

現在のHome Manager generationを変更せずに起動できます。

```sh
nix run .#nixvim
```

ビルドと自動テストだけを行う場合は次を実行します。

```sh
nix build --no-link .#nixvim
nix flake check
```

## 構成

- `base.nix`: オプションと`k/t/n/s`を含むキーマップ
- `plugins.nix`: 検索、補完、Treesitter、Markdownなどのプラグイン
- `languages.nix`: Go、Python、TypeScript、VueのLSP・format・lint
- `ui.nix`: Kanagawa配色、Dashboard、bufferline、lualine
- `oil.nix`: Oilの設定とサイドバー制御の読込
- `lua/`: 命令的なUI処理と生成済みDashboardアート

通常のプラグイン設定はNixvimのoptionで管理します。Luaは、Oilサイドバーのwindow
制御、Markdown buffer固有の表示調整、生成済みDashboardアートに限定しています。
旧LazyVim構成やlock fileは使用しません。

引数なしの起動ではDashboardを全幅表示し、Oilサイドバーは開きません。ファイル・
ディレクトリを指定した起動ではサイドバーを自動表示し、Dashboardから必要になった
場合は`<leader>e`で開けます。

## 主なキーマップ

- `k/t/n/s`: 左/下/上/右へ移動
- `h`: 次の検索結果
- `l`: 1文字置換
- `jj`: Insert modeからNormal modeへ戻る
- `<C-s>`: 保存
- `-`: 親ディレクトリをOilで開く
- `<leader>e`: Oilサイドバーへフォーカス
- `<leader>m`: メインエディタへフォーカス
- `<leader>1`から`<leader>9`: 指定バッファへ移動

## 主な確認

```vim
:checkhealth
:LspInfo
:ConformInfo
:Copilot status
```

Neovim内の`vim.fn.exepath()`や`:LspInfo`で、Nixvim wrapper内の`gopls`、
`pyright`、`typescript-language-server`、`vue-language-server`を確認できます。
