# TaxJp

税金計算ライブラリ
* 消費税
* 社会保険（健康保険・厚生年金）
* 雇用保険
* 源泉徴収
* 減価償却率

## インストール

Gemfile に以下の記述を追加

```ruby
gem 'tax_jp'
```

bundle を実行

    $ bundle

## 使い方

### Rails-7.2

routes.rb に以下の記述を追加

```ruby
  mount TaxJp::Engine, at: '/tax_jp', as: 'tax_jp'
```

Railsを起動

    $ rails s

ブラウザで localhost:3000/tax_jp にアクセス

![トップページ](https://raw.github.com/wiki/hybitz/tax_jp/images/top.png)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tax_jp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
