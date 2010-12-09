# -*- coding: utf-8 -*-

# Google Books Data APIを使って書籍検索を行うスクリプト

class Google

  # ライブラリ読み込み
  require 'pp'
  require 'open-uri'
  require 'nokogiri'
  require 'cgi'

  # APIへのリクエストURLを生成する
  def self.make_request_url(query)
    base_uri = "http://books.google.com/books/feeds/volumes?"
    params = [
      "q=" + CGI.escape(query)
    ].join("&")
    url = base_uri + params
  end

  # 入力文字列の形態素解析結果を取得
  def self.get(input)
    entry_path = "/xmlns:feed/xmlns:entry"
    title_path = "dc:title"
    creator_path = "dc:creator"

    books = Array.new
    request_url = self.make_request_url(input)
    parser = Nokogiri::XML.parse(open(request_url).read)
    parser.xpath(entry_path, parser.namespaces).each do |entry|
      book = Hash.new do |hash, key| hash[key] = Array.new end
      entry.xpath(title_path, parser.namespaces).each do |title|
        book[:title] << title.text
      end
      entry.xpath(creator_path, parser.namespaces).each do |creator|
        book[:creator] << creator.text
      end
      books << book
    end
    books
  end

end

# queryの漢字変換候補を求める
query = ARGV[0] || "図書館情報学"
pp Google.get(query)
