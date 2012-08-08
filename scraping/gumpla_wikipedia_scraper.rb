# encoding: UTF-8
require 'uri'
require 'open-uri'
require 'nokogiri'

class Gunpla
	attr_accessor :name, :date, :price
end

uri = "http://ja.wikipedia.org/wiki/マスターグレード"
p URI.escape(uri)
doc = open(URI.escape(uri)).read
parser = Nokogiri::HTML.parse(doc)
xpath = "//ol[following-sibling::h3[span='アニメーションカラーバージョン']]/li"
parser.xpath(xpath).each do |item|
	gunpla = Gunpla.new
	gunpla.name = item.text.gsub(/（[0-9]+年.+?）/, '').gsub(/[0-9]+円/, '').gsub(/\[.+\]/, '').match(/^.+/)[0].strip.chomp
	gunpla.date = item.text.match(/([0-9]+)年([0-9]+)月/) do |x| "#{x[1]}/x[2]}" end
	gunpla.price = item.text.match(/([0-9]+)円/)[1]
	p gunpla
end
