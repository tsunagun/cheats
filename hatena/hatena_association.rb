# -*- coding: utf-8 -*-
require "xmlrpc/client"

server = XMLRPC::Client.new("d.hatena.ne.jp", "/xmlrpc")
result = server.call(
  "hatena.getSimilarWord",
  {"wordlist" => %w[ 御巣鷹山 ]}
)

puts result['wordlist'].map {|v| v['word'] }.join(', ')

