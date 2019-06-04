# Dependabot vs BundleUpdate+LockDiff

@vividmuimui
2019/06/05 社内LT資料

---

# 話すこと

最近導入された `Dependabot` と、
これまで使っていた `BundleUpdate+LockDiff` を比較

---

# ざっくり用語

---

## Dependabot

- <https://dependabot.com/>
- ライブラリのUpdate自動で行ってPullReqestを上げてくれるサービス
- 最近、privateリポでも完全に無料で使えるようになった

---

## BundleUpdate+LockDiff

- CircleCIでBundleUpdate(rubyでのライブラリの更新)をしてPullReqestを作れるツール
- 正確には `circleci-bundle-update-pr-with-lock-diff`
    - この資料では長いので `BundleUpdate+LockDiff`と書きます
    - [vividmuimui/circleci-runner](https://github.com/vividmuimui/circleci-runner/tree/master/circleci-bundle-update-pr-with-lock-diff)
        - 以下の合わせ技+forkしたもの
        - [yhirano55/circleci-runner](https://github.com/yhirano55/circleci-runner)
            - [masutaka/circleci-bundle-update-pr](https://github.com/masutaka/circleci-bundle-update-pr)
        - [vividmuimui/lock_diff](https://github.com/vividmuimui/lock_diff)
- 社内の色んな所で使われている

---

## ざっくり用語まとめ

Dependabot, BundleUpdate+LockDiff どちらも、ライブラリの更新をしてPullReqestを上げてくれる。
Dependabotはサービスなのでとても高機能。
BundleUpdate+LockDiff は長いこと社内で便利に使ってきたやつ。

---

# 簡単な機能比較

---

|                     |       Dependabot       | BundleUpdate+LockDiff |
|---------------------|------------------------|-----------------------|
| PR                  | ライブラリごとに1PR    | 1つのPRで一括で更新   |
| 言語                | Ruby,JSなどたくさん | Rubyだけ              |
| ChangeLog           | :o:                    | :o:                   |
| Commits             | :o:                    | :o:                   |
| rubygems へのリンク | :x:                    | :o:                   |
| Vulnerabilities     | :o:                    | :x:                   |
| 高機能感            | :o:                    | :x:                   |
| 組み込みやすさ      | :o:                    | :o:                   |

参考PR
- Dependabot: [vividmuimui/rails_tutorial#44](https://github.com/vividmuimui/rails_tutorial/pull/44)
- BundleUpdate+LockDiff: [vividmuimui/lock_diff_sample#15](https://github.com/vividmuimui/lock_diff_sample/pull/15)

---

# Dependabot

- ライブラリごとにPRがあがる
- 対応言語が多い
    - <https://dependabot.com/#languages>
- 脆弱性対応の更新なのかわかる
- Compatibilityが見れる
- botが優秀
    - 必要なくなったら自動で閉じたり、コンフリクトしてたら自動でrebaseしてくれたりする。
- カスタマイズできる
    - <https://dependabot.com/docs/config-file/>
- 全体通して圧倒的に高機能
- PRがたくさん上がってマージしていくので、CIのキューが詰まりがち

---

## BundleUpdate+LockDiff

- CircleCIに簡単に組み込める
- RubyのBundle updateだけできる
- Bundle Updateしてるだけなので、1PRで一括で更新が入る
- LockDiffもそれなりに便利
    - Tachikoma + LockDiff といった感じで組み合わせれば、CircleCi以外でも簡単に動く
- 普段自分たちが使うコマンドでupdateされるので、理解しやすい
    - 基本的には`bundle update`してPR作ってるだけなので。
- Dependabotに比べると機能が少ない
    - 個人のOSS開発なので

---

# どっちが良いか・どう使い分けるか

---

## どっちが良いか・どう使い分けるか

現状両方使っている。チームの中で、それが良さそうとなった。

まだ、Dependabotを導入して1週間も立ってないが、
DependabotはDaily, BundleUpdate+LockDiffはWeeklyで動かしているのが良いリズムっぽい。

ちなみに、yarn(JS)に関してもDependabotだけでなく以下を併用してWeeklyで更新されるようにしている

- [vividmuimui/circleci-runner](https://github.com/vividmuimui/circleci-runner/tree/master/ci-yarn-upgrade)
    - [yhirano55/circleci-runner](https://github.com/yhirano55/circleci-runner)
    - [taichi/ci-yarn-upgrade](https://github.com/taichi/ci-yarn-upgrade)

---

## 良いリズム

- 基本的には Dependabotが上げてくるPRを毎日消化していく
    - dailyで動かしても、多くても1日2,3PR程度しか上がらない
- 溜まってしまったら、 BundleUpdate+LockDiff で一括マージする
    - DependabotのPRはbotが自動で閉じてくれる
- Security update(脆弱性対応)は特に高速にマージする

---

## 終わり

`Dependabot`, `BundleUpdate+LockDiff` どっちも便利なので両方使っていく。

チーム・リポジトリによっては、
- Dependabotのsecurity updateだけにする
- `BundleUpdate+LockDiff`だけにする

というのも全然アリ。

---

ぜひ便利なので、 `Dependabot`, `BundleUpdate+LockDiff` 使ってみてください！。
導入の仕方とか使用感とかに感して、質問・相談あれば遠慮なくしてください。
