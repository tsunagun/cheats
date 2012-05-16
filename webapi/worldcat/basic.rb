# -*- coding: utf-8 -*-

# WorldCat Basic APIを使って書誌情報を検索するスクリプト

class WorldCat
  # ライブラリ読み込み
  require 'pp'
  require 'open-uri'
  require 'rss'
  require 'cgi'

  # WorldCat Basic APIのアプリケーションIDをworldcat_key.txtから読み込む
  load 'worldcat_key.txt'

  # APIへのリクエストURLを生成する
  def self.make_request_url(query)
    base_uri = "http://www.worldcat.org/webservices/catalog/search/opensearch?"
    params = [
      "wskey=" + WORLDCAT_KEY,
      "q=" + CGI.escape(query)
    ].join("&")
    url = base_uri + params
  end

  # 書誌情報を取得
  def self.get(input)
    request_url = self.make_request_url(input)
    parser = RSS::Parser.parse(open(request_url))
    books = parser.items.map do |book|
      result = Hash.new {|hash, key| hash[key] = Array.new}
      result[:title] = book.title.content
      result[:id] = book.id.content
      book.dc_identifiers.each do |identifier|
        result[:identifier] << identifier.content
      end
      result
    end
  end
end

# queryの漢字変換候補を求める
query = ARGV[0] || "library"
pp WorldCat.get(query)
