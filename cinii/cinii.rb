# -*- encoding: UTF-8 -*-
$KCODE = 'UTF-8'

# 必要なライブラリを読み込む
# 事前にgemのnokogiriをインストールしておくこと
require 'cgi'
require 'open-uri'
require 'rubygems'
require 'nokogiri'

class Cinii
  @@query_base_url = "http://ci.nii.ac.jp/opensearch/search?"

  # CiNiiに送信する論文検索クエリを生成するメソッド。
  def self.make_request_url(input)
    query = "q=" + CGI.escape(input)
    format = "format=" + "rss"
    @@query_base_url + query + "&" + format
  end

  # Nokogiriオブジェクトから各論文詳細情報のRDFへのリンクを取得するメソッド。
  # 出力形式はRDFへのリンク(string型)の配列
  def self.get_rdf_links(input)
    request_url = self.make_request_url(input)
    doc = open(request_url).read
    parser = Nokogiri::XML.parse(doc)
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


rdf_links = Cinii.get_rdf_links("杉本重雄")

keywords = rdf_links.map{|rdf_link|
  Cinii.get_keywords(rdf_link)
}.flatten.uniq

keywords.each{|keyword|
  puts keyword.inspect
}
