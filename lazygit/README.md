# Lazygitキーバインド

Karabiner-Elementsの`o24`プロファイルを前提に、Lazygitを物理キー基準で
操作するための設定です。設定本体は[`config.yml`](config.yml)にあり、
`setup.sh`がmacOSの設定パスへシンボリックリンクを作成します。

```text
~/Library/Application Support/lazygit/config.yml
  -> <repository>/lazygit/config.yml
```

## 仕組み

Lazygitが受け取るのは、物理キーではなくKarabinerによる変換後の文字です。
たとえば物理`n`は`g`として届くため、上移動の設定値は`g`になります。
Lazygitの画面下部や`?`のヘルプにも変換後の文字が表示されます。このREADMEでは、
実際に押すキーが分かるように物理キーで表記します。

設定は現在の`o24`プロファイルを固定して反映しています。Karabiner側の配列を
変更した場合、`config.yml`とこのREADMEを同時に更新します。

## 基本操作

| 物理キー | Karabiner出力 | Lazygitの操作 |
| --- | --- | --- |
| `n` | `g` | 上へ移動 |
| `t` | `.` | 下へ移動 |
| `k` | `n` | 左のパネル、前のhunkへ移動 |
| `s` | `i` | 右のパネル、次のhunkへ移動 |
| `h` | `k` | 一覧を開く、メニュー項目を決定 |
| `Space` | `Space` | 選択、stage・unstage |
| `Esc` | `Esc` | 戻る、キャンセル |
| `1`〜`5` | `1`〜`5` | 対応するサイドパネルへ移動 |
| `0` | `0` | メインビューへ移動 |

矢印、Tab、EnterもLazygitの既定どおり使用できます。文字入力や確認ダイアログでは
物理`h`を文字`k`として入力できるよう、確定キーをEnterのままにしています。

KarabinerのSpaceレイヤーも併用できます。

| 操作 | 動作 |
| --- | --- |
| `Space+n/t/k/s` | 上・下・左・右 |
| `Space+h` | Enter |
| `Space+v/c/x/o/a/i/,/u/l/.` | `1`〜`0` |

## 主なGit操作

通常のLazygit操作は、o24変換後も既定と同じ物理キーで使えるようにしています。

| 物理キー | 操作 |
| --- | --- |
| `c` | commit |
| `Shift+c` | エディタでcommit |
| `a` | 全ファイルのstage・unstage |
| `p` / `Shift+p` | pull / push |
| `f` | fetch |
| `e` / `o` | edit / open |
| `r` | refresh、画面に応じたrename・rebase |
| `d` | remove |
| `q` | 終了 |
| `?` | キーバインドヘルプ |

移動キーと重なる既存操作はRight Optionとの組み合わせに退避しています。
左OptionはKarabinerでCommandへ変換されるため使用しません。

| 物理キー | Lazygit入力 | 操作 |
| --- | --- | --- |
| `Right Option+n` | `<alt+g>` | new、検索中の次の一致 |
| `Right Option+t` | `<alt+.>` | commitのrevert |
| `Right Option+s` | `<alt+i>` | stash、squash、sort order |

Ctrl、Option、Command付きの既存キーバインドは、上記3つを除いてLazygitの
既定値を変更していません。

## o24変換表

`config.yml`を変更するときは、設定したい物理キーを次の出力へ変換して記述します。
Shift付きは同じ変換後のキーへShiftを適用します。

| 物理 | 出力 | 物理 | 出力 | 物理 | 出力 |
| --- | --- | --- | --- | --- | --- |
| `a` | `e` | `b` | `;` | `,` | `m` |
| `d` | `a` | `e` | `u` | `f` | `o` |
| `g` | `-` | `h` | `k` | `-` | `/` |
| `i` | `r` | `j` | `t` | `k` | `n` |
| `l` | `s` | `m` | `d` | `n` | `g` |
| `o` | `y` | `.` | `j` | `r` | `,` |
| `s` | `i` | `;` | `h` | `/` | `b` |
| `t` | `.` | `u` | `w` | `w` | `l` |
| `y` | `f` | そのほか | 変更なし | — | — |

## 反映確認

設定ファイルのリンクを確認します。

```sh
lazygit --print-config-dir
readlink "$HOME/Library/Application Support/lazygit/config.yml"
```

リンク先の設定を読み込ませるには、リポジトリ内でLazygitを起動します。設定に
問題がある場合は起動時にエラーが表示されます。

```sh
lazygit
```

`lazygit --config`は現在のカスタム設定ではなく、既定設定の参照用出力です。

リンクがない場合はリポジトリルートでセットアップを再実行します。

```sh
./setup.sh --dry-run
./setup.sh
```

変更後はLazygitを起動し直します。画面のキー表示が分かりにくい場合は`?`を開き、
表示された変換後のキーをこのREADMEの変換表で物理キーへ戻して確認します。
