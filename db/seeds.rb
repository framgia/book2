# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
data = <<-EOF
---
books:
  -
    name: Pocket詳解 CakePHP辞典
    isbn: 9784798027456
  -
    name: Ruby on Rails 4 アプリケーションプログラミング
    isbn: 9784774164106
  -
    name: パーフェクトPython
    isbn: 9784774155395
  -
    name: Rubyによるクローラー開発技法
    isbn: 9784797380354
  -
    name: Webアプリ開発を加速する CakePHP2定番レシピ119
    isbn: 9784798039510
branches:
  -
    name: 渋谷
  -
    name: 掛合
  -
    name: 松江
products:
  -
    m_book_id: 1
    m_branch_id: 1
  -
    m_book_id: 2
    m_branch_id: 2
  -
    m_book_id: 3
    m_branch_id: 3
  -
    m_book_id: 4
    m_branch_id: 1
  -
    m_book_id: 5
    m_branch_id: 1
EOF

yaml = YAML.load(data)
yaml["books"].each do |data|
  M::Book.create! name: data["name"], isbn: data["isbn"]
end
yaml["branches"].each do |data|
  M::Branch.create! name: data["name"]
end
yaml["products"].each do |data|
  Product.create! m_book_id: data["m_book_id"], m_branch_id: data["m_branch_id"]
end