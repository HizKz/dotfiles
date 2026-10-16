# Herdr運用ガイド

この環境では、普段の作業にWezTermのタブ、ペインとログインzshを使用します。
セッションを残したい作業では、Home Managerで導入したHerdrをシェルから
`herdr`で起動し、デフォルトセッションへ接続します。

## WezTermとの役割分担

| 階層 | 用途 | 例 |
| --- | --- | --- |
| WezTermのウィンドウ | ローカル環境や別マシンなど大きな実行環境の境界 | ローカル、SSH先 |
| WezTermのタブ・ペイン | 普段の作業、必要に応じたHerdrへの接続 | ログインzsh、`herdr` |
| HerdrのWorkspace | プロジェクト単位 | `dotfiles`、`api`、`frontend` |
| HerdrのTab | 作業目的 | `agent`、`server`、`tests` |
| HerdrのPane | 個別プロセス | Codex、開発サーバー、テスト監視 |

通常の作業ではWezTermのタブ、ペインを使用します。`Ctrl+t`または`Cmd+t`は、
ログインzshを新しいWezTermタブで開きます。Herdrへ接続した場合は、その中の
Workspace、Tab、Paneを`Ctrl+b`から操作します。

## 起動と復旧

WezTermを起動するとログインzshが開きます。Herdrを使う場合は、シェルから
次を実行します。

```sh
herdr
```

ghq管理リポジトリをHerdrのWorkspaceで開く`wproj`は、起動済みのHerdrサーバーが
必要です。初回は`herdr`を起動し、`Ctrl+b` → `q`でシェルへ戻ってから`wproj`を
実行します。普段のシェルでリポジトリへ移動する場合は`cproj`を使用します。

Herdrが起動できない場合は、`Ctrl+t`または`Cmd+t`で素のzshを開き、
インストール先と設定を確認します。WezTermの外から復旧用ウィンドウを
直接起動する場合は次を使用します。

```sh
wezterm start -- /bin/zsh -l
```

Herdrの実体がない場合は、dotfilesのルートでHome Managerを反映します。

```sh
home-manager switch --flake .#apple
```

## Prefix key

Herdrの操作は、`Ctrl+b`を押して離してから操作キーを押します。たとえば
`Ctrl+b` → `c`は、`Ctrl+b`と`c`を同時に押す操作ではありません。

現在のキーバインド一覧は`Ctrl+b` → `?`で確認できます。

## 基本操作

### Workspace

| キー | 動作 |
| --- | --- |
| `Ctrl+b` → `↑` / `↓` | 前後のWorkspaceへ移動する |
| `Ctrl+b` → `w` | Workspace一覧を開く |
| `Ctrl+b` → `Shift+n` | Workspaceを作成する |
| `Ctrl+b` → `Shift+w` | Workspace名を変更する |
| `Ctrl+b` → `Shift+d` | Workspaceを閉じる |
| `Ctrl+b` → `g` | Workspace、Tab、Paneの移動先を検索する |

1つのリポジトリにつき1つのWorkspaceを作成し、その中を用途別のTabに
分けるのを基本とします。完全に独立したサーバーや状態が必要な場合だけ、
Named Sessionを使用します。

### Tab

| キー | 動作 |
| --- | --- |
| `Ctrl+b` → `c` | Tabを作成する |
| `Ctrl+b` → `←` / `→` | 前後のTabへ移動する |
| `Ctrl+b` → `1`〜`9` | 番号を指定してTabへ移動する |
| `Ctrl+b` → `Shift+t` | Tab名を変更する |
| `Ctrl+b` → `Shift+x` | Tabを閉じる |

`Cmd+1`〜`9`や`Ctrl+Tab`は外側のWezTermタブを移動します。Herdr内のTabを
移動するときは、必ず`Ctrl+b`から操作します。

### Agent

Agent一覧は注意が必要な状態を優先する`priority`順で表示します。
各Agentの1行目に状態アイコン、Agent名、状態名を、2行目にWorkspace、Tab、
Pane名を表示します。分割Paneの枠にも、手動のPane名がない場合はAgent名を
表示します。

| 状態 | 意味 |
| --- | --- |
| `blocked` | 承認や回答など、ユーザーの入力を待っている |
| `working` | Agentが作業中 |
| `done` | 作業完了をまだ確認していない |
| `idle` | 完了を確認済みで、次の入力を待っている |
| `unknown` | 通常のシェルなど、Agentの状態を判定できない |

バックグラウンドのAgentが完了したり入力待ちになったりすると、1秒の遅延後に
Herdr内の右下へ通知を表示します。通知音は無効です。この設定はHerdr内の通知で、
Herdrをデタッチしている間や別アプリを見ている間のデスクトップ通知は行いません。

| キー | 動作 |
| --- | --- |
| `Ctrl+b` → `Shift+1`〜`9` | 番号を指定してAgentへ移動する |
| `Ctrl+b` → `o` | 通知の対象へ移動する |

### Pane

この設定では、ペイン移動に`k/t/n/s = 左/下/上/右`を使用します。

| キー | 動作 |
| --- | --- |
| `Ctrl+b` → `v` | 右へ分割する |
| `Ctrl+b` → `-` | 下へ分割する |
| `Ctrl+b` → `k/t/n/s` | 左/下/上/右のPaneへ移動する |
| `Ctrl+b` → `z` | 現在のPaneをズーム、または元に戻す |
| `Ctrl+b` → `r` | Paneのリサイズモードに入る |
| `Ctrl+b` → `x` | Paneを閉じる |

## マウスとコピー

- Pane、Tab、Workspace、Agentはクリックしてフォーカスできます。
- 境界をドラッグするとPaneのサイズを変更できます。
- 通常のドラッグ選択はHerdrがクリップボードへコピーします。
- `Shift`を押しながらドラッグすると、WezTerm側でテキストを選択できます。
- `Ctrl+b` → `[`でHerdrのCopy Modeを開き、履歴をキーボードで移動できます。

## デタッチと終了

`Ctrl+b` → `q`でHerdrクライアントをデタッチすると、起動元のシェルへ戻ります。
Pane内のAgent、サーバー、テストはバックグラウンドで動作し続けるため、
その後WezTermを閉じても作業は残ります。再接続する場合は、WezTermのシェルから
`herdr`を実行すると、同じセッションへ戻ります。

デタッチや端末を閉じる操作と、PCのスリープ・再起動は別です。ローカルPCが
スリープしている間は処理が進まず、PCやHerdrサーバーを再起動すると元の
プロセスは終了します。再起動後は保存済みのレイアウトを復元し、対応するAgentの
会話復元には後述のintegrationが必要です。

セッションとPane内プロセスをすべて終了する場合だけ、次を実行します。

```sh
herdr server stop
```

このコマンドはAgentや開発サーバーも終了するため、通常の退出には使用しません。

## 設定とCodex integration

Herdrの設定は[`config.toml`](config.toml)で管理し、`setup.sh`によって
`~/.config/herdr/config.toml`へリンクします。変更を実行中のセッションへ
反映するには次を実行します。

```sh
herdr server reload-config
```

現在の設定はHerdr `0.7.4`の`herdr --default-config`と`herdr config check`で
確認しています。`herdr --help`が表示する読込先も上記のリンク先と一致します。
サイドバーなどクライアント側の表示が切り替わらない場合は、`Ctrl+b` → `q`で
デタッチし、`herdr`で再接続します。設定の検証は次を実行します。

```sh
herdr config check
```

`spotify_player`などの画像対応TUIをHerdr内で使用できるよう、実験的な
Kitty graphics描画を有効にしています。`spotify_player`はHerdr上のWezTermを
検出するとKitty graphicsを明示的に選択します。設定変更後はHerdrクライアントと
対象TUIを起動し直します。カバー画像の縦横比は、spotify-player側で
`cover_img_length = 0`として端末セル比率から自動計算します。正方形の画像を
正確に表示する場合は、`Ctrl+t`または`Cmd+t`で素のWezTermタブを開き、Herdrを
介さず`spotify_player`を起動します。

Codexのセッション識別情報をHerdrへ連携し、サーバー再起動後の会話復元を
利用する場合はintegrationをインストールします。

```sh
herdr integration install codex
herdr integration status
```

Agentの検出や状態表示を確認する場合は次を使用します。

```sh
herdr agent list
```

## 参考資料

- [参考記事: 「Herdr」を使い始めたら、もう他のターミナルには戻れなくなった](https://zenn.dev/dragon1208/articles/45708cc45a7a7c)
- [公式設定ガイド](https://herdr.dev/docs/configuration/)
- [公式セッション復元ガイド](https://herdr.dev/docs/session-state/)

記事で紹介されているエージェント操作用Skillは、状態表示や通知の前提では
ありません。Codex integrationも別の機能で、会話の識別・復元情報を連携します。
