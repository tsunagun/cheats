# coding: UTF-8
#
# 概要：
#   任意の検索語で論文を集め，それらのキーワードを一覧表示する．
#
# 実行例：
#   ruby cinii.rb "杉本重雄"

require 'cgi'
require 'open-uri'
require 'nokogiri'

module CiNii
  @@query_base_url = "http://ci.nii.ac.jp/opensearch/search?"

  class Article
    attr_accessor :uri, :title, :authors, :keywords

    def initialize(uri)
      @uri = uri
      parser = Nokogiri::HTML.parse(open(uri).read)
      @
    end
    # CiNiiに送信する論文検索クエリを生成するメソッド。
    def self.make_request_url(input)
      query = "q=" + CGI.escape(input)
      format = "format=" + "rss"
      "#{@@query_base_url}#{query}&#{format}"
    end

    def find(input)
      request_uri = make_request_uri(input)
    end
  end

  class Keyword
    attr_accessor :uri, :label
  end


  # Nokogiriオブジェクトから各論文詳細情報のRDFへのリンクを取得するメソッド．
  # 出力形式はRDFへのリンク(string型)の配列．
  def self.find(input)
    request_url = self.make_request_url(input)
    parser = Nokogiri::XML.parse(open(request_uri).read)
    item_path = "rdf:RDF/xmlns:item"
    rdfs_seeAlso_path = "rdfs:seeAlso"
    rdf_links = Array.new
    parser.xpath(item_path, parser.namespaces).map{|item|
      item.xpath(rdfs_seeAlso_path, item.namespaces).map{|rdf_link|
        rdf_links << rdf_link["resource"]
      }
    }
    return rdf_links
  end

  # RDFへのリンクから、当該論文のキーワードを取得する
  # 出力形式はキーワード(string型)の配列
  def self.get_keywords(rdf_link)
    rdf_description_path = "rdf:RDF/rdf:Description"
    topic_path = "foaf:topic"
    doc = open(rdf_link).read
    parser = Nokogiri::XML.parse(doc)
    keywords = parser.xpath(rdf_description_path, parser.namespaces).map{|description|
      description.xpath(topic_path, parser.namespaces).map{|keyword|
        CGI.unescape(keyword["resource"]).gsub(/http:\/\/ci.nii.ac.jp\/keyword\//, "")
      }
    }
    return keywords
  end
end

# 検索語の設定
input = ARGV[0] || "杉本重雄"

rdf_links = CiNii.get_rdf_links(input)

keywords = rdf_links.map do |rdf_link|
  CiNii.get_keywords(rdf_link)
end.flatten.uniq

keywords.each do |keyword|
  puts keyword.inspect
end


articles = CiNii::Article.find_by_author(input)
