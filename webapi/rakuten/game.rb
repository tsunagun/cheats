# coding: UTF-8

# 楽天ブックスゲーム検索APIを使ってゲーム検索を行うスクリプト
# 参照URL
## http://webservice.rakuten.co.jp/api/booksgamesearch/

class Rakuten

  # ライブラリ読み込み
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
      "operation=" + "BooksGameSearch",
      "version=" + "2011-12-01",
      "outOfStockFlag=" + "1",
      "title=" + CGI.escape(query)
    ].join("&")
    url = base_uri + params
  end

  # 入力文字列をクエリの一部として，ゲーム検索を行う
  def self.get(input)
    item_path = "/Response/Body/*[local-name()='BooksGameSearch']/Items/Item"
    title_path = "title"
    label_path = "label"
    hardware_path = "hardware"

    games = Array.new
    request_url = self.make_request_url(input)
		pp open(request_url).read
    parser = Nokogiri::XML.parse(open(request_url).read)
    parser.xpath(item_path).each do |item|
      game = Hash.new do |hash, key| hash[key] = Array.new end
      item.xpath(title_path).each do |title|
        game[:title] << title.text
      end
      item.xpath(label_path).each do |label|
        game[:label] << label.text
      end
      item.xpath(hardware_path).each do |hardware|
        game[:hardware] << hardware.text
      end
      games << game
    end
    games
  end

end

# ゲームの検索結果を求める
query = ARGV[0] || "マリオ"
pp Rakuten.get(query).size
