# coding: UTF-8
#
# 概要：
#   Wikipediaの漫画レーベル一覧を整形して出力するスクリプト
# 
# 実行例：
#   ruby manga_label_list.rb

require 'open-uri'
require 'nokogiri'
require 'pp'

# 漫画レーベルを表すクラス
# 漫画レーベルは名前(name)を持つ
class Label
  attr_accessor :name
end

# 出版社を表すクラス
# 出版社は名前(name)とレーベル(labels)を持つ
# labelsは漫画レーベルクラスのインスタンスを要素とする配列
class Publisher
  attr_accessor :name, :labels
end


# 出版社リスト
publishers = Array.new

# Wikipediaの漫画レーベル一覧ページのURI
uri = "http://ja.wikipedia.org/wiki/%E6%BC%AB%E7%94%BB%E3%83%AC%E3%83%BC%E3%83%99%E3%83%AB%E4%B8%80%E8%A6%A7"

# 漫画レーベル一覧ページの解析開始
parser = Nokogiri::XML.parse(open(uri).read)
xpath = "//xmlns:div[@id='mw-content-text']/xmlns:ul[preceding-sibling::xmlns:h3]/xmlns:li"
parser.xpath(xpath, parser.namespaces).each do |list|
  # 出版社情報を取得開始
  publisher = Publisher.new

  # 出版社情報に出版社名を追加
  publisher.name = list.at_xpath('xmlns:a/@title').text
    .gsub(/（存在しないページ）/, '')
    .gsub(/ (出版社)/, '')
    .gsub(//, '')

  # 出版社情報にレーベル情報を追加
  publisher.labels = list.xpath('xmlns:ul/xmlns:li').map do |y|
    label = Label.new
    label.name = y.text
    label
  end

  # 出版社情報を出版社リストに追加
  publishers << publisher
end

pp publishers
