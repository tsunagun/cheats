# -*- coding: utf-8 -*-
$KCODE = 'UTF-8'

require 'pp'
require 'cgi'
require 'open-uri'
require 'rubygems'
require 'nokogiri'

class Porta
	#@@porta_base_url = "http://iss.ndl.go.jp/api/sru?"
  @@porta_base_url = "http://api.porta.ndl.go.jp/servicedp/SRUDp?"

  # 入力文字列をクエリの一部として，書籍検索を行う
	def self.get_response(keywords)
		query = [
      "dpgroupid=" + "ndl",
      "anywhere=" + "\"#{keywords}\"",
      "sortBy=" + "\"issued_date/sort.descending\""
    ].join(" AND ")
    par = [
      "operation=" + "searchRetrieve",
      "maximumRecords=30",
      "recordPacking=" + "xml",
      "recordSchema=" + "dcndl_porta",
      "query=" + CGI.escape(query)
    ].join("&")
		url = @@porta_base_url + par
		open(url).read
	end

  # DOM Treeから書誌情報の配列を生成する
	def self.get_bibs(parser)
		record_path = "//xmlns:recordData/*[local-name()='dc']"
		title_path = "dc:title"
    creator_path = "dc:creator"
    isbn_path = "dc:identifier[@xsi:type='dcndl:ISBN']"
		books = Array.new
		parser.xpath(record_path, parser.namespaces).each do |record|
      book = Hash.new do |hash, key| hash[key] = Array.new end
			record.xpath(title_path, record.namespaces).each do |title|
				book[:title] << title.text
      end
			record.xpath(creator_path, record.namespaces).each do |creator|
				book[:creator] << creator.text
      end
			record.xpath(isbn_path, record.namespaces).each do |isbn|
				book[:isbn] << isbn.text
      end
			books << book
    end
		return books
	end
end


keywords = ARGV[0] || "Semantic Web"
response = Porta.get_response(keywords)
parser = Nokogiri::XML(response)
bibs = Porta.get_bibs(parser)
pp bibs
