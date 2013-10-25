require 'rdf'
require 'rdf/rdfxml'
require 'rdf/turtle'


# RDFのリソースやリテラルを作成する
# リソースはRDF::Resource.newで作成できる
# 一部の基本的な語彙は，RDF::DC.titleといった省略も可能
# 　これはRDF::Resource.new("http://purl.org/dc/terms/title")とほぼ同等
# リテラルはRDF::Literal.newで作成できる
subject = RDF::Resource.new("http://purl.org/net/sample")
predicate = RDF::DC.title
object = RDF::Literal.new("サンプルのタイトル")

# RDFトリプルを作成する
statement = RDF::Statement.new(subject, predicate, object)

# RDFトリプルを格納する空のグラフを作成する
graph = RDF::Graph.new

# RDFトリプルをグラフに格納する
graph << statement


puts graph.dump(:ntriples)
