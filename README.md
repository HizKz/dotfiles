# dotfiles

[ghq](https://github.com/x-motemen/ghq) と直接シンボリックリンクで管理する
個人用の設定ファイルです。

## 配置場所

```text
~/ghq/github.com/HizumeKazushi/dotfiles
```

## セットアップ

```sh
brew install ghq
ghq get -p HizumeKazushi/dotfiles
cd ~/ghq/github.com/HizumeKazushi/dotfiles
```

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

## 管理対象のリンク

```text
~/.config/nvim          -> <repository>/nvim
~/.config/wezterm       -> <repository>/wezterm
~/.config/karabiner     -> <repository>/karabiner
~/.config/starship.toml -> <repository>/starship/starship.toml
```

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
