# WezTerm Keybinds

このリポジトリの WezTerm 設定で使っているキーバインド一覧です。

`disable_default_key_bindings = true` になっているため、ここに書かれているものが実際の操作の基準になります。

## Leader Key

- `Ctrl+b` : Leader キー
- `Ctrl+b` → `v` : ペインを左右に分割
- `Ctrl+b` → `h` : ペインを上下に分割
- `Ctrl+b` → `m` : 背景透明度を切り替え

## タブ操作

| キー | 動作 |
| --- | --- |
| `Ctrl+t` / `Cmd+t` | 新しいタブを開く |
| `Ctrl+w` / `Cmd+w` | 現在のタブを閉じる |
| `Ctrl+Tab` | 次のタブへ移動 |
| `Ctrl+Shift+Tab` | 前のタブへ移動 |
| `Ctrl+PageDown` | 次のタブへ移動 |
| `Ctrl+PageUp` | 前のタブへ移動 |
| `Ctrl+Shift+PageDown` | タブを右へ移動 |
| `Ctrl+Shift+PageUp` | タブを左へ移動 |
| `Cmd+1` - `Cmd+8` | 1-8 番目のタブへ移動 |
| `Cmd+9` | 最後のタブへ移動 |
| `Ctrl+Shift+1` - `Ctrl+Shift+8` | 1-8 番目のタブへ移動 |
| `Ctrl+Shift+9` | 最後のタブへ移動 |
| `Cmd+{` / `Cmd+}` | 前後のタブへ移動 |

## ペイン操作

| キー | 動作 |
| --- | --- |
| `Ctrl+Alt+"` | ペインを上下に分割 |
| `Ctrl+Alt+Shift+5` | ペインを左右に分割 |
| `Alt+←` `Alt+→` `Alt+↑` `Alt+↓` | 隣のペインへ移動 |
| `Ctrl+Alt+Shift+←` `→` `↑` `↓` | ペインサイズを調整 |
| `Ctrl+z` | ペインをズーム |

## コピー・検索

| キー | 動作 |
| --- | --- |
| `Ctrl+c` / `Cmd+c` | コピー |
| `Ctrl+v` / `Cmd+v` | ペースト |
| `Ctrl+f` / `Cmd+f` | 検索 |
| `Ctrl+x` | Copy Mode を開始 |
| `Ctrl+Shift+Space` | Quick Select |
| `Ctrl+u` | Char Select |
| `Ctrl+k` / `Cmd+k` | スクロールバックをクリア |

## 表示・ウィンドウ

| キー | 動作 |
| --- | --- |
| `Alt+Enter` | フルスクリーン切り替え |
| `Ctrl+=` / `Cmd+=` | フォントサイズを拡大 |
| `Ctrl+-` / `Cmd+-` | フォントサイズを縮小 |
| `Ctrl+0` / `Cmd+0` | フォントサイズをリセット |
| `Ctrl+r` / `Cmd+r` | 設定を再読み込み |
| `Ctrl+p` | コマンドパレットを開く |
| `Ctrl+n` / `Cmd+n` | 新しいウィンドウを開く |
| `Ctrl+m` / `Cmd+m` | ウィンドウを隠す |
| `Ctrl+h` / `Cmd+h` | アプリを隠す |
| `Ctrl+q` / `Cmd+q` | WezTerm を終了 |
| `Ctrl+l` | デバッグオーバーレイを表示 |

## スクロール

| キー | 動作 |
| --- | --- |
| `Shift+PageUp` | 1 ページ上へスクロール |
| `Shift+PageDown` | 1 ページ下へスクロール |

## Copy Mode

`Ctrl+x` で Copy Mode に入ります。

| キー | 動作 |
| --- | --- |
| `h` `j` `k` `l` | 左下上右に移動 |
| `w` / `b` / `e` | 単語単位で移動 |
| `0` / `^` / `$` | 行頭 / 文字先頭 / 行末へ移動 |
| `g` / `G` | スクロールバック先頭 / 末尾へ移動 |
| `H` / `M` / `L` | 表示領域の上 / 中央 / 下へ移動 |
| `v` | セル選択 |
| `Ctrl+v` | 矩形選択 |
| `V` | 行選択 |
| `o` / `O` | 選択端の移動 |
| `f` / `F` / `t` / `T` | 文字検索ジャンプ |
| `;` / `,` | 直前ジャンプの反復 / 逆反復 |
| `Ctrl+d` / `Ctrl+u` | 半ページ下 / 上へ移動 |
| `Ctrl+f` / `Ctrl+b` | 1 ページ下 / 上へ移動 |
| `PageDown` / `PageUp` | 1 ページ下 / 上へ移動 |
| `y` | コピーして終了 |
| `q` / `Esc` / `Ctrl+c` | 終了 |

## Search Mode

検索中の主な操作です。

| キー | 動作 |
| --- | --- |
| `Ctrl+n` | 次の一致へ |
| `Ctrl+p` | 前の一致へ |
| `Ctrl+r` | マッチ種別を切り替え |
| `Ctrl+u` | 検索文字列をクリア |
| `PageDown` / `Down` | 次の一致へ |
| `PageUp` / `Up` | 前の一致へ |
| `Esc` | 検索を終了 |

## 設定ファイル

- [wezterm.lua](/Users/apple/.config/wezterm/wezterm.lua)
- [keybinds.lua](/Users/apple/.config/wezterm/keybinds.lua)
