# coding: UTF-8
# 入力語をfoaf:nameとして持つ実体の情報を出力する
# 利用例：
#   ruby query_ndla.rb "夏目漱石"
require 'uri'
require 'rdf'
require 'rdf/rdfxml'
require 'sparql/client'

endpoint_ndl = SPARQL::Client.new("http://id.ndl.go.jp/auth/ndla")
input = ARGV[0] || "夏目漱石"

query =<<-EOF
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rda: <http://RDVocab.info/ElementsGr2/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX xl: <http://www.w3.org/2008/05/skos-xl#>
PREFIX ndl: <http://ndl.go.jp/dcndl/terms/>
SELECT * WHERE {
?uri1 foaf:primaryTopic ?uri2.
?uri1 xl:prefLabel [ xl:literalForm ?heading; ndl:transcription ?yomi ].
?uri2 rda:dateOfBirth ?birth.
?uri2 rda:dateOfDeath ?death.
?uri2 foaf:name "#{input}".
FILTER (lang(?yomi) = 'ja-Kana').
}
EOF

p query

response = endpoint_ndl.query(query, {:content_type => "application/sparql-results+xml"})

response.each_solution do |solution|
  puts "#{solution.uri1} | #{solution.uri2} | #{solution.heading} | #{solution.yomi} | #{solution.birth} | #{solution.death}"
end
