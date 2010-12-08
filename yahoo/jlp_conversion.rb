# -*- coding: utf-8 -*-

# Yahoo Web APIを使ってかな漢字変換候補の提示を行うスクリプト

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
    base_uri = "http://jlp.yahooapis.jp/JIMService/V1/conversion?"
    params = [ 
      "appid=" + YAHOO_KEY,
      "sentence=" + CGI.escape(query),
      "response=" + "katakana",
      "format=" + "roman"
    ].join("&")
    url = base_uri + params
  end

  # 入力文字列の変換候補を取得
  def self.get_candidate_list(input)
    candidate_path = "/xmlns:ResultSet/xmlns:Result/xmlns:SegmentList/xmlns:Segment/xmlns:CandidateList/xmlns:Candidate"
    request_url = self.make_request_url(input)
    parser = Nokogiri::XML(open(request_url))
    candidate_list = parser.xpath(candidate_path, parser.namespaces)
    candidate_list.map do |candidate| candidate.text end
  end
end

# 漢字変換例1
query = ARGV[0] || "かいこう"
pp Yahoo.get_candidate_list(query)

# 漢字変換例2
query = ARGV[1] || "honnjituhaseitennnari"
pp Yahoo.get_candidate_list(query)
