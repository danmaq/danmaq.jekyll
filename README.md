# ./theme

Welcome to your new Jekyll theme! In this directory, you'll find the files you need to be able to package up your theme into a gem. Put your layouts in `_layouts`, your includes in `_includes` and your sass in `_sass`. To experiment with this code, add some sample content and run `bundle exec jekyll serve` – this directory is setup just like a Jekyll site!

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your Jekyll site's `Gemfile`:

```ruby
gem "./theme"
```

And add this line to your Jekyll site's `_config.yml`:

```yaml
theme: ./theme
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ./theme

## Usage

TODO: Write usage instructions here. Describe your available layouts, includes, and/or sass.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hello. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Development

To set up your environment to develop this theme, run `bundle install`.

Your theme is setup just like a normal Jekyll site! To test your theme, run `bundle exec jekyll serve` and open your browser at `http://localhost:4000`. This starts a Jekyll server using your theme. Add pages, documents, data, etc. like normal to test your theme's contents. As you make modifications to your theme and to your content, your site will regenerate and you should see the changes in the browser after a refresh, just like normal.

When your theme is released, only the files in `_layouts`, `_includes`, and `_sass` tracked with Git will be released.

## License

The theme is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

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
