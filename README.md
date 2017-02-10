# danmaq.jekyll

for danmaq.github.io

## 構成

* GitHub のリポジトリ
    * danmaq.github.io
        * master ブランチのみ
        * tag 用のブランチを作ることもあり得るかも
    * danmaq.jekyll
        * このリポジトリ。
        * branches
            * master: 本番運用用
            * dev: 開発用
            * 他トピックブランチなど
    * danmaq.articles
        * 記事用リポジトリ。
        * branches
            * master 日本語。
            * dev ドラフト。
            * en、 cn、ru の三種類用意する。

## 処理の流れ

* danmaq.articles に記事を push する
* master の更新を検知して Jenkins へ hook が飛ぶ。
* CI 用のコンテナを立てる
    * 以下コンテナでの作業。
    * danmaq.article用、github.io用、テーマ用の 3 つのボリュームを接続する。
    * 以後、push があっても CI が終わるまで hook を無視する。
        * 複数回の push があっても、最後の 1 回のみ有効とする。
* 記事を Git ボリュームへ clone する。
    * すでに clone 済みなら pull する。
    * 自動的な解決不能の競合が起きた場合、ここでは強制的にサーバ側を優先する。
* dev ブランチに切り替え、master を rebase する。
* master に切り替え、最後に CI してからの差分を取得する。
* 差分を Google 翻訳に送信して、翻訳結果を受け取る。
* 各言語のブランチへ commit → push する。
    * ここでの push で発生する hook は無視する。
* 作業コピーを Jekyll に配置する。
* ビルドを行う。
* ビルド結果を github.io に上書き、push する。
* CI 用のコンテナを削除する。
    * Jenkins の Hook 抑止解除。
        * もしキューが入っている場合、一番最後以外すべて却下する。
