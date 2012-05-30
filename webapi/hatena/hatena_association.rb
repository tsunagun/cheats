# coding: UTF-8
# はてなキーワード連想語APIを使用するサンプルスクリプト
# 入力語と関連するはてなダイアリーキーワードを出力する
# 複数の入力語を与える場合は，半角空白で入力語をつなげる
# 例
#   ruby hatena_association.rb "メタデータ アーカイブ"

require "xmlrpc/client"
input = (ARGV[0] || "メタデータ").split("\ ")

server = XMLRPC::Client.new("d.hatena.ne.jp", "/xmlrpc")
result = server.call(
  "hatena.getSimilarWord",
  {"wordlist" => input}
)

puts result['wordlist'].map { |v| v['word'] }.join(', ')
