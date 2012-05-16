# -*- coding: utf-8 -*-
$KCODE = 'UTF-8'

# 楽天ブックス書籍検索APIを使って書籍検索を行うスクリプト
# 参照URL
## http://webservice.rakuten.co.jp/api/booksbooksearch/

class Rakuten

  # ライブラリ読み込み
  require 'rubygems'
  require 'pp'
  require 'open-uri'
  require 'nokogiri'
  require 'cgi'

  load "rakuten_id.txt"

  # APIへのリクエストURLを生成する
  def self.make_request_url(query)
    base_uri = "http://api.rakuten.co.jp/rws/3.0/rest?"
    params = [
      "developerId=" + RAKUTEN_DEVEL_ID,
      "operation=" + "BooksBookSearch",
      "version=" + "2011-01-27",
      "isbn=" + CGI.escape(query)
    ].join("&")
    url = base_uri + params
  end

  # 入力文字列をクエリの一部として，書籍検索を行う
  def self.get(input)
    item_path = "/Response/Body/*[local-name()='BooksBookSearch']/Items/Item"
    title_path = "title"
    creator_path = "author"
    isbn_path = "isbn"

    books = Array.new
    request_url = self.make_request_url(input)
		pp open(request_url).read
    parser = Nokogiri::XML.parse(open(request_url).read)
    parser.xpath(item_path).each do |item|
      book = Hash.new do |hash, key| hash[key] = Array.new end
      item.xpath(title_path).each do |title|
        book[:title] << title.text
      end
      item.xpath(creator_path).each do |creator|
        book[:creator] << creator.text
      end
      item.xpath(isbn_path).each do |isbn|
        book[:isbn] << isbn.text
      end
      books << book
    end
    books
  end

end

# 書籍の検索結果を求める
query = ARGV[0] || "9784051057558"
pp Rakuten.get(query)
