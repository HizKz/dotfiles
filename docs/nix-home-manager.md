# Nix / Home Manager 運用ガイド

このリポジトリでは、CLIツールをNixとHome Managerで管理しています。
Neovimなどの設定ファイルはNixへ移しておらず、引き続き`setup.sh`が作成する
直接シンボリックリンクで管理します。

## 現在の管理構成

| 対象 | 管理方法 |
| --- | --- |
| Git、gh、ghq、fzf、lazygit、Starship、Zoxide | Home Manager |
| Neovim、WezTerm、Karabiner、Starshipの設定 | `setup.sh`によるシンボリックリンク |
| GUIアプリ、Homebrew cask | Homebrew |
| Flutter、Node.js、Pythonなどの言語環境 | 既存のバージョン管理ツール |

Home Manager本体と基本モジュールは26.05系に固定し、CLIパッケージだけ
lock済みのNixpkgs unstableから取得しています。これにより、構成の安定性を
保ちながらCLIのバージョンがHomebrew版より古くなることを避けています。

## ファイルの役割

```text
flake.nix   NixpkgsとHome Managerの入力、apple用構成の入口
flake.lock  取得する依存リビジョンの固定
home.nix    Home Managerで導入するCLIとユーザー設定
setup.sh    ~/.config以下の設定リンクを作成・解除
```

`flake.lock`は手動で編集しません。`nix flake update`などのコマンドで更新し、
設定ファイルと一緒にGitへコミットします。

## 日常の操作

設定を変更したら、リポジトリルートで次を実行します。

```sh
nix flake check
home-manager switch --flake .#apple
```

`nix flake check`は構成を評価します。`home-manager switch`は必要なパッケージを
取得・ビルドして、新しいgenerationを有効化します。

現在のgenerationは次で確認できます。

```sh
home-manager generations
```

管理中のCLIがNix版を参照しているか確認するには、ターミナルを開き直してから
次を実行します。

```sh
command -v git gh ghq fzf lazygit starship zoxide home-manager
```

各パスが基本的に`/Users/apple/.nix-profile/bin/`から始まれば正常です。

## CLIを追加・削除する

CLI一覧は`home.nix`の`home.packages`で管理します。

```nix
packages = with pkgsUnstable; [
  git
  gh
  ghq
  fzf
  lazygit
  starship
  zoxide
];
```

パッケージ名はNixpkgs Searchで確認し、一覧を変更した後に検証・反映します。

```sh
nix flake check
home-manager switch --flake .#apple
```

Homebrewから移行する場合は、必ず先にNix版の起動と既存設定・認証の引き継ぎを
確認します。問題がなければ、最後に重複するformulaだけを削除します。

```sh
brew uninstall <formula>
```

GUIアプリやcaskは無理にNixへ移さず、Homebrew管理を継続します。

## 依存を更新する

CLIパッケージだけ更新する場合は次を使います。

```sh
nix flake update nixpkgs-unstable
nix flake check
home-manager switch --flake .#apple
```

Home Managerや安定版Nixpkgsを含めてすべて更新する場合は次を使います。

```sh
nix flake update
nix flake check
home-manager switch --flake .#apple
```

すべての入力を更新するとHome Manager側の変更も取り込むため、通常は
`nixpkgs-unstable`だけを更新します。更新後は`flake.lock`の差分と主要CLIの
バージョンを確認します。

```sh
git diff -- flake.lock
git --version
gh --version
ghq --version
fzf --version
lazygit --version
starship --version
zoxide --version
```

## ロールバック

現在と過去のgenerationを確認します。

```sh
home-manager generations
```

戻したい行に表示されたNix storeパスの`activate`を実行します。

```sh
/nix/store/<generation-path>/activate
```

動作を確認した後、必要であればGit側の`flake.lock`や設定変更も元へ戻します。
generationの切り戻しだけでは、リポジトリ内のファイルは変更されません。

## 設定リンク

Nixのactivationは、既存の4つの設定リンクを管理しません。リンクは
`setup.sh`で確認・作成します。

```sh
./setup.sh --dry-run
./setup.sh
```

正常な場合、dry-runでは次の4リンクが`unchanged`と表示されます。

```text
~/.config/nvim
~/.config/wezterm
~/.config/karabiner
~/.config/starship.toml
```

## トラブルシューティング

### 変更が反映されない

新しいターミナルを開き、コマンドの参照先とgenerationを確認します。

```sh
command -v git
home-manager generations
```

古いシェルではPATHが更新前のまま残ることがあります。

### Flakesが無効と表示される

Home Manager適用後は`~/.config/nix/nix.conf`が生成され、`nix-command`と
`flakes`が有効になります。初回セットアップ前だけはREADME記載の
`NIX_CONFIG`付きbootstrapコマンドを使用します。

### `Git tree is dirty`という警告が出る

未コミット変更があることを示す警告です。ローカルファイルを使った評価自体は
可能ですが、再現性を明確にするため、意図した変更は検証後にコミットします。

### Homebrew版が選ばれる

新しいターミナルで参照先を確認します。

```sh
command -v <command>
```

まだ`/opt/homebrew/bin`を指す場合は、同名formulaが残っていないか確認します。

```sh
brew list --formula | grep '^<formula>$'
```

Nix版が正常に動くことを確認してからHomebrew版を削除します。

### Nix版をすぐ試したい

PATHに依存せず、profile内の実体を直接実行できます。

```sh
~/.nix-profile/bin/ghq --version
```

## 運用上の注意

- `home.stateVersion`はHome Managerを更新しても安易に変更しません。
- `flake.lock`は必ずGit管理し、各マシンで同じ依存を利用します。
- 認証情報やアプリケーションの自動バックアップはNix設定へ追加しません。
- Homebrewを完全に排除することは目的にしません。
- Nix Storeのgarbage collectionは、不要なgenerationを確認してから行います。
