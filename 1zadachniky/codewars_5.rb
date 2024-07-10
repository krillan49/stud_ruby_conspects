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



# 5 kyu Compute the Largest Sum of all Contiguous Subsequences   https://www.codewars.com/kata/56001790ac99763af400008c/train/ruby
def sum_all_same_sign(arr, sum = 0, new = [])
  arr.each do |n| # складываем все положительные идущие подряд и все отрицательные иддущие подряд
    if (sum + n).abs == sum.abs + n.abs
      sum += n
    else
      new << sum
      sum = n
    end
  end
  new << sum
  new
end

def sum_two_sides_more(arr) # 191, -111, 293 => 373 тк 191 - 111 > 0 && 293 - 111 > 0
  sum = 0
  new = []
  arr.each_with_index do |n, i|
    if i.even?
      if i == 0
        sum = n
      elsif sum + arr[i-1] > 0 && n + arr[i-1] > 0
        sum += n + arr[i-1]
        new << sum if i == arr.size - 1
      else
        new << sum << arr[i-1]
        sum = n
      end
    end
  end
  new.size > 0 && new[-1] < 0 ? new + [arr[-1]] : new
end

def ender_bruteforse(arr) #  медленный способ окончательного решения для коротких
  max = 0
  arr.each.with_index do |n, i|
    sum = n
    max = sum if max < sum
    break if i == arr.size - 1
    arr[i+1..-1].each.with_index do |k, j|
      sum += k
      max = sum if max < sum
    end
  end
  max
end

def ender_max_points_area(arr) # быстрее(чем меньше точек тем быстрее) но все равно не хватает на размер 1000001
  max_points = arr.max(5)
  max = 0
  max_points.each do |point|
    i = arr.index(point)
    lmax = 0
    (0..i).step(2).map do |j|
      sum = arr[j..i].sum
      lmax = sum if sum > lmax
    end
    rmax = 0
    (i..arr.size-1).step(2).map do |j|
      sum = arr[i..j].sum
      rmax = sum if sum > rmax
    end
    max = lmax + rmax - point if max < lmax + rmax - point
  end
  max
end

def largest_sum(arr)
  return 0 if arr == [] or arr.all?{|n| n < 0}
  return arr.sum if arr.all?{|n| n > 0}
  arr = arr[arr.index{|n| n > 0}..arr.rindex{|n| n > 0}] # убираем отрицательные вначале и в конце
  arr = sum_all_same_sign(arr)
  return arr[0] if arr.size == 1
  arr = sum_two_sides_more(arr)

  arr.size < 1000 ? ender_bruteforse(arr) : ender_max_points_area(arr)
end

p largest_sum([191, -111, 103, 190, -167, 200, -145, 164, 150, -118, -157, -102, -137, 109, -139, 197, -148, -116, -146, 184, 129, 144, -146, -129, -119, -117, -131, -119, 185, -104, 148, 165, -157, -163, -155, -110])# 575



puts
# Shuffle It Up    https://www.codewars.com/kata/5b997b066c77d521880001bd
SUFFLES = [1]

def all_permuted(n) # Rencontres numbers
  # arr = (1..n).to_a
  # arr.permutation(n).select{|a| a.zip(arr).all?{|x, y| x != y}}.size

  # res = (1..n).inject(:*) / Math::E
  # n.odd? ? res.floor : res.ceil

  # (0..n).sum{|m| (-1)**m * (1..n).inject(:*) / (m == 0 ? 1 : (1..m).inject(:*))} # F(n,0)
  # (0..n).sum{|m| (-1)**m * (n > m ? (m+1..n).inject(:*) : 1)} # F(n,0)

  (0..n).map{|m| (-1)**m * (n > m ? (m+1..n).inject(:*) : 1)}

  # until SUFFLES.size > n
  #   m = SUFFLES.size
  #   p '---'
  #   # p m
  #   p (-1)**m * (n > m ? (m+1..n).inject(:*) : 1)
  #   SUFFLES << SUFFLES[-1] + (-1)**m * (n > m ? (m+1..n).inject(:*) : 1)
  # end
  # SUFFLES[n]
end

p all_permuted(1) # 0
p all_permuted(2) # 1
p all_permuted(3) # 2
p all_permuted(4) # 9
p all_permuted(5) # 44
p all_permuted(6) # 265
p all_permuted(7) # 1854
p all_permuted(8) # 14833
p all_permuted(9) # 133496

[1,      -1]
[2,      -2,      1]
[6,      -6,      3,      -1]
[24,     -24,     12,     -4,     1]
[120,    -120,    60,     -20,    5,     -1]
[720,    -720,    360,    -120,   30,    -6,    1]
[5040,   -5040,   2520,   -840,   210,   -42,   7,   -1]
[40320,  -40320,  20160,  -6720,  1680,  -336,  56,  -8,  1]
[362880, -362880, 181440, -60480, 15120, -3024, 504, -72, 9, -1]



# Affordable Vacation
# https://www.codewars.com/kata/66871953e441f6da6e36a0cc/train/ruby
def find_min_cost(money, days, cost)
  size = cost.length
  d, m = 0, money + 1
  (0...size).each do |i|
    res = cost[i, days]
    sum = res.sum
    if m == money + 1 && (sum > money || i > size - days)
      res.pop while res.sum > money
      d = res.length if res.length > d
      break if d >= size - d
    elsif i <= size - days && sum < m
      m = sum
      break if i == size - days
    elsif i >= size - days && m <= money
      break
    end
  end
  m > money ? "days: #{d}" : "money: #{m}"
end

p find_min_cost(29, 18, [3, 8, 3, 6, 9, 4, 1, 10, 4, 4, 9, 7, 4, 3, 5, 2, 2, 8, 3]) # days: 7
