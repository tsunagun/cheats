# coding: UTF-8
# コマンド引数としてNDLCを受け取り，ヒットした資料のシステム要件を一覧表示する．
# NDL Searchの仕様により，200件を超える資料がヒットした場合は200件までの資料を対象に表示する．
# Example
#   ruby ndl_search_with_ndlc.rb YA239
require 'open-uri'
require 'cgi'
require 'nokogiri'
require 'pp'
results = Hash.new(0)
base_uri = "http://iss.ndl.go.jp/api/sru?operation=searchRetrieve&recordPacking=xml&query="
ndlc = ARGV[0] || "YH237"
query = CGI.escape("ndlc=\"#{ndlc}\"")
response = open(base_uri + query).read
parser = Nokogiri::XML.parse(response)
parser.xpath("//xmlns:recordData", parser.namespaces).each_with_index do |record, index|
  record.xpath("./*/*[local-name()='description']").each do |description|
    if description.text =~ /^システム要件\ :\ /
      spec = description.text.gsub(/^システム要件\ :\ /, '')
      results[spec] += 1
    end
    #puts "#{index + 1}:  #{description.text}"
  end
end
sorted = results.to_a.sort do |a, b|
  b[1] <=> a[1]
end
pp sorted[0...10]
