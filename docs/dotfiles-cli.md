# dotfiles CLI

`dotfiles`は、このリポジトリの検証、実環境の診断、flake依存の安全な更新を
1つの入口へまとめたCLIです。Home Manager適用後は任意のディレクトリから
実行できます。

リポジトリは、`--repo`で指定したパス、現在のGit root、ghqに登録された
`Hizkz/dotfiles`の順に検索します。

## 検証

```sh
dotfiles check
```

次をまとめて実行します。

- `git diff --check`
- `nix flake check`
- 実環境に対する`./setup.sh --dry-run`

flake checkにはNixvim package、Home Manager activation、Shell・Nix・Lua・JSON・
TOML・YAML・Markdownリンクの検査と、CLI・Zsh関数・`setup.sh`のfixture testが
含まれます。検証ツールを直接使う場合は`nix develop`で固定済みの環境へ入れます。

Home Manager適用前はflake appとして実行できます。

```sh
nix run .#check
```

## 診断

```sh
dotfiles doctor
```

doctorは次を読み取り専用で確認します。

- Git worktreeとHome Manager generation
- NixおよびHome Manager管理コマンドの参照先
- `setup.sh`が管理するリンクの競合と未作成リンク
- Lazygitとcodex-historyの実際の設定読込先
- Homebrewに残っている同名CLI

`[WARN]`だけなら終了statusは0です。必須コマンドの欠落、Home Manager generationの
欠落、リンク競合、設定読込先の不一致がある場合は`[FAIL]`を表示してstatus 1で
終了します。

```sh
nix run .#doctor
```

## 依存更新

通常はNixpkgs unstableだけを更新します。

```sh
dotfiles update
dotfiles update unstable
```

現在のflake参照が許す範囲ですべてのlock inputを更新する場合だけ`all`を指定します。
Herdrのリリースタグなど、`flake.nix`に記述した参照自体は書き換えません。

```sh
dotfiles update all
```

updateはdirty worktreeでは開始しません。GitのHEADから一時リポジトリを作成し、
そこでlock更新、flake check、NixvimとHome Managerのbuild、現在のgenerationとの
closure差分表示を行います。確認に`y`と答えた場合だけ、検証済み`flake.lock`を
本体へコピーしてHome Managerを反映します。

反映に失敗した場合は元の`flake.lock`を復元し、generationが変化していれば
ロールバックします。成功してもGit commitは自動作成しません。

```sh
nix run .#update
nix run .#update -- all
```

別のcheckoutを明示する場合は、サブコマンドの前に`--repo`を指定します。

```sh
dotfiles --repo /path/to/dotfiles doctor
```
