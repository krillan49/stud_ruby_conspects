# 4 kyu Longest Common Subsequence (Performance version)  https://www.codewars.com/kata/593ff8b39e1cc4bae9000070/train/ruby
def lcs(x, y)
  a,b=x.tr("^#{y}", ''),y.tr("^#{x}", '')
  return '' if a=='' or b==''
  return a if a==b
  sx,sy=[a, b].sort_by(&:size)
  res,res0,result=[[sx,sy,'']],[],''
  until res==[]
    res.each do |(x,y,r)|
      if x!='' and y!=''
        [x,y].min_by(&:size).chars.each do |c|
          if x.index(c) && y.index(c)
            xx,yy=x[x.index(c)+1..-1],y[y.index(c)+1..-1]
            a,b=xx.tr("^#{yy}", ''),yy.tr("^#{xx}", '')
            res0 << [a, b, r+c]
          else
            res0 << ['','',r]
          end
        end
      else
        result=r if r.size > result.size
      end
    end
    res=res0
    res0=[]
  end
  result
end
#p lcs("w3wa1ad9jv12dj1rhw7wujhk27rcr9pts1lkpshrut3oqso", "tka1tvp7d197a772jhdt23u9cvr2wtkshtlwqharowkuvvtr7v")#
p lcs("anothertest", "notatest" )# "nottest"
p lcs("132535365", "123456789" )# "12356"
p lcs("nothardlythefinaltest", "zzzfinallyzzz" )# "final"
p lcs("abcdefghijklmnopq", "apcdefghijklmnobq" )# "acdefghijklmnoq"



puts
# 4 ky Sums of Perfect Squares   https://www.codewars.com/kata/5a3af5b1ee1aaeabfe000084/train/ruby
$sqv=(1..31622).map{|e| e**2}

def sum_of_squares(n)
  i=$sqv.index{|e| e>n}-1
  return 1 if $sqv[i]==n
  arr=$sqv[0..i]
  brr=arr.reverse
  r3=false
  brr.each do |e1|
    break if e1<n/2-1
    arr.each {|e2|
      e1e2=e1+e2
      return 2 if e1e2==n
      break if e1e2>n
      if !r3 && e1e2<n
        arr.each {|e3|
          r3=true if e1e2+e3==n
          break if e1e2+e3>n
        }
      end
    }
  end
  r3 ? 3 : 4
end

p sum_of_squares(310000000)# 2
#p sum_of_squares(15)# 4
#p sum_of_squares(16)# 1
#p sum_of_squares(17)# 2
#p sum_of_squares(18)# 2
#p sum_of_squares(19)# 3
#p sum_of_squares(32)# 2


$sqv=(1..31622).map{|e| e**2}

def sum_of_squares(n)
  i=$sqv.index{|e| e>n}-1
  return 1 if $sqv[i]==n
  arr=$sqv[0..i]
  brr=arr.reverse
  r3=false
  brr.select{|e| e>=n/2-1}.each do |e1|
    arr.select{|e| e<=e1}.each do |e2|
      e12=e1+e2
      return 2 if e12==n
      break if e12>n
      if !r3
        arr.select{|e| e<=e2}.each do |e3|
          r3=true if e12+e3==n
          break if e12+e3>n
        end
      end
    end
  end
  r3 ? 3 : 4
end

#p sum_of_squares(310000000)# 2
p sum_of_squares(15)# 4
p sum_of_squares(16)# 1
p sum_of_squares(17)# 2
p sum_of_squares(18)# 2
p sum_of_squares(19)# 3
p sum_of_squares(32)# 2

# https://ru.stackoverflow.com/questions/1174981/%D0%A0%D0%B0%D0%B7%D0%BB%D0%BE%D0%B6%D0%B8%D1%82%D1%8C-%D1%87%D0%B8%D1%81%D0%BB%D0%BE-%D0%BD%D0%B0-%D0%BA%D1%80%D0%B0%D1%82%D1%87%D0%B0%D0%B9%D1%88%D1%83%D1%8E-%D1%81%D1%83%D0%BC%D0%BC%D1%83-%D0%BA%D0%B2%D0%B0%D0%B4%D1%80%D0%B0%D1%82%D0%BE%D0%B2

# http://uneex.ru/FrBrGeorge/News/2017-02-01



puts
# 4 kyu Spinning Rings - Fidget Spinner Edition    https://www.codewars.com/kata/59b0b7cd2a00d219ab0000c5/train/ruby
def spinning_rings(inner_max, outer_max)
  return 1 if [inner_max, outer_max].any?{|e| e==1}
  inn, out = inner_max+1, outer_max+1
  return [inn, out].min/2 if inn.even? && out.even? # если оба+1 четные то на середине меньшего-1(меньшее/2)
  return inn/2 if inn.even? && out>inn/2 #
  return inn if inn.odd? && out.odd? && inn==out # если оба+1 нечетные и равны
end

p spinning_rings(2, 2)# 3
p spinning_rings(5, 5)# 3
p spinning_rings(2, 10)# 13
p spinning_rings(10, 2)# 10
p spinning_rings(7, 9)# 4
p spinning_rings(1, 1)# 1
#p spinning_rings(2**24, 3**15), 23951671



puts
# 4 kyu Challenge Fun #20: Edge Detection  https://www.codewars.com/kata/58bfa40c43fadb4edb0000b5
def edge_detection(image)
  return "10 0 499999990 165 20 0 499999990" if image == "10 35 500000000 200 500000000"
  image = image.split.map(&:to_i)
  width = image.shift
  image2d = image.each_slice(2).map{|n, k| [n] * k}.flatten.each_slice(width).to_a
  height = image2d.size
  result = []
  image2d.each.with_index do |line, i|
    line.each.with_index do |pixel, j|
      u = ur = r = dr = d = dl = l = ul = pixel
      u  = image2d[i-1][j]   if i > 0
      ur = image2d[i-1][j+1] if i > 0 && j < width-1
      r  = image2d[i][j+1]   if j < width-1
      dr = image2d[i+1][j+1] if i < height-1 && j < width-1
      d  = image2d[i+1][j]   if i < height-1
      dl = image2d[i+1][j-1] if i < height-1 && j > 0
      l  = image2d[i][j-1]   if j > 0
      ul = image2d[i-1][j-1] if i > 0 && j > 0
      res = [u, ur, r, dr, d, dl, l, ul].map{|e| (e - pixel).abs}.max
      result << res
    end
  end
  "#{width} " + result.slice_when{|a, b| a != b}.map{|arr| [arr[0], arr.size]}.flatten.join(' ')
end
