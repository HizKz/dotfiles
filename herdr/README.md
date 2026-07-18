# Herdr運用ガイド

この環境では、WezTermを端末エミュレーター、Herdrを日常のワークスペース、
タブ、ペイン管理に使用します。WezTermを起動すると、Home Managerで導入した
`~/.nix-profile/bin/herdr`が自動的に起動し、デフォルトセッションへ接続します。

## WezTermとの役割分担

| 階層 | 用途 | 例 |
| --- | --- | --- |
| WezTermのウィンドウ | ローカル環境や別マシンなど大きな実行環境の境界 | ローカル、SSH先 |
| WezTermのタブ | Herdrの復旧、一時的な素のシェル | ログインzsh |
| HerdrのWorkspace | プロジェクト単位 | `dotfiles`、`api`、`frontend` |
| HerdrのTab | 作業目的 | `agent`、`server`、`tests` |
| HerdrのPane | 個別プロセス | Codex、開発サーバー、テスト監視 |

通常の作業ではWezTermのタブを増やさず、HerdrのWorkspace、Tab、Paneを
使用します。`Ctrl+t`または`Cmd+t`は、Herdr外で確認や復旧を行うための
ログインzshを新しいWezTermタブで開きます。

## 起動と復旧

WezTermを通常どおり起動するとHerdrが開きます。シェルから明示的に接続する
場合は次を実行します。

```sh
herdr
```

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

作業を残してWezTermを閉じる場合は、`Ctrl+b` → `q`でHerdrクライアントを
デタッチします。Pane内のAgent、サーバー、テストはバックグラウンドで
動作し続けます。再度WezTermを開くか、シェルから`herdr`を実行すると、
同じセッションへ戻ります。

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
