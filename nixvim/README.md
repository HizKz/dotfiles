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

- `base.nix`: Neovimの共通オプション
- `keymaps.nix`: `k/t/n/s`を含むグローバルキーマップ
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

`<leader>`はSpaceです。`<leader>?`で現在のバッファから利用できるキーマップを
確認できます。

### 基本操作

- `k/t/n/s`: 左/下/上/右へ移動
- `h`: 次の検索結果
- `N`: 前の検索結果
- `l`: 1文字置換
- `jj`: Insert modeからNormal modeへ戻る
- `<C-s>`: 保存
- `<A-j>`/`<A-k>`: 行または選択範囲を上下へ移動

これらの移動キーは非再帰マッピングです。`k -> h -> n -> k`のような循環を
防ぐため、移動キーへ`remap = true`を設定しないでください。

### ウィンドウとバッファ

- `<C-k>`/`<C-t>`/`<C-n>`/`<C-l>`: 左/下/上/右のウィンドウへ移動
- `<C-矢印>`: ウィンドウのサイズを変更
- `<leader>-`/`<leader>|`: 下/右へ分割
- `<S-h>`/`<S-l>`または`[b`/`]b`: 前/次のバッファへ移動
- `<leader>bd`: 現在のバッファを削除
- `<leader>bb`: 直前のバッファへ戻る
- `-`: 親ディレクトリをOilで開く
- `<leader>e`: Oilサイドバーへフォーカス
- `<leader>m`: メインエディタへフォーカス
- `<leader>1`から`<leader>9`: 指定バッファへ移動

`<C-s>`は保存に使うため、右ウィンドウへの移動だけは`<C-l>`です。

### ファイルと検索

- `<leader><space>`/`<leader>ff`: プロジェクト内のファイルを検索
- `<leader>fF`: 現在のディレクトリ内のファイルを検索
- `<leader>fg`: Git管理ファイルを検索
- `<leader>/`/`<leader>sg`: プロジェクト全体をgrep
- `<leader>sG`: 現在のディレクトリをgrep
- `<leader>fb`: バッファを検索
- `<leader>fr`: 最近開いたファイルを検索
- `<leader>sk`: キーマップを検索
- `<leader>sr`: プロジェクト内を検索・置換

プロジェクト基準の検索はproject.nvimが検出したルートを使い、検出できない場合は
現在のディレクトリを使います。

### コードと診断

- `gd`/`gr`/`gI`/`gy`/`gD`: 定義、参照、実装、型定義、宣言へ移動
- `K`/`gK`: hover/signature help
- `<leader>ca`/`<leader>cr`: code action/rename
- `<leader>cf`: Conformでformat
- `[d`/`]d`: 前/次の診断
- `[e`/`]e`: 前/次のerror
- `[w`/`]w`: 前/次のwarning
- `<leader>cd`: 現在行の診断を表示
- `<leader>xx`: Troubleで診断一覧を表示

### プラグイン

- `<leader>j`/`<leader>J`: Flash/Flash Treesitter
- `[h`/`]h`: 前/次のGit hunk
- `[t`/`]t`: 前/次のTODOコメント
- `<leader>qs`: 現在のディレクトリのsessionを復元
- `<leader>cp`: Markdown Previewを切り替え
- `<leader>um`: Render Markdownを切り替え

## 主な確認

```vim
:checkhealth
:LspInfo
:ConformInfo
:Copilot status
```

Neovim内の`vim.fn.exepath()`や`:LspInfo`で、Nixvim wrapper内の`gopls`、
`pyright`、`typescript-language-server`、`vue-language-server`を確認できます。
