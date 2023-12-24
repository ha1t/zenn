---
title: "新進気鋭のRailsライクRustフレームワークLocoでHTMLを表示する"
emoji: "🦀"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["rust", "loco", "tera"]
published: true
---

:::message alert
2023-12-10 loco-cli version 0.2.0 時点の情報です。loco自体はこれから大幅な進化をとげる予感があるので、現時点では。という前提でお読みください

あと私はRustまったく知らないで勘で書いてるWeb屋なので間違った事書いてる可能性が高い事もご了承ください。
:::

# RailsライクなRustフレームワークがついにやってきた！

Rustという言語は本当にかっこいいし、書いててワクワクする言語ではあるものの、Webの世界で使おうとすると、様々なライブラリを自分で組み合わせて構築する必要があり、「ちょっと試してみたい」とWebしかしらないRust素人がおもっても、学習コスト、調査コストが高すぎてミニマムなプロダクトを作る所にたどり着くまでに「もういいや Go で」とさじを投げてしまう状況があるように感じています。

そこに登場したのがLocoです。

# Locoとは

![](/images/20231210_184955.webp)

[Loco](https://loco.rs/) は、

> The one-person framework for Rust for side-projects and startups

ということで、小規模をターゲットにしたフレームワークです。

# チュートリアルをやってみる

一足先にClassmethodさんがチュートリアルをやられているので、[RailsライクなRustのWebフレームワーク 「Loco」 | DevelopersIO](https://dev.classmethod.jp/articles/rust-loco/) を見つつ公式のドキュメントを見ながらやると簡単に動かすことができます。

# HTMLがでない

```
$ loco new
```

を実行すると雛形を選択する画面がでてきて、そこで「Saas app (with DB and user auth)」を選択して構築されるアプリのコードを読んでみると

・GET,POST,DELETE のリクエストメソッドが実装されている
・Routerに設定することでURLに含まれる情報を変数として受け取れる仕組みがある
・このサンプルコードはJSONを返却するAPIしか用意されていない
・各APIへのリクエストに渡すパラメーターはJSONで作って送る
・認証(auth)のサンプルもあるが、ユーザー名パスワードからトークンを発行して以後のリクエストに含める運用

あたりの事がわかるんですが、

Web屋さんの定番サンプルコードである掲示板を実装したいなら別途JSのフレームワークなどを用意してこのAPI群を叩く形でしか無理では？という気持ちに。
中でもHTMLでないの本当に困るなぁと思ってGitHubを眺めていたらTeraを使えば簡単に表示できるみたいです。

# HTMLテンプレートTeraを使ったHTML表示の仕方

GitHubにあるissueをみていたら、3日前のpostで

> we just released an example in our starters that supports server-side generated templates using tera.
> you can run loco new and select the Stateless HTML template
> https://github.com/loco-rs/loco/issues/26#issuecomment-1844959677

ということなので、早速やってみました。
loco new を使って「Stateless HTML」を使ってサンプルを作ると、Teraを使った最小限のプロジェクトが出力されます。

![](/images/20231210_200849.webp)

せっかくなのでURLの内容をテンプレートに表示してみましょう。
id を表示するには、まずコントローラーを以下のように書き換えて

```rust:main.rs
use axum::{extract::State, response::Html, routing::get};
use loco_rs::prelude::*;
use loco_rs::{
    app::AppContext,
    controller::{format, Routes},
    Result,
};
use tera::Tera;

const HOMEPAGE_T: &str = include_str!("../views/homepage.t");

async fn index(State(ctx): State<AppContext>) -> Result<Html<String>> {
    let mut context = tera::Context::new();
    context.insert("environment", &ctx.environment.to_string());
    context.insert("id", &0);

    format::html(&Tera::one_off(HOMEPAGE_T, &context, true)?)
}

async fn index2(Path(id): Path<i32>, State(ctx): State<AppContext>) -> Result<Html<String>> {
    let mut context = tera::Context::new();
    context.insert("environment", &ctx.environment.to_string());
    context.insert("id", &id);

    format::html(&Tera::one_off(HOMEPAGE_T, &context, true)?)
}

pub fn routes() -> Routes {
    Routes::new()
        .add("/", get(index))
        .add("/:id", get(index2))
}

```

テンプレートのbody部分はこんな感じにすると、http://localhost:3000/10 とかで10を表示できるようになります。

```rust:homepage.t
<body>
    Welcome to Loco website
    <br/>
    {% if id > 0 %}
    {{id}}
    {% endif %}
    <nav>
        <a href="https://loco.rs" target="_blank">
            <img alt=""
                src="https://github.com/loco-rs/loco/raw/master/media/image.png" />
        </a>
    </nav>
    <br/>
    <a href="https://loco.rs" target="_blank">loco.rs</a>

    <ul>
        <li><strong>Environment:</strong>
           {{environment}}
        </li>
    </ul>
</body>
```

format::html() を使う事で簡単にテンプレート利用できるので良いですね。構文もどっかでみたことある感じなのでノーストレスで使えます。

# まだわからない事も多い

まだ調べている最中なのでなんともいえませんが、あとは
・いわゆるPHPでいう \$\_GET や \$\_POST (URLの?以降やFormから送信された情報の取得)
・いわゆるPHPでいう \$\_SESSION
あたりが使えると普通のWebサービスもいけそうなんですが今回のように簡単にいく感じではなさそうなので今後のアップデートでひな形が増えるといいなぁと思っています。

個人的にはRustでWebに挑戦して数度挫折していて、Locoのおかげでようやく最初の画面を作れたので、今後もLocoを追いかけていくつもりです。
またわかったことがあったら更新します。
