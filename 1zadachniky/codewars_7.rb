# 7кю новая ката
def alphabet(ns)
  p ns
  ns.combination(4).each{|arr|
    arr=arr.sort
    brr=arr.each_cons(2).to_a
    return arr[-1] if (arr+brr.map{|a| a.inject(:*)}+[arr[0]*arr[-1]]).sort==ns.sort
  }
  nil
end

p alphabet([645, 229, 478, 381, 527, 606, 356, 417]) # 4
#p alphabet([2, 6, 7, 3, 14, 35, 15, 5]) # 7
#p alphabet([20, 10, 6, 5, 4, 3, 2, 12]) # 5
#p alphabet([2, 6, 18, 3, 6, 7, 42, 14]) # 7
#p alphabet([7, 96, 8, 240, 12, 140, 20, 56]) # 20
#p alphabet([20, 30, 6, 7, 4, 42, 28, 5]) # 7
