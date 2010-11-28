# Webページに付与されたタグを表示

# ライブラリ読み込み
require 'open-uri'
require 'cgi'
require 'json'
require 'pp'

# 対象のWebページを指定
base_uri = "http://b.hatena.ne.jp/entry/jsonlite/?url="
target_uri = CGI.escape(ARGV[0] || "http://rubyonrails.org/")

# 当該Webページのタグを取得，集計
response = JSON.parse(open(base_uri + target_uri).read)
tags = response["bookmarks"].map{|bookmark| bookmark["tags"]}.flatten
results = tags.inject(Hash.new(0)) do |hash, key|
  hash[key] += 1
  hash
end.to_a

# タグを付与ユーザ数の降順でソート
results.sort! do |a, b|
  (b[1] <=> a[1]) * 2 + (a[0] <=> b[0])
end

# 結果表示
pp results
