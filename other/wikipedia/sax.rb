# coding: UTF-8
# Saxを利用してXMLファイルから値を抽出するスクリプト
require 'nokogiri'

file = 'sample.xml'

class Article
  attr_accessor :title, :isbn, :keywords
  def initialize
    @keywords = Array.new
  end
end

class MyDocument < Nokogiri::XML::SAX::Document
  def initialize
    @mode = Array.new
  end

  def start_element name, attrs = []
    case name
    when "item"
      puts "#{name} started!"
      @article = Article.new
    end
    @mode << name.to_sym
  end

  def end_element name
    case name
    when "item"
      p @article
      puts "#{name} ended"
    end
    @mode.pop
  end

  def characters string
    case @mode.last
    when :title
      @article.title = string if @mode.last(2) == [:item, :title]
    when :isbn
      @article.isbn = string
    when :keyword
      @article.keywords << string if @mode.last(2) == [:keywords, :keyword]
    end
  end
end

parser = Nokogiri::XML::SAX::Parser.new(MyDocument.new)
parser.parse_file(file)
