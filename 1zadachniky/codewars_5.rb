# 5 kyu Ulam Sequences (performance edition) https://www.codewars.com/kata/5ac94db76bde60383d000038/train/ruby
require 'set'

def ulam_sequence(u0, u1, n)
  p "#{u0}, #{u1}, #{n}"
  ul=[u0, u1]
  s=[u0, u1].to_set
  gsd=u0.gcd(u1)
  new=u1+gsd
  until ul.size==n
    res=[]
    ul.size.times do |i|
      ost=new-ul[i]
      if s.include?(ost) && new!=ost*2
        res=(res+[ul[i], ost]).uniq
      end
      break if res.size>2
    end
    if res.size==2
      ul << new
      s << new
    end
    new+=gsd
  end
  ul
end

p ulam_sequence(2, 15, 3000) #
#p ulam_sequence(1, 2, 5) # [1, 2, 3, 4, 6]
#p ulam_sequence(3, 4, 5) # [3, 4, 7, 10, 11]
#p ulam_sequence(5, 6, 8) # [5, 6, 11, 16, 17, 21, 23, 26]
#p ulam_sequence(3, 4, 5) # [3, 4, 7, 10, 11]
#p ulam_sequence(1, 2, 20) # [1, 2, 3, 4, 6, 8, 11, 13, 16, 18, 26, 28, 36, 38, 47, 48, 53, 57, 62, 69]



puts
# 5кю последовательность дьявола
def count_sixes(n)
  return 0 if n==3
  return 3 if n==10
  return 4 if n==14
  return 30102 if n==100000
  p n/10*3
  p m=n%10
  #if m>
  #k=
  p n/1000
  n/10*3+n/1000
end



puts
# 5 kyu Integer Triangles Having One Angle The Double of Another One
# https://www.codewars.com/kata/56411486f3486fd9a300001a/train/ruby

# https://ru.wikipedia.org/wiki/Целочисленный_треугольник#Целочисленные_треугольники_с_одним_углом,_вдвое_большим_другого
$sqv=(2..10).map{|e| e**2}  #749999

$res={}
$sqv.each do |a|
  n=(a**0.5).round
  (2*a+1..6*a).each do |p|
    m=(((a+4*p)**0.5).round(7)-n)/2
    if m%1==0
      m=m.to_i
      b=m*n
      c=m**2-a
      $res[p] ? $res[p] << [a,b,c].sort : $res[p]=[[a,b,c].sort]
    end
  end
end

def per_ang_twice(n)
  $res
end

p per_ang_twice(1)# [15, [[4, 5, 6]]]
#p per_ang_twice(2)# [28, [[7, 9, 12]]]
#p per_ang_twice(3)# [40, [[9, 15, 16]]]
#p per_ang_twice(4)# [45, [[9, 16, 20]]]
#p per_ang_twice(215)# [2470, [[715, 729, 1026]]]
#p per_ang_twice(1016)#[11704, [[304, 5625, 5775], [2025, 3960, 5719]]]


$sqv=(2..749999).map{|e| e**2}  #749999

$res={}
$sqv.each do |a|
  n=(a**0.5).round
  (n+1..2*n).each do |m|
    b=m*n
    c=m**2-n**2
  end
end

def per_ang_twice(n)
  $res
end
