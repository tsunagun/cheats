# coding: UTF-8
# 青空文庫の作品ページからメタデータを抽出するスクリプト
# 利用例：
#   ruby aozora_bunko_scraper.rb "http://www.aozora.gr.jp/cards/000020/files/2569_28291.html"

require 'open-uri'
require 'nokogiri'
require 'rdf'
require 'rdf/rdfxml'

uri = "http://www.aozora.gr.jp/cards/000020/files/2569_28291.html"
doc = open(uri).read
parser = Nokogiri::HTML.parse(doc)

ns = Hash.new
parser.xpath("//link[starts-with(@rel, 'Schema\.')]").each do |link|
  prefix = link.at_xpath("@rel").text.split(".").last
  base_uri = link.at_xpath("@href").text
  ns[prefix] = base_uri
end

graph = RDF::Graph.new
ns.each do |prefix, base_uri|
  parser.xpath("//meta[starts-with(@name, '#{prefix}')]").each do |meta|
    subject = RDF::URI.new(uri)
    predicate = RDF::URI.new(base_uri + meta.at_xpath("@name").text.split(".").last.downcase)
    object = RDF::Literal.new(meta.at_xpath("@content").text)
    meta.xpath("@lang").each do |lang|
      object.language = lang
    end
    graph << RDF::Statement.new(subject, predicate, object)
  end
end

graph.each_statement do |statement|
  p statement
end
