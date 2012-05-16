# -*- coding: utf-8 -*-

# Yahoo Web APIを使って関連検索ワードの取得を行うスクリプト

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
    base_uri = "http://search.yahooapis.jp/AssistSearchService/V1/webunitSearch?"
    params = [
      "appid=" + YAHOO_KEY,
      "query=" + CGI.escape(query)
    ].join("&")
    url = base_uri + params
  end

  # 入力文字列の形態素解析結果を取得
  def self.assistsearch(input)
    results_path = "/xmlns:ResultSet/xmlns:Result"

    request_url = self.make_request_url(input)
    parser = Nokogiri::XML(open(request_url))
    results = parser.xpath(results_path, parser.namespaces)
    results.map do |result| result.text end
  end

end

# queryの漢字変換候補を求める
query = ARGV[0] || "大学"
pp Yahoo.assistsearch(query)
