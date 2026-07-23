# AGENTS.md

このリポジトリは、macOS向けの個人用dotfilesです。CLIとZshはNixおよび
Home Managerで、NeovimはNixvim、その他のアプリケーション設定は`setup.sh`が作成する直接
シンボリックリンクで管理します。

## 管理境界

- CLIパッケージは原則として`pkgsUnstable`を使用し、Home Manager本体と基本
  モジュールは安定版へ固定する。
- Zshの共通設定は`shell.nix`へ置き、端末・仕事固有の設定は
  `~/.config/zsh/local.zsh`へ置く。後者をリポジトリへ追加しない。
- Neovimはflakeが生成するNixvim packageをHome Managerで導入する。WezTerm、
  Karabiner、Starship、Herdr、lazygit、codex-historyの設定リンクは`setup.sh`で管理する。
- `home.stateVersion`は互換性の基準なので、パッケージ更新に合わせて変更しない。
- `flake.lock`を手動編集しない。

## 安全性

- 認証情報、API key、端末固有の状態、仕事固有の絶対パスをコミットしない。
- Karabinerの`automatic_backups`、Neovimログ、`.DS_Store`を追加しない。
- 既存ファイルや別の場所を指すシンボリックリンクを上書きしない。
- キーバインド、設定リンク、日常の操作方法を変更した場合は、対応するREADMEも
  同じ変更で更新する。

## 検証

通常の変更では次を実行する。

```sh
nix flake check
nix build --no-link .#nixvim
nix build --no-link .#homeConfigurations.apple.activationPackage
sh -n setup.sh karabiner/add-o24-keyboard.sh
for file in karabiner/karabiner.json karabiner/o24-layouts.json \
  karabiner/assets/complex_modifications/*.json; do
  jq empty "$file"
done
```

設定リンクまたは`setup.sh`を変更した場合は、実機へ反映する前に追加で
`./setup.sh --dry-run`を実行する。Zsh設定を変更した場合は、新しいログインシェルで
`ZDOTDIR`、主要コマンドの参照先、補完とキーバインドを確認する。
