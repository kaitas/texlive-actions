# TeX Live GitHub Actions プロジェクト

このプロジェクトは、GitHub Actionsを使用してTeX Live 2024相当の環境でTeXドキュメントをビルドし、結果をSlackに通知するワークフローを提供します。

## 機能

- GitHub Actionsを使用したTeX Live 2024環境の自動セットアップ
- Dockerを使用した一貫性のある環境構築
- ビルドレイヤーのキャッシングによる高速化
- `ptex2pdf`を使用したTeXドキュメントのビルド
- ビルド結果のPDFアーティファクトのアップロード
- Slackへのビルド結果の自動通知（日本語）
- サンプルとして[芸術科学会 NICOGRAPH の TeXサンプルファイル](https://art-science.org/nicograph/#format)を使用しています。御礼申し上げます。

## セットアップ

1. このリポジトリをクローンまたはフォークします。Publicにする必要はありません。

2. `.github/workflows/texlive-build.yml`ファイルをプロジェクトのルートディレクトリに配置します。

3. プロジェクトのルートディレクトリに以下の内容の`Dockerfile`を作成します：

   ```dockerfile
FROM debian:bullseye-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    texlive-base \
    texlive-lang-japanese \
    texlive-latex-extra \
    texlive-fonts-recommended \
    xdvik-ja \
    dvipsk-ja \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workdir

CMD ["/bin/bash"]
   ```
この Dockerfile は日本語サポートを含む基本的な TeX Live 環境を設定します。

4. GitHubリポジトリの設定で、`SLACK_WEBHOOK`という名前のSecretを作成し、SlackのWebhook URLを値として設定します（詳細は次のセクションで解説）。

5. Slackで着信Webhookを設定し、そのURLを上記のSecretとして保存します。

## 使用方法

1. TeXファイル（デフォルトでは`conference_samp.tex`）をプロジェクトのルートディレクトリに配置します。

2. 変更をコミットし、`main`ブランチにプッシュします。

3. GitHub Actionsが自動的にワークフローを実行し、TeXドキュメントをビルドします。

4. ビルド結果（成功または失敗）がSlackに通知されます。

5. ビルドが成功した場合、生成されたPDFがGitHub Actionsのアーティファクトとして保存されます。

## カスタマイズ

- `.github/workflows/texlive-build.yml`ファイル内の`conference_samp.tex`を、実際のTeXファイル名に変更してください。

- 必要に応じて、`Dockerfile`に追加のパッケージやツールをインストールできます。

- Slack通知のフォーマットやコンテンツは、ワークフローファイル内の`Notify Slack`ステップで調整できます。

## 注意事項

- 初回のDockerイメージビルドには時間がかかる場合があります。だいたい10分ぐらい。

- キャッシュのサイズが大きくなる可能性があるため、定期的にGitHub Actionsのキャッシュをクリアすることを検討してください。

- このワークフローは`main`ブランチへのプッシュでのみ実行されます。他のブランチやイベントでも実行したい場合は、ワークフローファイルの`on`セクションを適宜修正してください。

## サポート

問題や質問がある場合は、GitHubのIssueを開いてください。



## GitHubでのSLACK_WEBHOOK Secretの設定

1. GitHubで対象のリポジトリを開きます。

2. リポジトリのメインページで、上部の「Settings」タブをクリックします。

3. 左側のサイドバーで、「Secrets and variables」を展開し、「Actions」をクリックします。

4. 「Repository secrets」セクションで、「New repository secret」ボタンをクリックします。

5. 以下の情報を入力します：
   - Name: `SLACK_WEBHOOK`（大文字小文字を正確に入力してください）
   - Value: Slackから取得したWebhook URL（例：https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX）

6. 「Add secret」ボタンをクリックして保存します。

これで`SLACK_WEBHOOK`シークレットが設定され、GitHub Actionsワークフローで安全に使用できるようになります。

注意：
- Secretの値はGitHubの管理者やリポジトリの所有者でも表示できません。設定後は値を確認できないので、入力時に正確に入力されていることを確認してください。
- Secretを更新する場合は、同じ手順で新しい値を入力します。
- リポジトリのSecretは、フォークされたリポジトリには引き継がれません。フォークしたリポジトリで使用する場合は、別途設定が必要です。

### Slackでの着信Webhookの設定

1. Slackで通知を受け取るワークスペースにログインします。

2. Slack APIのウェブサイト（https://api.slack.com/apps）にアクセスします。

3. 「Create New App」をクリックし、「From scratch」を選択します。

4. アプリ名とワークスペースを選択して、アプリを作成します。

5. 左側のサイドバーで「Incoming Webhooks」をクリックします。

6. 「Activate Incoming Webhooks」を「On」に切り替えます。

7. ページ下部の「Add New Webhook to Workspace」をクリックします。

8. 通知を送信するチャンネルを選択し、「許可する」をクリックします。

9. 生成されたWebhook URLをコピーします。これが、GitHubのSLACK_WEBHOOK Secretに設定する値です。

注意：
- Webhook URLは機密情報です。安全に管理し、公開リポジトリにコミットしないよう注意してください。
- 必要に応じて、Slackアプリの設定でアイコンや名前をカスタマイズできます。

これらの手順を完了すると、GitHub ActionsからSlackへの通知が設定されます。ワークフローが実行されるたびに、設定したSlackチャンネルに通知が送信されます。
