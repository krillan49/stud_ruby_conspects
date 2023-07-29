# 6 kyu Unknown Amount of Missing Numbers in an Unordered Array. (Hardcore version)
require 'set'

def miss_nums_finder(arr)
  set=arr.to_set
  res=[]
  arr.each.with_index(1) do |_,n|
    res << n if !set.include?(n)
    break if res.size==10
  end
  res
end

arr3 = [9, 10, 7, 2, 11, 8, 1, 17, 6, 16, 18, 19, 15, 3, 13]
p miss_nums_finder(arr3) # [4, 5, 12, 14]

def miss_nums_finder(arr)
  stack = [0]
  arr.each{|n| stack[n] = n}
  res = []; size = 0
  stack.each_with_index do |n, i|
    if n == nil
      res << i
      size += 1
      break if size == 10
    end
  end
  res
end



puts
# 6 kyu Build a Trie  https://www.codewars.com/kata/5b65c47cbedf7b69ab00066e/train/ruby
def build_rec_helper(words)
  words.sort.slice_when{|a, b| a[0] != b[0]}.map do |arr|
    arr.size == 1 ? [arr[0], nil] : [arr[0], build_rec_helper(arr.select{|s| s.size > 1}.map{|s| s[1..-1]})]
  end#.flatten(1)
end

def build_trie(words)
  words = words.map{|w| (0...w.size).map{|i| w[0..i]}}.flatten.uniq
  build_rec_helper(words)
end

# p build_trie([]) #=> {}
# p build_trie([""]) #=> {}
p build_trie(["trie"]) #=> {"t" =>  {"tr" =>  {"tri" =>  {"trie" =>  nil}}}}
p build_trie(["tree"]) #=> {"t" =>  {"tr" =>  {"tre" =>  {"tree" =>  nil}}}}
p build_trie(["trie", "trie"]) #=> {"t" =>  {"tr" =>  {"tri" =>  {"trie" =>  nil}}}}
p build_trie(["A","to", "tea", "ted", "ten", "i", "in", "inn"]) #=> {"A" =>  nil, "t" =>  {"to" =>  nil, "te" =>  {"tea" =>  nil, "ted" =>  nil, "ten" =>  nil}}, "i" =>  {"in" =>  {"inn" =>  nil}}}
p build_trie(["true", "trust"]) #=> {"t" =>  {"tr" =>  {"tru" =>  {"true" =>  nil, "trus" =>  {"trust" =>  nil}}}}}
