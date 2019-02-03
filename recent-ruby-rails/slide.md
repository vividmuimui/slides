# 最近(2019/02/03)のRuby,Rails,Bundler事情

@vividmuimui
2019/02/06 社内LT

---

# :warning: この資料は 2019-02-03 の時点での情報です！:warning:

### 1週間も経てばまるっと内容が変わってる部分もあるかもしれないので注意してください！

---

## タイムライン

| 2018/12/25 | :link: [Ruby 2.6.0 リリース](https://www.ruby-lang.org/ja/news/2018/12/25/ruby-2-6-0-released/) :tada: |
| 2019/01/04 | :link: [Bundler 2.0 リリース](https://bundler.io/blog/2019/01/04/an-update-on-the-bundler-2-release.html) :tada: 1/3に2.0.0, 1/4に2.0.1 |
| 2019/01/18 | :link: [Rails 6.0.0 beta1 リリース](https://weblog.rubyonrails.org/2019/1/18/Rails-6-0-Action-Mailbox-Action-Text-Multiple-DBs-Parallel-Testing/) |
| 2019/01/30 | :link: [Ruby 2.6.1 リリース](https://www.ruby-lang.org/ja/news/2019/01/30/ruby-2-6-1-released/) |
| 2019/02/01 | Rails 6.0.0 beta2 がリリース予定。現状ではまだ |
| 2019/03/01 | Rails 6.0.0 rc1 リリース予定 |
| 2019/04/01 | Rails 6.0.0 rc2 リリース予定 |
| 2019/04/30 | Rails 6.0.0 リリース予定 :tada: |
| ???? | Ruby 新元号対応のリリースが平成のうちにあるらしい |

Railsのリリーススケジュール
:link: [Timeline for the release of Rails 6.0](https://weblog.rubyonrails.org/2018/12/20/timeline-for-the-release-of-Rails-6-0/)

---

## Ruby 2.6.0 個人的な目玉機能

https://www.ruby-lang.org/ja/news/2018/12/25/ruby-2-6-0-released/

- :star: Ruby 2.6ではJIT (Just-in-time) コンパイラが導入
  - 有効にするには`--jit`オプション or `$RUBYOPT`環境変数
- :star: Bundler を Default gems として標準添付
  - 2.6.0 には 1.17.2 が同梱、 2.6.1 では 1.17.3
- `Kernel#yield_self`の別名として`then`が追加
- 終端なしRange
- Procを関数合成するオペレータ`Proc#<<`、`Proc#>>`が追加
- Kernel#system に失敗時に例外を上げさせる`exception:`オプションが追加
- Coverage の oneshot_lines モードの追加

---

## Ruby 2.6.1

:warning: Ruby 2.6.0 はいくつかバグがあるので上げるなら2.6.1!


- :link: [Invalid JSON data being sent from Net::HTTP in some cases with Ruby 2.6.0](https://bugs.ruby-lang.org/issues/15472)
- :link: [CSV.generate returns unexpected encoding string](https://github.com/ruby/csv/issues/62)
- :link: [Net::Protocol::BufferedIO#write raises NoMethodError when sending large multi-byte string](https://bugs.ruby-lang.org/issues/15468)

未だに解決してない問題

- :link: [Ruby2.6 included `bundler` does not handle specified `csv` gem.](https://bugs.ruby-lang.org/issues/15469)
  - bundler 1.7.3を明示的に使えば直るらしい
  - Ruby 2.6.1 には bundler 1.7.3 が同梱されているが、それではだめらしい
  - bundler 2.0に上げれば直るかも？

それにしても 2.6.0 は使わず、 2.6.1 にすべき！(当たり前だけど)

---

## Rails 6 注目ポイント

:link: [Rails 6.0.0 beta1: Action Mailbox, Action Text, Multiple DBs, Parallel Testing, Webpacker by default](https://weblog.rubyonrails.org/2019/1/18/Rails-6-0-Action-Mailbox-Action-Text-Multiple-DBs-Parallel-Testing/)

- :star: Action MailBox
- :star: Action Text
- :star: MultiDB support
- :star: parallel testing support
- webpacker がデフォルトで入る
- :link: [Zeitwerk: A new code loader for Ruby](https://medium.com/@fxn/zeitwerk-a-new-code-loader-for-ruby-ae7895977e73)
  - https://github.com/fxn/zeitwerk
  - Beta2 で新しいファイルのauto loaderが入るらしい
- Ruby 2.5+

---

## Rails6: ActionText

- JSのライブラリの:link:[Trix](https://trix-editor.org/)を使ったWYSIWYG
- 画像アップロード機能もある
  - ActiveStorage前提
  - モバイルでのアップロードはUIがないので難しい
- Edgeで動かない
  - 原因わかってない(調べてない)
- 日本語入力周りは大筋動くがバグもある
  - :link: [basecamp/trix#580](https://github.com/basecamp/trix/pull/580) このPRが入ればまるっと解決するかも
  - (直ることを祈ってる :pray:)

---

## Rails6: MultiDB support

- まだまだ絶賛開発中ぽい
- :link: [eileencodesさんのPR](https://github.com/rails/rails/pulls?utf8=%E2%9C%93&q=is%3Apr+author%3Aeileencodes+label%3Aactiverecord)を追えば理解できる(と思ってる)
- 最近入った目玉: :link: [Part 8: Multi db improvements, Adds basic automatic database switching to Rails](https://github.com/rails/rails/pull/35073)
  - HTTP verbs(GET or HEAD)をみて R/W splitting をする
  - repliation 遅延も考慮して、最後の書き込みから5s経ってたらreplicaからreadする実装も入ってる
    - デフォの挙動は`request.session`に`last_write_timestamp`を書き込む
  - デフォルトでは無効化されてる(現状では)

---

## Rails6: parallel testing support


```ruby
class ActiveSupport::TestCase
  parallelize_setup do |worker|
    # setup databases
  end
   parallelize_teardown do |worker|
    # cleanup database
  end
   parallelize(workers: 2)
end
```

:link: [rails/rails#31900](https://github.com/rails/rails/pull/31900)
実装をみればActiveRecordを使わずにDBを触ってる場合でも有効化はできそう

---

## Rails6: その他

- 5.2.2と6.0.0 beta1で`rails new`したときのdiff: http://railsdiff.org/5.2.2/6.0.0.beta1
- :link: [Upgrading from Rails 5.2 to Rails 6.0](https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-5-2-to-rails-6-0)
  - :warning: 正式リリースまでは随時変わる(はず)ので注意
- :link: [release note](https://edgeguides.rubyonrails.org/6_0_release_notes.html)
  - 正式な6.0.0用のリリースノートのページ
  - :warning: 正式リリースまでは随時変わる(はず)ので注意


{:class="center"}
[リリーススケジュール](https://weblog.rubyonrails.org/2018/12/20/timeline-for-the-release-of-Rails-6-0/)

| 2019/01/18 | beta1 |
| 2019/02/01 | beta2 |
| 2019/03/01 | rc1 |
| 2019/04/01 | rc2 |
| 2019/04/30 | リリース予定 :tada: |

---

## Bundler 2.0

- 1/3に2.0.0, 1/4に2.0.1がリリース
- :link: [Announcing Bundler 2.0](https://bundler.io/blog/2019/01/03/announcing-bundler-2.html)
- :link: [How to Upgrade to Bundler 2](https://bundler.io/v2.0/guides/bundler_2_upgrade.html)

```sh
$ gem install bundler
Fetching: bundler-2.0.1.gem (100%)
Successfully installed bundler-2.0.1
1 gem installed
```

今普通に `gem install bundler`すると 2.0.1が入る

---

## Bundler2: 注目ポイント

- `github:` sourceがデフォルトでhttpsになった
  - :warning: 2.0.1の時点ではなってない
  - :link: [bundler/bundler#6910](https://github.com/bundler/bundler/issues/6910)
- error/warningが`STDERR`に出るようになった
  - bundlerの出力をみて挙動を変えてる処理をライブラリなどで書いてる場合は要注意(ほぼないとは思うが)
- lockfileの中身を見て、使うbundlerの2系を使うのか1系を使うのかを自動で切り替える
  - `bundler -v`の結果が2.0.1でも、lockfileの中が↓なら`bundle install`などでは自動でbundler 1系に切り替わる
  - ```
    BUNDLED WITH
      1.17.2
    ```

---

## Bundler2: 注目ポイント

以前から噂されていた多くの大きな変更はBundler3に回されている

- :link: [bump all bundler 2 features (except stderr) to bundler 3](https://github.com/bundler/bundler/commit/b61a39143e8f3bc8e71553ae85a3d56bbc554dc0)
- `gems.rb`がデフォルトになって`Gemfile`がdeprecationになる件
- 引数無しで`bundle`を実行したとき、今は`install`だが`help`になる件

などなどがbundler3に回されている

:link: [An Update on Bundler 2.0](https://bundler.io/blog/2018/11/04/an-update-on-bundler-2.html)
メジャーアップデートのルールに関して書かれてる。とても丁寧な内容のルールになった

- メジャーアップデートでは即破壊的となるような変更はせず、depricationにし、その次のメジャーバージョンで取り除く
- セキュリティパッチは1つ前のメジャーバージョンにも適用する
- 2.0のメジャーアップデートでは、破壊的変更はほぼない
  - 3.0でいろいろ負債を解消するための布石という感じ

---

## Bundler2: 既存アプリでBundler2を使う

```sh
$ gem update --system
$ gem install bundler
$ bundle update --bundler
```

前ページの記事にあるように、2.0にあげるのは問題なく上がる

---

## まとめ・所感

- ruby 2.6.0はそこそこバグがあるので使うなら2.6.1
  - (当たり前だけど)
  - bundlerが同梱されるようになってバグがまだ残ってそうで、そのバグFIXのリリースもそう遠くないうちにあるかも(?)
  - アプリによっては、様子見して2.5系を使っておく、という選択も全然ありかも
- Rails6はrcが出るまでは様子見で全然良さそう
  - 普通のWebサイトを作る分には最高のメジャーアップデートになりそう
  - Multi DBに関しては、機能が揃ったらひと通りきちんと内容を把握してから利用したほうが良さそう
    - (当たり前だけど)
- Bundlerはさくっと2.0にあげれる
  - メジャーバージョンのリリースのルールがとても丁寧な内容に決められ、噂されてた超大型アップデートな内容は3.0に回されたので

