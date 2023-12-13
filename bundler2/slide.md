# Ruby会議でのBundler2の話

@vividmuimui
2017/10/05 社内LT

---

<img src="images/schedule.png"/>

このスライドは、基本的にはこの発表をなぞっています

http://rubykaigi.org/2017/presentations/0xColby.html
youtube: https://www.youtube.com/watch?v=sZX7SK3hxk4
speakerdeck: https://speakerdeck.com/colby/what-weve-been-up-to-with-bundler
rfc#6: https://github.com/bundler/rfcs/pull/6

---

# この1年で入ったやつの紹介

- bundle doctor
- bundle add
- bundle plugin

---

## bundle doctor

skip

---

## bundle add

```console
$ bundle add rspec
```

```ruby
# Gemfile

# Added at 2017-10-04 00:17:42 +0900 by vividmuimui:
gem "rspec", "~> 3.6"
```

以下のようにオプションも指定できる

```console
$ bundle add rails --version "~> 5.0.0" --source "https://gems.example.com" --group "development"
```

botとかなら使いみちあるかも？

---

## bundler plugins

```ruby
module MyBundlerPlugin
  class Plugin < Bundler::Plugin::API
    command "new-command"

    def exec(command, args)
      puts "Hello World"
    end
  end
end
```

```
$ bundle new-command
Hello World!
```

という感じで、新しいコマンドを用意できる
ほかにも、以下のようにも出来たりするみたい

```ruby
Bundler::Plugin::API.hook "before-install-all" do |deps|
  puts "Installing #{deps.map(&:name).join(', ')} 👍!"
end
```

```console
$ bundle install
Installing rack 👍!
Using bundler 1.15.4
...
...
```

---

## bundler plugins

作成したpluginのinstallは以下の感じ

```console
$ bundle plugin install my-bundler-plugin
```

```ruby
# Gemfile
plugin 'my-bundler-plugin'
```

まだまだ、`plugins`に関してはまだまだ機能もdocumentもbugfixも足りてないらしい

---


## 1.16が1系の最後のバージョンになる予定

---

# bundler2

---

# Removing

- Ruby2.3未満のサポート
- Gemfile Source Shortcuts
- `bundle show`
- `bundle viz`
- `bundle console`
- persistent command arguments
- `--with --without --path --system`
- `bundle package`

いくつかかいつまんで紹介

---

## Ruby2.3未満のサポート

skip

---

## Gemfile Source Shortcuts

```ruby
gem "rack", github: "user/repo"
gem "rack", bitbuket: "user/repo"
```

といった`shortcut`がなくなり、以下の書き方をするようになる

```ruby
gem "gem1", source: "https://mygemserver.private"
gem "gem2", git: "https://github.com/user/repo.git"
gem "gem3", path: "path/to/gem"
```

ただ、今まで書いていたように`git_source`を書いておけば`github: "user/repo"`も書ける

```ruby
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rack", github: "user/repo"
```

---

## bundle show

現状の`bundle show`は機能がたくさんあり複雑
- `bundle info`
- `bundle list`

の2つのコマンドに分割

---

## bundle viz

pluginとして切り出される

```console
$ bunldle plugin install bundle-viz
```

---

## bundle console

skip

---

## persistent command arguments

オプション引数を自動で記録する処理がなくなる
たとえば、今は以下のコマンドを実行すると、今は自動でconfigファイルに`path=foo`を記録されるが、されなくなる
```console
$ bundle install --path foo
```

毎回常にoptionを指定するか、以下のようにconfigを明示的に設定する必要がある

```console
$ bundle config path foo
```

---

## --with --without --path --system

`bundle install`での上記optionを削除
代わりに`bundle config`を使う

---

## bundle package

`bundle package`から`bundle cache`に変更

---

# Adding

Removingに比べて少ない

- Global gem & extension cache
- Specific platforms

---

## Global gem & extension cache

複数アプリケーションで同じgemを使っていたり、
複数rubyバージョンで同じgemを使っているときにinstallが高速化される

---

## Specific platforms

難しくてよくわかんなかった＞＜

---

# Changing

- bundle
- bundle update
- bundle1との互換性
- gems.rb

---

## bundle

今は`bundle install`が実行されるが、usageが表示されるようになる
<img src="images/usage.png"/>

---

## bundle update

今は、
```console
$ bundle update
```

で全gemのupdateが走るが、明示的に指定する必要がある

```console
$ bundle update <gem-name>
$ bundle update --all
```

のどちらかになる

---

## bundle1との互換性

下位互換はないので注意する必要がある
`bundler2`で`bundle install`したら`bundler1`では動かない
なので、チームメンバーの足並み合わせて、せーのであげる必要がある
(複数プロジェクトを担当していて、同じrubyバージョンを使っている場合は、プロジェクトをまたいでも足並み揃える必要があるかも？)


---

## gems.rb

- `bundler2`で`bundle init`した時に生成されるファイルは`gems.rb`になる
- 今までの`Gemfile`, `Gemfile.lock`は普通に使える
  - deprecation warningもでない
- `gems.rb`と`Gemfile`が両方存在していたときは、`gems.rb`が優先される

---

# 今後

---

## Ruby2.5にdefault gemとしてbundlerが入る

どのbundlerのバージョンが入るかはhsbtさんと相談と言っていたように聞こえた
でも、2系になりそうな雰囲気だった(曖昧)

---

## 毎年メジャーリリースをする

rubyのリリースのように毎年年末あたりにメジャーリリースが行うようになる
rubyのサポートのバージョンを変えたり、古い機能を削除したりなど

---

# おまけ

[rfc#6](https://github.com/bundler/rfcs/pull/6/) 見てて気になったやつ

- `bundle install`した時のデフォルトのインストール先が`./.bundle`以下になる
