# coding: UTF-8
#   FizzBuzz
#   FizzBuzzを実行するプログラム．FizzBuzzについてはWikipediaなど参照．
#   引数に整数を与えると，それ以下の数値でFizzBuzzを実行．デフォルトは15．
#   例：
#     ruby fizzbuzz.rb 30
def fizzbuzz(max=15)
  max = max.to_i
  raise ArgumentError, "You have to input Fixnum more than zero." unless max > 0
  (1..max).each do |x|
    if x.fizzbuzz?
      puts "Fizz Buzz"
    elsif x.fizz?
      puts "Fizz"
    elsif x.buzz?
      puts "Buzz"
    else
      puts x.to_s
    end
  end
end

class Integer
  def fizz?
    self % 3 == 0
  end

  def buzz?
    self % 5 == 0
  end

  def fizzbuzz?
    self.fizz? & self.buzz?
  end
end

if ARGV[0]
  fizzbuzz(ARGV[0])
else
  fizzbuzz
end
