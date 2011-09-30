# -*- coding: UTF-8 -*-
$KCODE = 'UTF-8'
require 'rubygems'
require 'nokogiri'
require 'cgi'
require 'open-uri'

word = "鶴岡八幡宮"
esc_word = CGI.escape(word)
url = "http://ja.wikipedia.org/wiki/" + esc_word
doc = open(url)
parser = Nokogiri::HTML.parse(doc)
image_url = parser.at_xpath("//table[@class='infobox']//img/@src").text
p image_url
