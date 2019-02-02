{:.left}
## `lock_diff` の紹介

2017/07/06 社内LT資料

---


{:.left}
## lock_diffとは :confused: :grey_question:

https://rubygems.org/gems/lock_diff

---

{:.left}
## こういうやつ :one:

![image](https://user-images.githubusercontent.com/1803598/27892016-512ae11a-6238-11e7-9baf-55b660f26052.png)

---

{:.left}
## こういうやつ :two:

![image](https://user-images.githubusercontent.com/1803598/27891676-169d6876-6236-11e7-9e9a-c2fc39c4e38b.png)

---

{:.left}
## こういうやつ :three:

![image](https://user-images.githubusercontent.com/1803598/27891702-388d5f9a-6236-11e7-802b-93077be8e622.png)


---

{:.left}
## こういうやつ :four:

```markdown
<!-- diffの一部 -->
[v3.2016.0221...v3.2016.0521]
  (https://github.com/mime-types/mime-types-data/compare/v3.2016.0221...v3.2016.0521)
[v2.0.0...v2.2.0](https://github.com/flavorjones/mini_portile/compare/v2.0.0...v2.2.0)

<!-- change logの一部 -->
[change log](https://github.com/mime-types/mime-types-data/blob/master/History.md)
[change log](https://github.com/flavorjones/mini_portile/blob/master/CHANGELOG.md)
```

---

{:.left}
## lock_diffとは :bulb:

PRの`Files changed`にある`Gemfile.lock`の変更の差分を見て、
- CHANGELOG系ファイルへのリンク
- git tagによる差分表示のリンク

をPRにコメントするgem

---

`CHANGELOG系ファイルへのリンク`は、

- `CHANGELOG.md`とか`History.txt`とか`news`とかそれっぽいファイルが存在していればそのリンクを
- github releasesが存在していればそのリンクを

と、よしやにやるようにしてある :sunglasses:


`git tagによる差分表示のリンク`も、
Gemfile.lockの変更差分にはrubygemのversionしかないので、それをもとに
- `"v#{version}"`という名前のtag名があればそれを
- `"#{gem_name}-#{version}"`があればそれを

と、よしやにやるようにしてある :sunglasses:

---

{:.left}
## 実行の仕方

```console
$ extern GITHUB_ACCESS_TOKEN="xxxxxxx"
$ gem install lock_diff
$ lock_diff
Usage: lock_diff [options]
    -r, --repository=REPOSITORY      required. Like as "user/repository"
    -n, --number=PULL_REQUEST_NUMBER required
        --post-comment=true or false (default=false. Print result to stdout when false.)

$ lock_diff -r "vividmuimui/rails_tutorial" -n 26 --post-comment=true
```



- githubのアクセストークン: `GITHUB_ACCESS_TOKEN`

を設定し、

- リポジトリ名: "vividmuimui/rails_tutorial"
- PR番号: "26"

を指定すれば動く。

- `--post-comment`は実行結果をPRにコメントを投げるか、標準出力に出力するだけか、を選択できる

---

{:.left}
## 作成のきっかけ

- :one: [deppbot](https://www.deppbot.com/)
- :two: [compare_linker](https://rubygems.org/gems/compare_linker)

---

{:.left}
## 作成のきっかけ :one:

bundle updateを定期的にしてくれるサービスの[deppbot](https://www.deppbot.com/)のPRのdescriptionが良かった

![image](https://user-images.githubusercontent.com/1803598/27892800-a2df9f10-623c-11e7-8970-c1168922554b.png)


privateリポジトリは有料 :cry:

---

{:.left}
## 作成のきっかけ :two:

似たようなことをしてくれる[compare_linker](https://rubygems.org/gems/compare_linker)というgemが既にあった
![](https://camo.githubusercontent.com/3f19e379932c086ad99c5f64b11b05e5eec276ae/68747470733a2f2f662e636c6f75642e6769746875622e636f6d2f6173736574732f31303531352f323030343436392f64653337343135322d383661652d313165332d383461302d3139653265663430623935392e706e67)

しかし、
- CHANGELOGへのリンクがない
- 最終更新が2年前

---

{:.left}
# :bulb: :exclamation::exclamation:

compare_linkerの実装をベースに、 CHANGELOGへのリンクを出すようにするのが良いのでは！
という流れで作った

---

{:.left}
## できていること・できてないこと・やりたいこと

- updateの変更しか検知できてない。追加の変更にも対応したい
- gemがどのgroup(development, production, test)に所属しているのか出せれば出したい
- gemがどのgemに依存しているやつなのかをぱっと見えるようにしたい
- versionが下がるような変更がある時に、上手く動かないはず
- rubygemsにあがっていないgem(localやgithub指定)のときの挙動が怪しい
- railsの変更を出せるようにしたい
  - 特別扱いして出したい
- yarnとかにも対応できればいいなという気持ち

---

{:.left}
## 最後に

- 使っていただける機会があって、バグとか要望とかあったらissueお願いしたいです! :bow:
  - https://github.com/vividmuimui/lock_diff/issues
- :warning: ソースコードは汚いので見ないで欲しいです! :warning:
