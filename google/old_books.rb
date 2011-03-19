# -*- coding: utf-8 -*-

# Google Books Data APIを使って書籍検索を行うスクリプト

class Google

  # ライブラリ読み込み
  require 'pp'
  require 'open-uri'
  require 'cgi'
  require 'rubygems'
  require 'nokogiri'

  # APIへのリクエストURLを生成する
  def self.make_request_url(query)
    base_uri = "http://books.google.com/books/feeds/volumes?"
    params = [
      "q=" + CGI.escape(query)
    ].join("&")
    url = base_uri + params
  end

  # 入力文字列をクエリの一部として，書籍検索を行う
  def self.get(input)
    entry_path = "/xmlns:feed/xmlns:entry"
    title_path = "dc:title"
    creator_path = "dc:creator"
    isbn_path = "dc:identifier[contains(text(), 'ISBN:')]"

    request_url = self.make_request_url(input)
    books = Array.new
    parser = Nokogiri::XML.parse(open(request_url).read)
    parser.xpath(entry_path, parser.namespaces).each do |entry|
      book = Hash.new
      book[:title] = entry.xpath(title_path, parser.namespaces).text
      book[:isbn] = entry.xpath(isbn_path, parser.namespaces).text.gsub(/^ISBN:/, "").gsub(/ISBN:/, ", ")
      books << book
    end
    books
  end

end

# queryの漢字変換候補を求める
query = ARGV[0] || "図書館情報学"
pp Google.get(query)
