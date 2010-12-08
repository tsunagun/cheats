# -*- coding: utf-8 -*-

# Yahoo Web APIを使ってWeb検索を行うスクリプト

class Yahoo

  # ライブラリ読み込み
  require 'pp'
  require 'open-uri'
  require 'nokogiri'
  require 'cgi'

  # Yahoo Web APIのアプリケーションIDをyahoo_key.txtから読み込む
  load 'yahoo_key.txt'

  # APIへのリクエストURLを生成する
  def self.make_request_url(query)
    base_uri = "http://search.yahooapis.jp/WebSearchService/V2/webSearch?"
    params = [
      "appid=" + YAHOO_KEY,
      "query=" + CGI.escape(query)
    ].join("&")
    url = base_uri + params
  end

  # 入力文字列の形態素解析結果を取得
  def self.parse(input)
    sites_path = "/xmlns:ResultSet/xmlns:Result"
    title_path = "xmlns:Title"
    summary_path = "xmlns:Summary"
    url_path = "xmlns:Url"
    clickurl_path = "xmlns:ClickUrl"
    modificationdate_path = "xmlns:ModificationData"

    request_url = self.make_request_url(input)
    parser = Nokogiri::XML(open(request_url))
    sites = parser.xpath(sites_path, parser.namespaces)
    sites.map do |site|
      result = Hash.new {|hash, key| hash[key] = Array.new}
      site.xpath(title_path).each do |title|
        result[:title] << title.text
      end
      site.xpath(summary_path).each do |summary|
        result[:summary] << summary.text
      end
      site.xpath(url_path).each do |url|
        result[:url] << url.text
      end
      site.xpath(clickurl_path).each do |clickurl|
        result[:clickurl] << clickurl.text
      end
      site.xpath(modificationdate_path).each do |modificationdate|
        result[:modificationdate] << modificationdate.text
      end
      result
    end
  end

end

# queryの漢字変換候補を求める
query = ARGV[0] || "図書館情報学"
pp Yahoo.parse(query)
