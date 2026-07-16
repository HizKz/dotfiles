# Neovim Config

LazyVim をベースにした個人用の Neovim 設定です。テンプレートを最小限に残しつつ、移動キーの再配置、`oil.nvim` ベースのサイドバー、mint 系のダークテーマ、Markdown 向けの表示調整、Go / Python の開発プリセットを追加しています。

## 構成の要点

- `LazyVim` を土台にして、追加設定は `lua/config` と `lua/plugins` に分離
- 移動キーを `h/j/k/l` ではなく `k/t/n/s` に再配置
- `oil.nvim` をファイラ兼サイドバーとして常時使えるように調整
- サイドバー幅は画面幅の 25% を目安に維持し、起動時やリサイズ時にも崩れにくく調整
- WezTerm に寄せた mint 系ダークテーマを `kanagawa.nvim` の上書きで構成
- `bufferline` と `lualine` も mint / pastel pink ベースで統一
- Dashboard は `snacks.nvim` でカスタムアートと最近使ったファイルを表示
- Markdown では診断表示や spell を抑え、文章を読みやすい表示に変更
- Go / Python は LSP・formatter・linter の導入対象をプリセット化
- `github/copilot.vim` を常時有効化

## ディレクトリ

- `init.lua`
  起動時に `config.lazy` と `config.markdown` を読み込みます。
- `lua/config`
  基本設定、キーマップ、autocmd、配色パレット、Markdown 表示調整などを置いています。
- `lua/plugins`
  LazyVim に対するプラグイン追加や上書き、UI テーマ調整をまとめています。
- `assets`
  ダッシュボード用の画像アセットです。

## 主要キーマップ

この設定では移動キーを入れ替えています。

- `k`: 左
- `t`: 下
- `n`: 上
- `s`: 右
- `h`: 検索の次へ
- `l`: 1文字置換
- `jj`: Insert モードから Normal モードへ戻る
- `<C-s>`: 保存
- `<leader>e`: Oil サイドバーへフォーカス
- `<leader>m`: メインエディタへフォーカス
- `<leader>1` から `<leader>9`: 指定バッファへ移動
- `-`: 親ディレクトリを `oil.nvim` で開く

## 言語サポート

### Go

- `gopls`
- `goimports`
- `gofumpt`
- `golangci-lint`
- `delve`
- `gomodifytags`
- `impl`
- `ray-x/go.nvim`

### Python

- `pyright`
- `ruff`
- `ruff_organize_imports`
- `ruff_format`

必要なツールは `mason.nvim` と各プラグイン設定経由で導入対象に追加しています。

## セットアップ

1. `~/.config/nvim` にこのディレクトリを配置する
2. `nvim` を起動する
3. 初回起動時に `lazy.nvim` と各プラグインが自動で取得される
4. 必要なら `:Mason` を開いて言語ツールの導入状態を確認する

## よく触るファイル

- `lua/config/options.lua`
  基本オプション
- `lua/config/keymaps.lua`
  キーマップ
- `lua/plugins/oil.lua`
  サイドバー挙動
- `lua/plugins/wezterm_concept.lua`
  mint 系テーマと bufferline / lualine の見た目
- `lua/config/palette.lua`
  テーマ全体で使う配色パレット
- `lua/plugins/go_preset.lua`
  Go 開発設定
- `lua/plugins/python_preset.lua`
  Python 開発設定
- `lua/config/markdown.lua`
  Markdown 表示最適化
