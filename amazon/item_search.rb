# -*- coding: utf-8 -*-
$KCODE = 'UTF-8'

# = Amazon Item Search
#
# Amazon Web ServiceのAPIを用いて，商品検索を行う．

# ライブラリ読み込み
require 'rubygems'
require 'cgi'
require "amazon/ecs"

# キー読み込み
load "amazon_key.txt"

# 指定した文字列で検索を行う
# item_searchでtypeを指定するとその項目を対象に検索．
# typeを指定しなければ項目を限定せずに検索．
def get_response(query, page)
  response = Amazon::Ecs.item_search(
    query,
    { :type => "title",
      :item_page => page,
      :response_group => "Medium",
      :sort => "daterank",
      :country => "jp",
      :search_index => "Books"
    }
  )
  response.has_error? ? false : response
end

# amazon/ecsの設定
Amazon::Ecs.configure do |options|
  options[:aWS_access_key_id] = AMAZON_ACCESS_KEY
  options[:aWS_secret_key] = AMAZON_SECRET_KEY
end

# 検索の設定
page = 1 # 検索結果のうち，ここで指定したページ番号から取得
query = ARGV[0] || "Ruby" # 検索に用いるクエリ
limit = 3 # 取得する最大ページ数
items = Array.new

# 検索開始
limit.times do
  sleep 1
  response = get_response(query, page)
  response ? items << response.items : break
  page += 1
end

# 結果表示
items.flatten.each do |item|
  title = item.get("itemattributes/title")
  title = CGI.unescapeHTML(title)
  puts title
end
