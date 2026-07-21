# Nixvim Config

Nixvimで生成する宣言的なNeovim設定です。LazyVim、`lazy.nvim`、Masonを使わず、
プラグイン、Treesitter parser、LSP、formatter、linterをflakeで固定します。

## 並行検証

現在のHome Manager generationを変更せずに起動できます。

```sh
nix run .#nixvim
```

設定は`wrapRc = true`で生成しているため、既存の`~/.config/nvim`は読みません。
ビルドと自動テストだけを行う場合は次を実行します。

```sh
nix build --no-link .#nixvim
nix flake check
```

## 構成

- `base.nix`: オプションと`k/t/n/s`を含むキーマップ
- `plugins.nix`: UI、検索、補完、Treesitterなどのプラグイン
- `languages.nix`: Go、Python、TypeScript、VueのLSP・format・lint
- `legacy.nix`: Oilサイドバー、テーマ、ダッシュボードなど複雑な既存Luaの読込

Oilサイドバー、mint系テーマ、Dashboard、Markdown表示は既存Luaをruntimeへ
組み込んで維持しています。プラグイン自体はNixが導入するため、初回起動時の
Git cloneや`:Mason`は不要です。

## 主な確認

```vim
:checkhealth
:LspInfo
:ConformInfo
:Copilot status
```

Neovim内の`vim.fn.exepath()`や`:LspInfo`で、Nixvim wrapper内の`gopls`、
`pyright`、`typescript-language-server`、`vue-language-server`を確認できます。
