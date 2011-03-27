# -*- coding: utf-8 -*-
require 'pp'
require 'cgi'
require 'open-uri'
require 'nokogiri'

class Loc
  @@base_url = "http://z3950.loc.gov:7090/voyager?"

  # 入力文字列をクエリの一部として書籍検索を行う
  def self.get_response(input)
    query = CGI.escape("\"" + input + "\"")
    par = [
      'operation='      + 'searchRetrieve',
      'version='        + '1.1',
      'recordPacking='  + 'xml',
      'recordSchema='   + 'dc',
      'maximumRecords=' + '10',
      'query='          + query
    ]
    url = @@base_url + par.join('&')
    return open(url).read
  end

  # DOM Treeを受け取り，書誌情報の配列を生成する
  def self.get_bibs(parser)
    bib_path = '//zs:recordData/*[local-name()="dc"]'
    title_path = 'xmlns:title'
    identifier_path = 'xmlns:identifier'
    identifier_path = 'xmlns:identifier[starts-with(., "http")]'
    bibliographies = Array.new
    parser.xpath(bib_path, parser.namespaces).map do |bib|
      bibliography = Hash.new
      bibliography[:title] = bib.xpath(title_path, bib.namespaces).first.text
      bibliography[:identifier] = bib.xpath(identifier_path, bib.namespaces).map do |id|
        id.text
      end
      bibliographies << bibliography
    end
    bibliographies
  end
end


keyword = ARGV[0] || "semantic web"
response = Loc.get_response(keyword)
parser = Nokogiri::XML(response)
bibs = Loc.get_bibs(parser)
pp bibs
