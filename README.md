# 5ch-like_bulletin-board

掲示板チャンネルライクの投稿型アプリケーションです。

# ライセンス

Please refrain from using without permission.

許可なき利用はご遠慮ください。

# インストール

```
$ bundle install --without production
```

その後、データベースへのマイグレーションを実行します。

```
$ rails db:migrate
```

データベースへ初期データの登録

```
$ rails db:seed
```

Railsサーバーの立ち上げ

```
$ rails server
```

# ゲストユーザーログイン
email   : "example@railstutorial.org"
password: "foobar"