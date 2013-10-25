# coding: UTF-8
# Saxonを利用してXQueryを実行するサンプルプログラム
# saxon_pathは環境により異なる

input = ARGV[0] || 'input.xml'
query = ARGV[1] || "student_list/student/name"

result = `java -cp /usr/local/Cellar/saxon/9.4.0.6/libexec/saxon9he.jar net.sf.saxon.Query -s:#{input} -qs:#{query} -wrap !indent=yes`
puts "--- ここから ---", result, "--- ここまで ---"
