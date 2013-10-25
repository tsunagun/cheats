# coding: UTF-8
# MediaWiki記法のテキストをHTML文書に変換するスクリプト

require 'wikicloth'

file = 'wikitext.txt'
data = open(file).read
parser = WikiCloth::Parser.new({:data => data)
puts parser.to_html
