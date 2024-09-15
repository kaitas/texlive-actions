# TeX Live GitHub Actions プロジェクト

このプロジェクトは、GitHub Actionsを使用してTeX Live環境でTeXドキュメントをビルドし、結果をSlackとDiscordに通知するワークフローを提供します。英語と日本語の文書作成に特化しています。

## 機能

- GitHub Actionsを使用したTeX Live環境の自動セットアップ
- Dockerを使用した一貫性のある環境構築
- GitHub Container Registryを利用したDockerイメージのキャッシング
- `ptex2pdf`を使用したTeXドキュメントのビルド
- ビルド結果のPDFアーティファクトのアップロード
- SlackとDiscordへのビルド結果の自動通知（日本語）
- サンプルとして[芸術科学会 NICOGRAPH の TeXサンプルファイル](https://art-science.org/nicograph/#format)を使用しています。御礼申し上げます。

## セットアップ

![image](https://github.com/user-attachments/assets/9e416889-ab13-45ec-ba5a-ccf0371a2f55)


1. このリポジトリをクローンまたはフォークします。よくわからないひとは右上の「Template」で一発です。プライベートリポジトリでも構いません。

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

5. GitHubリポジトリの設定で、以下のシークレットを作成します：
   - `SLACK_WEBHOOK`: SlackのWebhook URL
   - `DISCORD_WEBHOOK`: DiscordのWebhook URL

6. SlackとDiscordで着信Webhookを設定し、それぞれのURLを上記のシークレットとして保存します。

## 使用方法

1. TeXファイル（デフォルトでは`conference_samp.tex`）をプロジェクトのルートディレクトリに配置します。

2. 初回セットアップ時は、GitHub Actionsタブから手動でワークフローを実行します（`workflow_dispatch`イベント）。

3. その後は、変更をコミットし`main`ブランチにプッシュすると、GitHub Actionsが自動的にワークフローを実行し、TeXドキュメントをビルドします。

4. ビルド結果（成功または失敗）がSlackとDiscordに通知されます。

5. ビルドが成功した場合、生成されたPDFがGitHub Actionsのアーティファクトとして保存されます。

## カスタマイズ

- `.github/workflows/texlive-build.yml`ファイル内の`conference_samp.tex`を、実際のTeXファイル名に変更してください。

- 必要に応じて、`Dockerfile`に追加のパッケージやツールをインストールできます。

- Slack通知とDiscord通知のフォーマットやコンテンツは、ワークフローファイル内の`Notify Slack and Discord`ステップで調整できます。

## 注意事項

- 初回のDockerイメージビルドには時間がかかる場合があります（約10分程度）。

- このワークフローは`main`ブランチへのプッシュと手動実行（`workflow_dispatch`）でのみ実行されます。他のブランチやイベントでも実行したい場合は、ワークフローファイルの`on`セクションを適宜修正してください。

- GitHub Container Registryを使用しているため、リポジトリに適切な権限設定が必要です。

- Slack通知とDiscord通知に関して:
  - `SLACK_WEBHOOK`または`DISCORD_WEBHOOK`が設定されていない場合、その旨がログに記録されます。
  - 通知の送信が成功しなかった場合（HTTPステータスコードが期待値以外の場合）、エラー内容がログに記録されます。

- GitHub Container Registry (ghcr.io) へのログインに失敗した場合（CR_PATの有効期限切れなど）、SlackとDiscordに通知が送信されます。通知を受け取った場合は、[GitHub Personal Access Token (PAT)](https://github.com/settings/tokens) の状態を確認し、必要に応じて更新してください。

## トラブルシューティング

- ビルドに失敗した場合、ワークフローのログを確認して詳細なエラー情報を取得できます。

- Dockerイメージのビルドに問題がある場合は、ローカル環境でDockerfileをテストしてみてください。

- GitHub Container Registryへのプッシュに失敗する場合は、PAT（Personal Access Token）の権限を確認してください。

- Slack通知やDiscord通知に問題がある場合は、それぞれのWebhook URLが正しく設定されているか確認してください。

## サポート

問題や質問がある場合は、GitHubのIssueを開いてください。

## FAQ

Q: 画像を追加したい
A: /figにPNGファイルを置いて以下のように記述してください
```latex
\begin{figure}[H]
 \centering
 \includegraphics[width=40truemm]{fig-sample.png}
 \caption{\small{図の挿入例．}}
 \label{fig:sample}
\end{figure}
```

Q: ターゲットにするTeXファイルを変更したい
A: `.github/workflows/texlive-build.yml`ファイル内の`Build TeX document`ステップを編集してください。`ptex2pdf`コマンドの引数にある`conference_samp.tex`を、ビルドしたいTeXファイルの名前に変更します。例えば：

```yaml
- name: Build TeX document
  run: |
    docker run --rm -v ${{ github.workspace }}:/workdir texlive:latest \
      ptex2pdf your-file-name.tex -l -ot -kanji=utf8
```

Q: 生成されるPDFの名前を変えたい
A: PDFの名前は通常、入力するTeXファイルの名前に基づいて自動的に生成されます。しかし、生成後にPDFの名前を変更することができます。`.github/workflows/texlive-build.yml`ファイル内の`Upload PDF artifact`ステップの前に、以下のようなステップを追加してPDFの名前を変更できます：

```yaml
- name: Rename PDF
  run: mv conference_samp.pdf your-desired-name.pdf

- name: Upload PDF artifact
  uses: actions/upload-artifact@v4
  with:
    name: PDF
    path: your-desired-name.pdf
```

``name: PDF`` の「PDF」を変えると、生成されるZIPファイル名を変えられます。


Q: エラーが出た
A: Actionsのログを見てChatGPTやClaudeに訊いてみることをおすすめします。
TeX原稿に起因する多くあるエラーは以下のようなものです。

- アンダースコア：「_」はアンダースコアはTeXで下付き文字を表すために使用されます。通常のテキストとして使用するには、バックスラッシュでエスケープする、\textunderscore コマンドを使用する、verbatim環境を使用する（コードブロックなどで）

- 丸数字などUnicode関係：\usepackage{pifont} で解決

> ワークショップの設計は、\ding{172}スマートフォンの操作能力確認、\ding{173}アバター制作体験、\ding{174}ポーズや表情の表現、\ding{175}タブレットを利用したペイントソフトとデジタルペイント体験、\ding{176}レイヤーによる合成、\ding{177}文字の入力、\ding{178}記念写真撮影を通した表情確認となっている。

- XeLaTeXやLuaLaTeXを使用することで、Unicode文字を直接扱えるようにする
1. ドキュメントのプリアンブルを以下のように変更します：

```latex
\documentclass[uplatex,dvipdfmx]{jsarticle}
\usepackage{xltxtra}
\usepackage{zxjatype}
\setjamainfont{IPAExMincho}
\setjasansfont{IPAExGothic}
```

2. ファイルの冒頭に以下のコメントを追加して、エンコーディングを明示的に指定します：

```latex
% !TEX encoding = UTF-8 Unicode
% !TEX program = xelatex
```

3. 本文中では、Unicode文字（丸数字）をそのまま使用できます：

```latex
ワークショップの設計は第2回が、⑧漫画の作り方解説、⑨...
```

4. ビルド時に、`xelatex`コマンドを使用してコンパイルします：

```
xelatex your_file.tex
```

GitHub Actionsのワークフローファイル（`.github/workflows/texlive-build.yml`）も、XeLaTeXを使用するように更新する必要があります。以下のように変更してください：

```yaml
- name: Build TeX document
  run: |
    docker run --rm -v ${{ github.workspace }}:/workdir texlive:latest \
      xelatex -interaction=nonstopmode -halt-on-error your_file.tex
```

この方法を使用することで、以下のメリットがあります：

1. Unicode文字（丸数字を含む）を直接使用できる
2. 追加のパッケージが不要
3. 日本語フォントの柔軟な指定が可能

ただし、注意点として：

1. XeLaTeXの使用にはTeX Live環境の更新が必要な場合がある
2. ビルド時間が若干長くなる可能性がある

これらの変更を適用することで、Unicode文字によるエラーを回避し、より柔軟なTeX環境を構築できます。
