require 'soap/wsdlDriver'
require 'pp'

wsdl = "http://dev.wikipedia-lab.org/WikipediaOntologyAPIv3/Service.asmx?WSDL"
serv = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
serv.generate_explicit_type = true

entry = serv.GetTopCandidateIDFromKeyword(:Keyword => "Microsoft", :language => "Japanese")
iID = entry.getTopCandidateIDFromKeywordResult

entry = serv.GetThesaurusDS(:iType => 0, :iFrom => iID, :iOffset => 0, :language => "Japanese")
entry.getThesaurusDSResult.diffgram.newDataSet.table.each do |t|
  puts t.name
end
