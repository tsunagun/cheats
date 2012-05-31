# coding: UTF-8
# 編集距離を求めるサンプルスクリプト
# String同士，Array同士，Hash同士などの編集距離を求める
# 例：
#   ruby levenshtein.rb

require 'levenshtein'

input1 = "デジタルアーカイブ"
input2 = "ディジタルアーカイブ"

# 編集距離を表示
p Levenshtein.distance(input1, input2)

# 編集距離を0から1の間で表示
# input1とinput2の長さを求め，より長い方の長さで編集距離を割る
p Levenshtein.normalized_distance(input1, input2)
