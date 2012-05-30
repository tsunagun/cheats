# coding: UTF-8
# はてなブックマークAPIを利用したサンプルスクリプト
# 入力されたURLに付与されたはてなブックマークタグを表示する
# 例
#   ruby hatena_bookmark.rb "http://www.mi3.or.jp/"

# ライブラリ読み込み
require 'open-uri'
require 'cgi'
require 'json'
require 'pp'

# 対象のWebページを指定
base_uri = "http://b.hatena.ne.jp/entry/jsonlite/?url="
target_uri = CGI.escape(ARGV[0] || "http://www.mi3.or.jp/")

# 当該Webページのタグを取得，集計
response = JSON.parse(open(base_uri + target_uri).read)
tags = response["bookmarks"].map{|bookmark| bookmark["tags"]}.flatten
counter = Hash.new(0)
tags.each do |tag|
  counter[tag] += 1
end
results = counter.to_a

# タグを付与ユーザ数の降順でソート
results.sort! do |a, b|
  (b[1] <=> a[1]) * 2 + (a[0] <=> b[0])
end

# 結果表示
pp results
