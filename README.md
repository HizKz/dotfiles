# dotfiles

[Nix](https://nixos.org/) と
[Home Manager](https://github.com/nix-community/home-manager) でCLIを、
直接シンボリックリンクでアプリケーション設定を管理する個人用dotfilesです。

NixとHome Managerの日常的な使い方、更新、ロールバック、トラブル対応は
[`docs/nix-home-manager.md`](docs/nix-home-manager.md) を参照してください。

## 配置場所

```text
~/ghq/github.com/HizumeKazushi/dotfiles
```

## 初回セットアップ

Nixをインストールした後、Nixpkgsのghqを一時的に実行してリポジトリを取得します。

```sh
nix --extra-experimental-features 'nix-command flakes' \
  run github:NixOS/nixpkgs/nixos-26.05#ghq -- \
  get -p HizumeKazushi/dotfiles
cd ~/ghq/github.com/HizumeKazushi/dotfiles
```

Home Managerを初回適用します。この操作によって、以降のNixコマンドで
`nix-command` と `flakes` が有効になります。

```sh
NIX_CONFIG='experimental-features = nix-command flakes' \
  nix run github:nix-community/home-manager/release-26.05#home-manager -- \
  switch --flake .#apple
```

## 設定リンク

リンクを作成する前に変更内容を確認します。

```sh
./setup.sh --dry-run
```

リンクを作成します。

```sh
./setup.sh
```

管理しているリンクを解除します。

```sh
./setup.sh --remove
```

## 日常の操作

Home Manager設定を反映します。

```sh
home-manager switch --flake .#apple
```

依存を更新してから反映する場合は、lock fileを更新します。

```sh
nix flake update
home-manager switch --flake .#apple
```

以前のHome Manager generationへ戻す場合は、一覧に表示される対象の
`activate` を実行します。

```sh
home-manager generations
/nix/store/<generation-path>/activate
```

## 管理範囲

Home Managerでは、Git、GitHub CLI、ghq、fzf、lazygit、Starship、Zoxideを
管理します。GUIアプリ、Homebrew cask、言語ランタイムは引き続きそれぞれの
既存手段で管理します。

## 管理対象のリンク

```text
~/.config/nvim          -> <repository>/nvim
~/.config/wezterm       -> <repository>/wezterm
~/.config/karabiner     -> <repository>/karabiner
~/.config/starship.toml -> <repository>/starship/starship.toml
```

Karabinerの設定構成、反映確認、トラブルシューティングは
[`karabiner/README.md`](karabiner/README.md) を参照してください。

セットアップスクリプトは何度実行しても同じ結果になります。既存のファイル、
ディレクトリ、別の場所を指すリンク、リンク切れのシンボリックリンクは
上書きしません。変更前にすべての配置先を確認するため、競合が1件でもあれば
処理全体を中止します。`--remove` では、現在のリポジトリを指すリンクだけを
解除します。

リポジトリを移動する場合は、移動前に `./setup.sh --remove` を実行し、
移動後の場所で `./setup.sh` を再実行してください。

このリポジトリには、明示的に管理する設定だけを追加します。
`gh/hosts.yml` や `neonctl/credentials.json` など、アプリケーションの
認証情報は追加しないでください。
