# coding: UTF-8
#
# 概要
#   gem 'classifier' を使ったベイズ分類
#
# 実行例：
#   ruby classifier_test.rb
#
# 参照：
#   http://tobysoft.net/wiki/index.php?Ruby%2F%A5%D9%A5%A4%A5%B8%A5%A2%A5%F3%A5%D5%A5%A3%A5%EB%A5%BF#k51f93c4
require 'classifier'
require 'stemmer'

# 分類を設定
bayes = Classifier::Bayes.new('mac', 'windows')

# 学習データ投入
# Classifier::Bayes#trainは，第2引数の文書を第1引数の分類として学習させる
bayes.train('mac', 'How do I customize my iPod settings?')
bayes.train('mac', 'How do I set up an AirPort wireless network?')
bayes.train('mac', 'How do I set up Mac OS X Mail?')
bayes.train('windows', 'You must be running Microsoft Internet Explorer 5 or later.')
bayes.train('windows', 'You can obtain updates from the Microsoft Download Center.')
bayes.train('windows', 'Get Office Live Basics for your business today.')

# 分類したい文書document1
document1 = 'How do I sync audio and video to my iPod?'

# 文書document1が各分類(mac, windows)に該当する確率を表示
puts bayes.classifications(comment).inspect

# 文書document1の分類先を表示
puts bayes.classify(comment)
