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



puts
# Champernowne's Championship  https://www.codewars.com/kata/5ac53c71376b11df7e0001a9/train/ruby
# Решена но какието баги в тестах
$champ.each.with_index{|a,i| i==0 ? $champ[i]=a+[a[1],a[2]] : $champ[i]=a+[$champ[i-1][4]+1, $champ[i-1][4]+a[0]]}

def champernowne_digit(n)
  p n
  return Float::NAN if n.class!=Integer or n<1
  return 0 if n==1
  k=n-1
  res=nil
  $champ.each do |digs,n1,n2,d1,d2|
    if k>=d1 && k<=d2
      r=(k-d1+1)/n2.to_s.size.to_f+('9'*(n2.to_s.size-1)).to_i
      p r
      p r.ceil.digits.reverse
      p r.ceil.to_s.size*(r-r.floor)
      p (r.ceil.to_s.size*(r-r.floor)).round
      p res=r.ceil.digits.reverse[(r.ceil.to_s.size*(r-r.floor)).round-1]
      break
      #return r.ceil.digits.reverse[(r.ceil.to_s.size*(r-r.floor)-1).round]
    end
  end
  p res
  res
end
