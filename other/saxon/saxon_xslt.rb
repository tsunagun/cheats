# coding: UTF-8
# Saxonを利用してXSLTスタイルシートを適用するサンプルプログラム
# saxon_pathは環境により異なる

input = ARGV[0] || 'input.xml'
query = ARGV[1] || 'stylesheet.xsl'
saxon_path = "/usr/local/Cellar/saxon/9.4.0.6/libexec/saxon9he.jar"

result = `java -cp #{saxon_path} net.sf.saxon.Transform -s:#{input} -xsl:#{query}`
puts "--- ここから ---", result, "--- ここまで ---"
