# coding: UTF-8
# Amazonの商品レビューページからレビュー本文を抽出するスクリプト
# 利用例：
#   ruby amazon_review_scraper.rb "http://www.amazon.co.jp/product-reviews/4915512630/"
require 'pp'
require 'nkf'
require 'open-uri'
require 'nokogiri'

uri = ARGV[0] || "http://www.amazon.co.jp/product-reviews/4915512630/"
sleep 2
doc = NKF.nkf('-w', open(uri).read)
parser = Nokogiri::HTML.parse(doc)
result = Array.new
parser.xpath("//table[@id='productReviews']//tr/td/div[@style='margin-left:0.5em;']").each do |r|
	review = ''
	r.xpath("text()").each do |s|
		review += s
	end
	result << review.gsub(/[\r\n]/, '').gsub(/　/, ' ').gsub(/\s\s+/, ' ')
end
pp result
