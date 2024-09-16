# texlive-actions

このプロジェクトは、GitHub Actionsを使用してTeX Live環境でTeXドキュメントをビルドし、結果をSlackとDiscordに通知するワークフローを提供します。英語と日本語の文書作成に特化しています。

サンプルは、芸術科学会NICOGRAPHのTeXがビルドできます。もちろん他の学会でも使えるようになります。

先生方の研究ご指導にお役立てください！

## 機能

- GitHub Actionsを使用したTeX Live環境の自動セットアップ
- Dockerを使用した一貫性のある環境構築
- GitHub Container Registryを利用したDockerイメージのキャッシング
- `uplatex`と`upbibtex`を使用したTeXドキュメントのビルド
- ビルド結果のPDFアーティファクトのアップロード
- SlackとDiscordへのビルド結果の自動通知（日本語）
- 動的なTeXファイル名の設定

## (GitHub Actionsがわかる方向けの)セットアップ

初心者向けの詳しい解説は[こちらのブログ](https://note.com/o_ob/n/n210b4d447a3d)に書いておきます。


1. このリポジトリをテンプレートとして使用し、新しいリポジトリを作成します。

2. `.github/workflows/` ディレクトリに `init.yml` と `build.yml` ファイルが配置されていることを確認します。

3. プロジェクトのルートディレクトリに `Dockerfile` が存在することを確認します。

4. 以下のGitHubシークレットを設定します：
   - `CR_PAT`: GitHub Container Registry用のPersonal Access Token
   - `SLACK_WEBHOOK`: SlackのWebhook URL（オプション）
   - `DISCORD_WEBHOOK`: DiscordのWebhook URL（オプション）
   - `TARGET_FILE`: ビルドしたいTeXファイルの名前（拡張子なし、オプション）

## 使用方法

1. TeXファイルをプロジェクトのルートディレクトリに配置します。
   - ファイル名はリポジトリ名と同じにするか、`TARGET_FILE` シークレットで指定します。

2. 初回セットアップ時：
   - GitHub Actionsタブから `Initialize TeX Live Environment` ワークフロー（`init.yml`）を手動で実行します。

3. 通常のビルド：
   - `main` ブランチにプッシュするか、GitHub Actionsタブから `Build TeX Document` ワークフロー（`build.yml`）を手動で実行します。

4. ビルド結果は自動的にSlackとDiscord（設定されている場合）に通知されます。

5. 生成されたPDFはGitHub Actionsのアーティファクトとして保存されます。

## カスタマイズ

- `TARGET_FILE` シークレットを設定することで、特定のTeXファイルをターゲットにできます。設定されていない場合、リポジトリ名がTeXファイル名として使用されます。

- `Dockerfile` を編集することで、必要なTeX関連パッケージを追加できます。

- `build.yml` 内のビルドコマンドを編集することで、異なるLaTeXエンジンやオプションを使用できます。

## 注意事項

- 初回のDockerイメージビルド（`init.yml`の実行）には時間がかかる場合があります。

- GitHub Container Registryを使用しているため、適切な権限設定が必要です。

- Slack/Discord通知は、対応するWebhook URLが設定されている場合のみ送信されます。

- `CR_PAT`（GitHub Personal Access Token）の有効期限に注意してください。期限切れの場合、通知が送信されます。

## トラブルシューティング

- ビルドエラーが発生した場合、GitHub Actionsのログを確認してください。

- TeXファイルのコンパイルエラーについては、生成されたログファイルを参照してください。

- TeXを移植する場合は、一度に大量に追加するのではなく少しづつ、確認しながら、コメントアウトしながら追加するのがコツです。だいたいアンダースコアとかアンドとかパーセントです。

- GitHub Container Registryへのアクセスに問題がある場合、`CR_PAT`の権限と有効期限を確認してください。

## FAQ

Q: 画像を追加したい
A: `/fig` ディレクトリにPNGファイルを配置し、以下のように記述します：
```latex
\begin{figure}[H]
 \centering
 \includegraphics[width=40truemm]{fig/sample.png}
 \caption{\small{図の挿入例}}
 \label{fig:sample}
\end{figure}
```
Q: ビルド対象のTeXファイルを変更したい
A: GitHubリポジトリの設定で、`TARGET_FILE` シークレットを作成し、ビルドしたいTeXファイルの名前（拡張子なし）を値として設定します。

Q: BiBTeXは使えますか？
A: もちろんです！

Q: PDFの出力ファイル名を変更したい
A: `build.yml` ファイル内の `Upload PDF artifact` ステップを編集し、`name` と `path` を希望のファイル名に変更します。

Q: Unicode文字（例：丸数字）を使用したい
A: TeXファイルのプリアンブルに `\usepackage{pifont}` を追加し、本文中で `\ding{172}` のように使用します。

## 謝辞

- サンプルとして[芸術科学会 NICOGRAPH の TeXサンプルファイル](https://art-science.org/nicograph/#format)を使用しています。御礼申し上げます。

## サポート

問題や質問がある場合は、GitHubのIssueを開いてください。
