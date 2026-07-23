# Lazygitキーバインド

Karabiner-Elementsの`o24`プロファイルを前提に、Karabiner変換後のo24入力文字で
操作する設定です。設定本体は[`config.yml`](config.yml)にあり、`setup.sh`が
macOSの設定パスへシンボリックリンクを作成します。

```text
~/.config/lazygit/config.yml
  -> <repository>/lazygit/config.yml
```

キーバインドを変更する前に
[`../docs/o24-keybindings.md`](../docs/o24-keybindings.md)を必ず確認してください。

## 入力の基準

Lazygitが受け取るのは、Karabinerによる変換後の文字です。QWERTYの物理位置へ
逆変換せず、o24で入力したい文字を`config.yml`へそのまま記述します。

たとえば上移動をo24入力の`n`へ割り当てる場合、設定値も`n`です。QWERTYの
物理`n`がKarabinerから出力する`g`を設定してはいけません。

## 基本操作

| o24入力 | Lazygitの操作 |
| --- | --- |
| `n` | 上へ移動 |
| `t` | 下へ移動 |
| `k` | 左のパネル、前のhunkへ移動 |
| `s` | 右のパネル、次のhunkへ移動 |
| `h` | 一覧を開く、メニュー項目を決定 |
| `,` / `.` | 前後のページへ移動 |
| `Shift+,` / `Shift+.` | 一覧の先頭、末尾へ移動 |
| `Space` | 選択、stage・unstage |
| `Esc` | 戻る、キャンセル |
| `1`〜`5` | 対応するサイドパネルへ移動 |
| `0` | メインビューへ移動 |

矢印、Tab、EnterもLazygitの既定どおり使用できます。

## 主なGit操作

移動キー以外はLazygitの既定キーバインドを継承し、o24入力文字で操作します。

| o24入力 | 操作 |
| --- | --- |
| `c` / `Shift+c` | commit / エディタでcommit |
| `a` | 全ファイルのstage・unstage |
| `p` / `Shift+p` | pull / push |
| `f` | fetch |
| `e` / `o` | edit / open |
| `r` / `Shift+r` | 画面に応じたrefresh・rename / 全体をrefresh |
| `d` | remove |
| `/` | 検索 |
| `?` | キーバインドメニュー |
| `q` | 終了 |

`n`、`t`、`s`を移動へ使うため、重なる操作はRight Optionとの組み合わせへ
移しています。左OptionはKarabinerでCommandへ変換されるため使用しません。

| o24入力 | Lazygit入力 | 操作 |
| --- | --- | --- |
| `Right Option+n` | `<alt+n>` | new、検索中の次の一致 |
| `Right Option+t` | `<alt+t>` | commitのrevert |
| `Right Option+s` | `<alt+s>` | stash、squash、sort order |

## 反映確認

設定ファイルのリンクを確認します。

```sh
lazygit --print-config-dir
readlink "$HOME/.config/lazygit/config.yml"
```

変更後はLazygitを起動し直し、o24入力の`n/t/k/s`と矢印の両方を確認します。
画面の`?`で表示されるキーも、QWERTYの物理位置ではなくo24入力文字として
読みます。

リンクがない場合はリポジトリルートでセットアップを再実行します。

```sh
./setup.sh --dry-run
./setup.sh
```
