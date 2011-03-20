# -*- coding: utf-8 -*-

# Google Books Data APIを使って書籍検索を行うスクリプト
# 参照URL
## http://code.google.com/intl/ja/apis/books/docs/gdata/developers_guide_protocol.html
## http://note.openvista.jp/2008/trying-google-book-search-api/

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

  # 入力文字列をクエリの一部として，書籍検索を行う
  def self.get(input)
    entry_path = "/xmlns:feed/xmlns:entry"
    title_path = "dc:title"
    creator_path = "dc:creator"
    isbn_path = "dc:identifier[contains(text(), 'ISBN:')]"

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
      entry.xpath(isbn_path, parser.namespaces).each do |isbn|
        book[:isbn] << isbn.text.gsub(/ISBN:/, "")
      end
      books << book
    end
    books
  end

end

# 書籍の検索結果を求める
query = ARGV[0] || "図書館情報学"
pp Google.get(query)
