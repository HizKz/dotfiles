# Karabiner設定

## ファイルの役割

- `karabiner.json`: Karabinerが実際に読み込む設定。通常の変更はここに入れる
- `o24-layouts.json`: 新しいキーボードへ追加するo24配列の共通設定と差分
- `add-o24-keyboard.sh`: 接続中のキーボードをo24プロファイルへ登録するスクリプト
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

## 新しいキーボードをo24へ追加する

新しいキーボードを接続してから、次のコマンドを実行する。

```sh
./karabiner/add-o24-keyboard.sh
```

未登録の物理キーボードが一覧表示されるので、番号を選ぶ。既定では文字配列と
`right_shift -> left_control`を含む`external`設定が追加される。
同じvendor IDとproduct IDの機種が登録済みの場合は重複して追加しない。

JIS外付けキーボードでは、無変換キーをDeleteにする設定を追加できる。

```sh
./karabiner/add-o24-keyboard.sh --variant jis
```

内蔵キーボードと同じCommand、Option、Deleteの入れ替えも使う場合は、
`macbook-style`を指定する。

```sh
./karabiner/add-o24-keyboard.sh --variant macbook-style
```

設定を書き換えず、追加対象だけを確認する場合は`--dry-run`を付ける。

```sh
./karabiner/add-o24-keyboard.sh --dry-run
```

スクリプトは仮ファイルを検証してから`karabiner.json`を更新する。キーボード選択中に
設定が変更された場合は、既存の変更を上書きせず終了する。

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
