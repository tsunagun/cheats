# coding: UTF-8

documents = [
  ["alpha", "bravo", "charley", "alpha", "charley", "alpha"],
  ["alpha", "bravo", "charley", "alpha"],
  ["alpha", "alpha", "alpha", "alpha", "bravo", "bravo", "bravo", "delta"]
]

class TfIdf
  attr_accessor :documents

  def initialize(documents)
    @documents = documents.map do |document|
      case document
      when instance_of?(Array)
        document
      when instance_of?(String)
        document.split(
      end
    end
  end

  def calculate_inverse_document_frequencies(documents)
    results = Hash.new
    documents.flatten.uniq.each do |term|
      results[term] = 0
    end
    results.each_key do |term|
      documents.each do |document|
        results[term] += 1 if document.include?(term)
      end
    end
  end

  def calculate_term_frequencies(terms)
    document_size = terms.size
    results = Hash.new{|hash, key| hash[key] = 0 }
    terms.each do |term|
      results[term] += 1
    end
    results.each_key do |term|
      results[term] /= document_size.to_f
    end
  end
end

p TfIdf.new.calculate_term_frequencies(documents[2])
p TfIdf.new.calculate_inverse_document_frequencies(documents)
