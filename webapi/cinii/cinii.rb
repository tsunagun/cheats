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
require 'rdf'
require 'rdf/rdfxml'
require 'pp'

module CiNii
  class Article
    # id: http://ci.nii.ac.jp/naid/120003850974#article
    # naid: 120003850974
    # rdf_uri: http://ci.nii.ac.jp/naid/120003850974.rdf
    # detail_uri: http://ci.nii.ac.jp/naid/120003850974
    attr_accessor :id, :naid, :rdf_uri, :detail_uri, :title, :keywords, :authors, :publication
    def initialize(uri)
      @detail_uri = uri
      @rdf_uri = "#{detail_uri}.rdf"
      @id = "#{@detail_uri}#article"
      @naid = @detail_uri.split('/').last
      @graph = RDF::Graph.load(@rdf_uri)
      @title = get_title
      @keywords = get_keywords
      @authors = get_authors
      @publication = get_publication
    end

    def get_title
      query = RDF::Query.new({
        RDF::URI.new(@id) => {
          RDF::DC11.title => :title
        }
      })
      query.execute(@graph).first.title.to_s
    end

    def get_keywords
      query = RDF::Query.new({
        RDF::URI.new(@id) => {
          RDF::FOAF.topic => :topic
        },
        :topic => {
          RDF::DC11.title => :label
        }
      })
      keywords = query.execute(@graph).map do |solution|
        keyword = CiNii::Keyword.new
        keyword.uri = solution.topic.to_s
        keyword.label = solution.label.to_s
        keyword
      end
    end

    def get_authors
      query = RDF::Query.new({
        RDF::URI.new(@id) => {
          RDF::FOAF.maker => :author
        }
      })
      authors = query.execute(@graph).map do |solution|
        author = CiNii::Author.new
        author.uri = solution.author.to_s
        query2 = RDF::Query.new({
          RDF::URI.new(author.uri) => {
            RDF::FOAF.name => :name
          }
        })
        author.names = query2.execute(@graph).map do |solution2|
          solution2.name.to_s
        end
        author
      end
    end

    def get_publication
      query = RDF::Query.new({
        RDF::URI.new(@id) => {
          RDF::DC.isPartOf => :publication
        },
        :publication => {
          RDF::DC11.title => :title
        }
      })
      publication = CiNii::Publication.new
      solution = query.execute(@graph).first
      publication.uri = solution.publication.to_s
      publication.title = solution.title.to_s
      publication
    end
  end

  class Author
    attr_accessor :uri, :names
  end

  class Keyword
    attr_accessor :uri, :label
  end

  class Publication
    attr_accessor :uri, :title
  end
end

uri = "http://ci.nii.ac.jp/naid/120003850974"
uri = "http://ci.nii.ac.jp/naid/110008682472"
article = CiNii::Article.new(uri)
pp article
