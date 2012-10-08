$KCODE = 'UTF-8'
require 'rubygems'
require 'rdf'
require 'rdf/rdfxml'
require 'sparql/client'
require 'cgi'
require 'open-uri'

module SPARQL
	class Client
		class Query < RDF::Query
			def serialize_value(value)
				case
				when value.variable? then value.to_s
				when value.class == RDF::Literal then "\"#{value.to_s}\""
				else RDF::NTriples.serialize(value)
				end
			end
		end
	end
end

endpoint = "http://133.51.7.205:8080/openrdf-sesame/repositories/webmd"
sparql = SPARQL::Client.new(endpoint)

s = RDF::URI.new("http://id.ndl.go.jp/auth/ndlna/00054222")
o = RDF::Literal.new("山田太郎")
query = sparql.construct([:s, :p, :o]).where([:s, :p, :o])
request_uri = endpoint + "?query=" + CGI.escape(query.to_s)
response = open(request_uri).read

RDF::Reader.for(:rdfxml).new(response) do |reader|
	reader.each_statement do |statement|
		puts statement.to_s
	end
end
