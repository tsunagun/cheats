# coding: UTF-8
#
# 文字列をUTF-8に変換する
#   NKF: 各種文字コード変換ライブラリ（日本語限定）
#   Kconv: NKFのラッパーライブラリ．Rubyに同梱
#   ICU: Unicode文字列を扱うためのライブラリ（判定可能なすべての言語が対象）
#   charlock_holmes: ICUのラッパーライブラリ．自分でインストールする必要あり
# 楽なのはNKF，正確なのはICU
#
# 文字コード変換は，1) 現在の文字コード判別，2) 指定した文字コードへ変換，という手順
# 
require 'charlock_holmes'
require 'kconv'
require 'open-uri'

class String
  def to_utf8 
    encode = CharlockHolmes::EncodingDetector.detect(self)[:encoding]
    self.encode("UTF-8", encode, :invalid=>:replace, :undef => :replace, :replace=>"?")
  end
end

uri = "http://www.asahi.com/national/update/1112/TKY201211120074.html"
string = open(uri).read.slice(/\<title\>.*\<\/title\>/)

# 文字コード判別
p Kconv.guess(string) # Kconv

p CharlockHolmes::EncodingDetector.detect(string)[:encoding] # CharlockHolmes

# 文字コード変換(UTF-8へ)
encode = CharlockHolmes::EncodingDetector.detect(string)[:encoding] # CharlockHolmes
p string.encode("UTF-8", encode, :invalid=>:replace, :undef => :replace, :replace=>"?") # Ruby同梱のString

p Kconv.kconv(string, Kconv::UTF8, Kconv.guess(string)) # Kconv
