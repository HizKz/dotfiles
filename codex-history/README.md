# codex-history設定

## ファイルの役割

- `config.toml`: codex-historyが実際に読み込む設定

現在使う設定リンクは次の形にする。

```text
~/Library/Application Support/codex-history/config.toml
  -> <repository>/codex-history/config.toml
```

リンクを作成する前に変更内容を確認する。

```sh
./setup.sh --dry-run
```

問題がなければリンクを作成する。

```sh
./setup.sh
```

## 設定変更後の確認

TOMLの内容と設定値を検証する。

```sh
codex-history config check \
  --config "$PWD/codex-history/config.toml"
git diff --check
```

起動中のcodex-historyでは`ctrl+r`を押すと設定を再読み込みできる。
設定ファイルの読込先は次のコマンドで確認する。

```sh
codex-history config path
readlink "$HOME/Library/Application Support/codex-history/config.toml"
```

`config.toml`に未指定の項目はcodex-history内蔵の既定値を継承する。
キーマップをすべて独自に定義する場合は`keys.use_defaults = false`にする。
ただし`ctrl+c`は緊急終了用として常に予約されている。

## o24向けキーバインド

Karabiner-Elementsの`o24`プロファイルを前提に、Karabiner変換後の入力文字を
基準に設定している。QWERTYの物理位置ではなく、o24で入力される文字を
`config.toml`へ記述する。

### 一覧と本文の操作

| o24入力 | 操作 |
| --- | --- |
| `n` | 上へ移動 |
| `t` | 下へ移動 |
| `,` | 1ページ上へ移動 |
| `.` | 1ページ下へ移動 |
| `Shift+,` | 一覧の先頭へ移動 |
| `Shift+.` | 一覧の末尾へ移動 |
| `h` | 選択した会話やActivityを開く |
| `k` | 前のturnへ移動 |
| `s` | 次のturnへ移動 |
| `Space` | Activityの詳細表示を切り替える |
| `Esc` | 詳細やActivityを閉じる |

矢印、Enter、PageUp、PageDown、Home、Endも使用できる。本文と詳細では、
o24入力の`Ctrl+u`と`Ctrl+d`によるページ移動も使用できる。

### 全体の操作

| o24入力 | 操作 |
| --- | --- |
| `q` | 終了 |
| `Shift+/` | キーバインドヘルプ |
| `/` | 検索 |
| `r` | 履歴を更新 |
| `Shift+r` | 検索インデックスを再構築 |
| `Ctrl+r` | 設定を再読み込み |
| `Shift+s` | 履歴ソースを切り替える |
| `a` | アーカイブを切り替える |
| `Tab` | フォーカスを移動 |

`s`は本文で次のturnへ移動するため、履歴ソースの切り替えには`Shift+s`を使う。
検索欄ではEnterで確定、Escでキャンセルし、o24入力の`Ctrl+u`で検索文字列を
クリアする。

キーバインドを変更した時点で起動しているcodex-historyは、変更前のキーを
保持している。新しい設定へ確実に切り替えるには`Ctrl+c`で終了して起動し直す。
変更後はo24入力の`Ctrl+r`で再読み込みできる。

Karabiner側のo24配列を変更した場合は、`config.toml`とこの対応表を同時に更新する。
