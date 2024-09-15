# TeX Live GitHub Actions プロジェクト

このプロジェクトは、GitHub Actionsを使用してTeX Live 2024相当の環境でTeXドキュメントをビルドし、結果をSlackに通知するワークフローを提供します。

## 機能

- GitHub Actionsを使用したTeX Live 2024環境の自動セットアップ
- Dockerを使用した一貫性のある環境構築
- ビルドレイヤーのキャッシングによる高速化
- `ptex2pdf`を使用したTeXドキュメントのビルド
- ビルド結果のPDFアーティファクトのアップロード
- Slackへのビルド結果の自動通知（日本語）

## セットアップ

1. このリポジトリをクローンまたはフォークします。

2. `.github/workflows/texlive-build.yml`ファイルをプロジェクトのルートディレクトリに配置します。

3. プロジェクトのルートディレクトリに以下の内容の`Dockerfile`を作成します：

   ```dockerfile
   FROM ubuntu:latest

   RUN apt-get update && \
       apt-get install -y \
       texlive-full \
       && rm -rf /var/lib/apt/lists/*

   RUN tlmgr update --self && \
       tlmgr update --all

   WORKDIR /workdir

   CMD ["/bin/bash"]
   ```

4. GitHubリポジトリの設定で、`SLACK_WEBHOOK`という名前のSecretを作成し、SlackのWebhook URLを値として設定します。

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

- 初回のDockerイメージビルドには時間がかかる場合があります。

- キャッシュのサイズが大きくなる可能性があるため、定期的にGitHub Actionsのキャッシュをクリアすることを検討してください。

- このワークフローは`main`ブランチへのプッシュでのみ実行されます。他のブランチやイベントでも実行したい場合は、ワークフローファイルの`on`セクションを適宜修正してください。

## サポート

問題や質問がある場合は、GitHubのIssueを開いてください。
