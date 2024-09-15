# TeX Live GitHub Actions プロジェクト

このプロジェクトは、GitHub Actionsを使用してTeX Live環境でTeXドキュメントをビルドし、結果をSlackに通知するワークフローを提供します。英語と日本語の文書作成に特化しています。

## 機能

- GitHub Actionsを使用したTeX Live環境の自動セットアップ
- Dockerを使用した一貫性のある環境構築
- GitHub Container Registryを利用したDockerイメージのキャッシング
- `ptex2pdf`を使用したTeXドキュメントのビルド
- ビルド結果のPDFアーティファクトのアップロード
- Slackへのビルド結果の自動通知（日本語）
- サンプルとして[芸術科学会 NICOGRAPH の TeXサンプルファイル](https://art-science.org/nicograph/#format)を使用しています。御礼申し上げます。

## セットアップ

1. このリポジトリをクローンまたはフォークします。プライベートリポジトリでも構いません。

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
    texlive-binaries \
    xdvik-ja \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workdir

CMD ["/bin/bash"]
   ```

4. GitHub Personal Access Token (PAT) を作成し、リポジトリのシークレットとして `CR_PAT` という名前で設定します。

5. GitHubリポジトリの設定で、`SLACK_WEBHOOK`という名前のシークレットを作成し、SlackのWebhook URLを値として設定します。

6. Slackで着信Webhookを設定し、そのURLを上記のシークレットとして保存します。

## 使用方法

1. TeXファイル（デフォルトでは`conference_samp.tex`）をプロジェクトのルートディレクトリに配置します。

2. 初回セットアップ時は、GitHub Actionsタブから手動でワークフローを実行します（`workflow_dispatch`イベント）。

3. その後は、変更をコミットし`main`ブランチにプッシュすると、GitHub Actionsが自動的にワークフローを実行し、TeXドキュメントをビルドします。

4. ビルド結果（成功または失敗）がSlackに通知されます。

5. ビルドが成功した場合、生成されたPDFがGitHub Actionsのアーティファクトとして保存されます。

## カスタマイズ

- `.github/workflows/texlive-build.yml`ファイル内の`conference_samp.tex`を、実際のTeXファイル名に変更してください。

- 必要に応じて、`Dockerfile`に追加のパッケージやツールをインストールできます。

- Slack通知のフォーマットやコンテンツは、ワークフローファイル内の`Notify Slack`ステップで調整できます。

## 注意事項

- 初回のDockerイメージビルドには時間がかかる場合があります（約10分程度）。

- このワークフローは`main`ブランチへのプッシュと手動実行（`workflow_dispatch`）でのみ実行されます。他のブランチやイベントでも実行したい場合は、ワークフローファイルの`on`セクションを適宜修正してください。

- GitHub Container Registryを使用しているため、リポジトリに適切な権限設定が必要です。

## トラブルシューティング

- ビルドに失敗した場合、ワークフローのログを確認して詳細なエラー情報を取得できます。

- Dockerイメージのビルドに問題がある場合は、ローカル環境でDockerfileをテストしてみてください。

- GitHub Container Registryへのプッシュに失敗する場合は、PAT（Personal Access Token）の権限を確認してください。

## サポート

問題や質問がある場合は、GitHubのIssueを開いてください。