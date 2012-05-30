# coding: UTF-8
# コマンド引数としてNDLCを受け取り，ヒットした資料のタイトルを一覧表示する．
# NDL Searchの仕様により，200件を超える資料がヒットした場合は200件までを表示する．
# Example
#   ruby ndl_search_with_ndlc.rb YA239
require 'open-uri'
require 'cgi'
require 'nokogiri'
base_uri = "http://iss.ndl.go.jp/api/sru?operation=searchRetrieve&recordPacking=xml&query="
ndlc = ARGV[0] || "YH237"
query = CGI.escape("ndlc=\"#{ndlc}\"")
response = open(base_uri + query).read
parser = Nokogiri::XML.parse(response)
parser.xpath("//xmlns:recordData", parser.namespaces).each_with_index do |record, index|
  record.xpath("./*/*[local-name()='title']").each do |title|
    puts "#{index + 1}:  #{title.text}"
  end
end
