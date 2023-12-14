# あるチームでの技術選定で考えてること(外部向けに修正版)

@vividmuimui
2023/12/22 社内エンジニア忘年会LT

---

## 前提 & 目的

前提
- まだ検討中で変更はあるかも

目的
- もしみなさんが知らないGemがあったりして、所属チームに活かせるものがあれば嬉しい。
- 「そのGemよりこっちがいいよ」とかあれば教えていただけると嬉しい

---

## TL;DR

Evil Martians(TechRacho翻訳)の以下の記事をほとんど参考にしてる
- [Rails: Evil Martiansが使って選び抜いた夢のgem（翻訳）](https://techracho.bpsinc.jp/hachi8833/2023_02_16/126782)
- [実践ViewComponent（1）: 現代的なRailsフロントエンド構築の心得（翻訳)](https://techracho.bpsinc.jp/hachi8833/2022_11_25/123684)
- [実践ViewComponent（2）: コンポーネントを徹底的に強化する（翻訳)](https://techracho.bpsinc.jp/hachi8833/2022_11_28/124509)

その他の参考情報
- https://www.ruby-toolbox.com/
- https://awesome-ruby.com/
- 社内のGemfile
- などなど

---

## Rails new

- importmap ではなく jsbundling-rails & esbuild
    - importmap 関連のエコシステムが整うにはもう少し時間がかかりそう
        - たとえば dependabot が importmap-railsのフォーマットに[対応してない](https://github.com/dependabot/dependabot-core/issues/6675)
    - package.json をそのまま扱ってpackageを管理できる方が今は嬉しい気がする
- sprockets ではなく propshaft
    - propshaft はまだベータ扱いだがいまから作るもので導入するならまぁ問題ないのではと思ってる。
    - また、今後 rails のデフォルトが sprockets から propshaft に変わる可能性があるので。

---

## 認証・認可

認証
- devise, sorcery, rodash 悩ましい :thinking:
    - https://speakerdeck.com/sylph01/build-and-learn-rails-authentication

認可
- action_policy が良さそう
    - 参考: [Rails: Evil Martiansが使って選び抜いた夢のgem（翻訳）](https://techracho.bpsinc.jp/hachi8833/2023_02_16/126782)
    - pundit, bankenの仕組みが良いと思っている。
    - 「Punditの強化版です。パフォーマンスや開発エクスペリエンスを重視する優れた機能を提供します。」とのこと

---

## config

- anyway_config が良さそう
    - 参考: [Rails: anyway_config gemでRubyの設定を正しく整理しよう（翻訳）](https://techracho.bpsinc.jp/hachi8833/2020_06_03/91468)
    - 環境変数、yaml, Rails Credentials を扱える
    - rubyファイルでメソッドも生やせる
    - `FooConfig.to_source_trace` で値の読み込み元を確認できる

---

## breadcreams, pagination

breadcreams
- gretel が良さそうかなぁと思っているが、おすすめがあれば教えてください
    - 以前使って体験良かったのと、 config/breadcreams.yml に書くので管理しやすい

pagination
- pagy を試して見て問題なければこれにする
    - https://techracho.bpsinc.jp/hachi8833/2021_07_13/57481
    - でかいテーブルをさばこうとしたときのパフォーマンスが良い
    - この情報2021年なので、kaminari とか will_pagenate の方がいいとか改善されてるとかの情報あれば教えてください！

---

## その他

- 検索: ransack
- protection: rack-protection
- feature flag: flipper or feature_toggles :thinking:
- 画像管理: active_storage or shrine :thinking:
- seed: seed-fu (これしかない？) :thinking:
- test関連
    - rspec, factory-bot, faker
    - :star: Zonebie(Timezoneをランダムにする)
- log系: lograge, audited, rack-user_agent
- CI系: danger, review-dog, brakeman
- database関連
    - 補助: annotate, bullet
    - :star: 変なSQL投げないように: database_consitency, isolator, strong_migrations
    - :star: データメンテ: maintenance_tasks

---

# ここからがメイン

---

## モジュラモノリス

- packwerk
    - packwerk は Shopify 製のモジュラモノリスのための仕組み。境界違反の検知とかもできて高機能。

1つのプロダクトの中に複数のシステムがあるので、モジュラモノリスとして扱えるのが良い気がしている。
だが、本当に必要かは検討が必要で悩ましい。本当に必要になるまでは単にnamespaceとかrails engineでもいいのかも。

---

チームやサービスの状況によって違うが、以下のように思っている

- マルチリポよりモノリポの方がいい
    - マイクロサービスでない限り、モノリポのほうが便利
    - マイクロサービスでないなら、チームは完全に独立して動かないし別システムでもないので1つのシステムで扱っておいたほうが便利なことが多いと思う。
    - モノリポの不便さは概ね頑張って解決できるはず。
- マイクロサービスよりはモノリスの方がいい
    - チームやサービスが完全に分断しない限りモノリスがいい。よくいわれるやつ。

---

## コンポーネント開発1

- view_component
    - GitHub 製の ruby/rails でのコンポーネント開発のためのもの
- lookbook
    - view_component のライブラリ群の1つで、 storybook のようにコンポーネント単独で描画・確認できるもの
    - erbなども描画できるが[バグ](https://github.com/ViewComponent/lookbook/issues/560)がある

react/storybook/css in js(CSS modules)などのようにコンポーネント開発を取り入れたい。
コンポーネントごと描画しテストできることで、テストが書きやすい。動作確認もしやすい。Visual Regression Testもこれに乗っかってできるなら便利そう。

参考: [実践ViewComponent（1）](https://techracho.bpsinc.jp/hachi8833/2022_11_25/123684)

---

## コンポーネント開発2

```ruby
components/
  example/
    component.html.erb # 通常のviewファイル
    component.rb # Example::Componentクラス(view component)
    preview.rb # Example::Previewクラス(lookbook)
    styles.css # CSSスタイル
    whatever.png # その他のアセット
    controller.js # Stimulusのコントローラ
```

- コンポーネント(viewファイル)と同階層でcss, jsを扱えるようにする
- CSS は、CSS modulesのようなスコープ化の仕組みも入れる

こうすることで開発体験がぐっと良くなるはず。
参考: [実践ViewComponent（2）](https://techracho.bpsinc.jp/hachi8833/2022_11_28/124509)

---

## CSS :thinking:

① 自前である程度 CSS 書くパターン

- tailwind
    - デザイントークン周りやpadding/margin/font-sizeなどぐらいに使う。スタイリングはCSSを普通に書く。
- flowbite ( + flowbite-admin )
    - tailwind つかった(?) headless UI ライブラリ
        - react/vueではないので選択肢はそこまで多くない
    - data属性で対象指定するのでわかりやすい

② tailwind 全乗っかり
③ bootstrap 全乗っかり

---

## admin framework :thinking:

- scaffoldを自前で用意して、素朴にview, controller 書くほうが良さそうに感じている
- active_admin や rails_admin はDSL強いのでカスタマイズしにくい
- administrate はカスタマイズできると言っているが、全部上書きできるわけではない
    - たとえば、ページネーションとかカスタマイズできない。(できるけど、自前で書くのと何も変わらなくなってくる)
    - 補足: administrate の propshaft 等の対応の[PR](https://github.com/thoughtbot/administrate/issues/2311)が絶賛開発されてる

それなりに複雑な画面もある想定なのでカスタマイズしやすさは担保しておけると良さそうと思っている

---

# おわり
