# -*- coding: utf-8 -*-

# Yahoo Web APIを使って日本語形態素解析を行うスクリプト

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
    base_uri = "http://jlp.yahooapis.jp/MAService/V1/parse?"
    params = [
      "appid=" + YAHOO_KEY,
      "sentence=" + CGI.escape(query)
    ].join("&")
    url = base_uri + params
  end

  # 入力文字列の形態素解析結果を取得
  def self.parse(input)
    words_path = "/xmlns:ResultSet/xmlns:ma_result/xmlns:word_list/xmlns:word"
    surface_path = "xmlns:surface"
    reading_path = "xmlns:reading"
    pos_path = "xmlns:pos"
    baseform_path = "xmlns:baseform"
    feature_path = "xmlns:feature"

    request_url = self.make_request_url(input)
    parser = Nokogiri::XML(open(request_url))
    words = parser.xpath(words_path, parser.namespaces)
    words.map do |word|
      result = Hash.new {|hash, key| hash[key] = Array.new}
      word.xpath(surface_path).each do |surface|
        result[:surface] << surface.text
      end
      word.xpath(reading_path).each do |reading|
        result[:reading] << reading.text
      end
      word.xpath(pos_path).each do |pos|
        result[:pos] << pos.text
      end
      result
    end
  end

end

# queryの漢字変換候補を求める
query = ARGV[0] || "本日は晴天なり．"
pp Yahoo.parse(query)
