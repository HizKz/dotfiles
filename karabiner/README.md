# Karabiner設定

## ファイルの役割

- `karabiner.json`: Karabinerが実際に読み込む設定。通常の変更はここに入れる
- `assets/complex_modifications/*.json`: Karabiner-Elementsへ追加するためのルール素材。
  ここだけを変更しても、現在のプロファイルには反映されない
- `automatic_backups/*.json`: Karabiner-Elementsが作成したバックアップ

現在使う設定リンクは次の形にする。

```text
~/.config/karabiner -> <repository>/karabiner
```

確認コマンド:

```sh
readlink ~/.config/karabiner
jq empty ~/.config/karabiner/karabiner.json
```

## 設定変更後の確認

JSONを変更したら、構文と差分を確認する。

```sh
jq empty karabiner/karabiner.json
git diff --check
```

現在のプロファイルを確認する。

```sh
'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' \
  --show-current-profile-name
```

スペースレイヤーは、スペースキーの押下で変数を有効化してから各キーを変換する。
そのため `space + key` は、スペースを先に押したまま対象キーを押して確認する。

## JSONを変更しても反映されない場合

### 原因

Karabinerの起動中に `~/.config/karabiner` のディレクトリやシンボリックリンクを
置き換えると、Karabiner-Core-Serviceが置き換え前の削除済みJSONを開いたままに
なることがある。この場合、リポジトリのJSONと選択中のプロファイルが正しくても
変更は反映されない。

### 読込先の確認

Karabiner-Core-Serviceが実際に開いているJSONを確認する。

```sh
lsof -c Karabiner 2>/dev/null | rg 'karabiner\.json'
```

出力されるパスが、現在のリポジトリにある
`<repository>/karabiner/karabiner.json` であることを確認する。削除済みの古いパスや
想定外の入れ子パスを開いている場合は、サービスを再起動する。

### 再読込

Karabinerのユーザーサービスを再起動する。

```sh
launchctl kickstart -k \
  "gui/$(id -u)/org.pqrs.service.agent.Karabiner-Core-Service-rev2"
launchctl kickstart -k \
  "gui/$(id -u)/org.pqrs.service.agent.karabiner_console_user_server"
```

再起動後、現在のプロファイルと読込先をもう一度確認する。

```sh
'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' \
  --show-current-profile-name
lsof -c Karabiner 2>/dev/null | rg 'karabiner\.json'
```

GUIを使う場合は、Karabiner-Elementsを終了して起動し直してもよい。
