# -*- coding: UTF-8 -*-
# WikipediaAPIを利用して，キーワードと関連する語を取得する
# 参照：http://wikipedia-lab.org/ja/index.php/Wikipedia_API
require 'soap/wsdlDriver'

keyword = ARGV[0] || "図書館"

# SOAPアクセスの前準備
wsdl = "http://dev.wikipedia-lab.org/WikipediaOntologyAPIv3/Service.asmx?WSDL"
serv = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
serv.generate_explicit_type = true

# クエリ実行
# キーワードのIDを取得する
entry = serv.GetTopCandidateIDFromKeyword(:Keyword => keyword, :language => "Japanese")
id = entry.getTopCandidateIDFromKeywordResult

# 取得したIDを元に，関連する語を取得する
entry = serv.GetThesaurusDS(:iType => 0, :iFrom => id, :iOffset => 0, :language => "Japanese")
entry.getThesaurusDSResult.diffgram.newDataSet.table.each do |t|
	puts t.name
end
