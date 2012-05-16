# coding: UTF-8
#
# 概要：
#   gem 'classifier' と日本語形態素解析器MeCabを使用したベイズ分類
#   事前にMeCabのインストールが必要
#
# 実行例：
#   ruby mecab_classifier_test.rb
#
# 参照：
#   http://tobysoft.net/wiki/index.php?Ruby%2F%A5%D9%A5%A4%A5%B8%A5%A2%A5%F3%A5%D5%A5%A3%A5%EB%A5%BF#k51f93c4

require 'classifier'
require 'stemmer'
require 'MeCab'

# 分類を設定
bayes = Classifier::Bayes.new('mac', 'windows')

# MeCabを分かち書きモードで用意
wakati = MeCab::Tagger.new('-O wakati')

# 学習データを登録するメソッド
# 文書の分かち書きを行ってから学習データを登録する
def train(bayes, wakati, category, text)
  parsed = wakati.parse(text)
  bayes.train(category, parsed)
end

# 学習データ投入
train(bayes, wakati, 'mac', 'iPodの設定はどのように変更したら良いですか．')
train(bayes, wakati, 'mac', 'AirPortの無線ネットワークはどうやって設定しますか．')
train(bayes, wakati, 'mac', 'MacOSXのMailはどうやって設定しますか．')
train(bayes, wakati, 'windows', 'Internet Explorer 5以降を実行しておく必要があります．')
train(bayes, wakati, 'windows', 'マイクロソフトダウンロードセンターからアップデートを取できます．')
train(bayes, wakati, 'windows', '今の仕事のためにオフィスライブベーシックを手に入れよう．')

# 分類したい文書document1
document1 = 'この書類を開くにはマイクロソフトオフィスが必要です．'
parsed = wakati.parse(comment)

# 文書document1が各分類(mac, windows)に該当する確率を表示
puts bayes.classifications(parsed).inspect

# 文書document1の分類先を表示
puts bayes.classify(wakati.parse())
