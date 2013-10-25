# coding: UTF-8
require 'open-uri'
require 'nokogiri'
require 'pp'

uri = "http://ja.wikipedia.org/wiki/Wikipedia:%E3%82%A6%E3%82%A3%E3%82%AD%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88_%E6%BC%AB%E7%94%BB%E5%AE%B6/%E6%97%A5%E6%9C%AC%E3%81%AE%E6%BC%AB%E7%94%BB%E5%AE%B6_%E3%81%8B%E8%A1%8C"
uri = "http://ja.wikipedia.org/wiki/Wikipedia:%E3%82%A6%E3%82%A3%E3%82%AD%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88_%E6%BC%AB%E7%94%BB%E5%AE%B6/%E6%97%A5%E6%9C%AC%E3%81%AE%E6%BC%AB%E7%94%BB%E5%AE%B6_%E3%81%BE%E8%A1%8C"

uri = "http://ja.wikipedia.org/wiki/Wikipedia:%E3%82%A6%E3%82%A3%E3%82%AD%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88_%E6%BC%AB%E7%94%BB%E5%AE%B6/%E6%97%A5%E6%9C%AC%E3%81%AE%E6%BC%AB%E7%94%BB%E5%AE%B6_%E3%81%82%E8%A1%8C"
# ファイル取ってくる
html = open(uri).read

# ファイル解析
parser = Nokogiri::HTML(html)

def get_value(node)
  case node.name
  when "p"
    return "解説： " + node.text
  when "ul"
    result = Hash.new
    node.xpath("li").each do |x|
      if x.text =~ /.*(リスト|作品).*/
        result[:comics] = Array.new
        x.xpath('ul/li').each do |comic|
          comic.text.split("\n").each do |y|
            result[:comics] << y.gsub(/(（|「|\().*$/, '').gsub(/\s全[0-9]+巻.*$/, '')
          end
        end
        pp result
      end
    end
    return "作品： "
  when "hr"
    return false
  when "h2"
    return false
  else
    return ""
  end
end

# XPathで値取る
parser.xpath("//h3").each do |h3|
  puts "------------"
  puts "名前： " + h3.at_xpath("span[@class='mw-headline']").text
  node = h3.next_sibling
  loop do
    x = get_value(node)
    puts x unless x == ""
    break if x == false
    node = node.next_sibling
  end
  puts "------------"
end
