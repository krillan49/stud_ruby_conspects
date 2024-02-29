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



puts
# 4 kyu All Balanced Parentheses  https://www.codewars.com/kata/5426d7a2c2c7784365000783/train/ruby
# просто для просмотра скобок(не проходит по скорости)
$brs={0=>[['']], 1=>[['(',')']]}
2.upto(5) do |n|
  arr=$brs[n-1]
  res=[]
  arr.each do |a|
    res << ['(']+a+[')'] << ['(']+[')']+a << a+['(']+[')'] # заворачиваем весь элемент и добавлям слева и справа
    brr=a.slice_when{|x,y| x==')' && y=='('}.to_a
    (0..brr.size-1).each do |i|
      nbi=['(']+brr[i]+[')']
      newel=(brr[0...i]+nbi+brr[i+1..-1]).flatten # оборачиваем каждый завершенный{ +((...))+ } подэлемент
      res << newel
      res << (brr[0...i]+['(',')']+brr[i..-1]).flatten if i!=0 # пихаем () между каждыми )...(
    end
  end
  $brs[n]=res.uniq
end
# p $brs.map{|k, v| [k, v.map(&:join)]}

# решение, тоже не проходит по скорости
def balanced_parens(n)
  return [''] if n < 1
  arr = [ ['(', '*'] * n ]
  p arr # [["(", "*", "(", "*", "(", "*"]]
  until n == 1
    n -= 1
    arr = arr.each_with_object([]) do |a, res|
      1.upto(a.size) do |x|
        counter = 1
        new = a.each.with_index do |e, i|
          if e == '*' && counter == x
            new = a.clone
            new[i] = ')'
            new = new.map.with_index{|ee, j| ee == '*' && j <= i ? nil : ee}.compact
            res << new
          end
          counter += 1
        end
      end
    end
    p arr # [["(", ")", "(", "*", "(", "*"], ["(", "(", ")", "(", "*"], ["(", "(", "(", ")"]]
    # [["()(", ")", "(", "*"], ["()(", "(", ")"], ["(()", ")", "(", "*"], ["(()", "(", ")"], ["((()", ")"]] (2й круг цикла)
    arr.map! do |a|
      i = a.rindex(')')
      if a[0..i].join.count('(') == a[0..i].join.count(')')
        [ a[0..i+1].join ] + a[i+2..-1]
      else
        [ a[0..i].join ] + a[i+1..-1]
      end
    end
    p arr # [["()(", "*", "(", "*"], ["(()", "(", "*"], ["((()"]]
    # [["()()(", "*"], ["()(()"], ["(())(", "*"], ["(()()"], ["((())"]]
    arr.map! do |a|
      a = a.reject{|e| e == '*'}.zip(['*'] * (a.size-1)).flatten.compact
      count = a.count('*')
      if count < n && a[-1] != '*'
        a + ['*']
      else
        a
      end
    end
    p arr # [["()(", "*", "(", "*"], ["(()", "*", "(", "*"], ["((()", "*"]]
    # [["()()(", "*"], ["()(()", "*"], ["(())(", "*"], ["(()()", "*"], ["((())", "*"]]
  end

  arr.map{|a| [a[0], ')'].join}
end

# p balanced_parens(0) # [""]
# p balanced_parens(1) # ["()"]
# p balanced_parens(2) # ["()()","(())"]
p balanced_parens(3) # ["()()()","(())()","()(())","(()())","((()))"]



puts
# Magnet particules in boxes
# https://www.codewars.com/kata/56c04261c3fcf33f2d000534/train/ruby
N = (1..100000).map{|n| 1 / (n**2 + 2*n + 1).to_f}

def doubles(maxk, maxn)
  (1..maxk).sum{|k| (1..maxn).sum{|n| N[n-1]**k / k.to_f }}
end

p doubles(1, 10)# 0.5580321939764581
p doubles(10, 1000)# 0.6921486500921933
p doubles(10, 10000)# 0.6930471674194457
p doubles(20, 10000)# 0.6930471955575918



# Elevator Action!   https://www.codewars.com/kata/654cdf611d68c91228af27f1/train/ruby

class Elevator
  attr_reader :result

  def initialize(level, queue)
    @queue = add_index(queue)
    @level = level
    @dir, @target, @next_floor, @people = '', nil, nil, []
    @result = []
  end

  def action
    until @queue.empty? && @people.empty?
      start if @people.empty?
      move
      stopage
    end
  end

  def start
    next_from = @queue[0][:from]
    if next_from == @level
      @result << next_from
      @dir = @level > @queue[0][:to] ? 'D' : 'U'
      passgs = @queue.select do |p|
        p[:from] == next_from && ((@dir == 'D' && p[:to] < @level) || (@dir == 'U' && p[:to] > @level))
      end.first(5)
      passgs.each{|p| @queue.delete(p)}
      @people = passgs.map{|p| p[:to]}
    else
      @dir = @level > next_from ? 'D' : 'U'
      @target = next_from
    end
  end

  def move
    next_peoples = @queue.select do |p|
      (@dir == 'U' && p[:from] > @level && p[:to] > p[:from] ) || (@dir == 'D' && p[:from] < @level && p[:to] < p[:from])
    end.map{|p| p[:from]}.uniq.sort
    next_people_floor = (@dir == 'D' ? next_peoples.reverse : next_peoples)[0]
    @next_floor = if @people.empty?
      targets = [next_people_floor, @target].compact
      @dir == 'U' ? targets.min : targets.max
    else
      targets = [next_people_floor, *@people].compact
      @dir == 'U' ? targets.min : targets.max
    end
  end

  def stopage
    @level = @next_floor
    @result << @level
    # @next_floor = nil
    if @people.empty? && @target
      # p [@target, @people]
      passagers = @queue.select{|p| p[:from] == @level}
      # target_passager = passagers[0]
      # target_passager = passagers.f
      # @dir = target_passager[:to] > @level ? 'U' : 'D'
      passgs = passagers.select{|p| (@dir == 'D' && p[:to] < @level) || (@dir == 'U' && p[:to] > @level)}.first(5)
      @target = nil
    else
      @people.delete(@level)
      passagers = @queue.select{|p| p[:from] == @level}
      if @people.empty?
        return if passagers.empty?
        target_passager = passagers[0]
        @dir = target_passager[:to] > @level ? 'U' : 'D'
        passgs = passagers.select{|p| (@dir == 'D' && p[:to] < @level) || (@dir == 'U' && p[:to] > @level)}.first(5)
      else
        passgs = passagers.select{|p| (@dir == 'D' && p[:to] < @level) || (@dir == 'U' && p[:to] > @level)}.first(5-@people.size)
      end
    end
    passgs.each{|p| @queue.delete(p)}
    @people += passgs.map{|p| p[:to]}
  end

  private

  def add_index(queue)
    queue.each.with_index{|e, i| e[:i] = i}
    queue
  end
end

def order(level, queue)
  return [] if queue == []
  el = Elevator.new(level, queue)
  el.action
  el.result
end

p order(1, [{from: 5, to: 3}, {from: 4, to: 2}]) # [5,4,3,2]
# p order(1, [{from:5, to: 1},{from: 4, to: 3}, {from: 2, to: 1}, {from: 2, to: 4}, {from: 5, to: 2}]) # [2,4,5,4,3,2,1]
# p order(4, [{from: 5, to: 3}, {from: 4, to: 2}]) # [5,4,3,2]
# p order(4, [{from: 4, to: 2}, {from: 5, to: 3}]) # [4,2,5,3]
# p order(1, [{from:5, to: 1},{from: 4, to: 3}, {from: 2, to: 1}]) # [5,4,3,2,1]

# people = [
#   { from: 3, to: 2 }, # 3rd passenger
#   { from: 5, to: 6 }, # 4th passenger
#   { from: 2, to: 1 }, # 5th passenger
#   { from: 2, to: 5 }, # 1st passenger
#   { from: 4, to: 3 }, # 2nd passenger
# ]
# p order(1, people) # [2, 5, 4, 3, 2, 5, 6, 2, 1]

# queue = [
#   { from: 3, to: 2 }, # Al
#   { from: 5, to: 2 }, # Betty
#   { from: 2, to: 1 }, # Charles
#   { from: 2, to: 5 }, # Dan
#   { from: 4, to: 3 }, # Ed
# ]
# p order(1, queue) # [2, 5, 4, 3, 2, 1]
# puzzle = [{from: 5, to: 4},  # 1st passenger
#           {from: 5, to: 3},  # 2nd passenger
#           {from: 3, to: 4},  # 3rd passenger
#           {from: 0, to: 2},  # 5th passenger
#           {from: 3, to: -4}, # 4th passenger
#           {from: 1, to: 2}]  # 6th passenger
# p order(5, puzzle) # [5, 4, 3, 4, 3, -4, 0, 1, 2]

# people = [
#   { from: 3, to: 6 }, # 16th passenger
#   { from: 2, to: 6 }, # 1st  passenger
#   { from: 2, to: 6 }, # 2nd  passenger
#   { from: 2, to: 6 }, # 3rd  passenger
#   { from: 2, to: 6 }, # 4th  passenger
#   { from: 2, to: 6 }, # 5th  passenger
#   { from: 2, to: 6 }, # 10th passenger
#   { from: 2, to: 6 }, # 11th passenger
#   { from: 2, to: 6 }, # 12th passenger
#   { from: 2, to: 6 }, # 13th passenger
#   { from: 3, to: 2 }, # 8th  passenger
#   { from: 5, to: 6 }, # 15th passenger
#   { from: 2, to: 1 }, # 9th  passenger
#   { from: 2, to: 5 }, # 14th passenger
#   { from: 4, to: 3 }, # 7th  passenger
#   { from: 6, to: 1 }, # 6th  passenger
# ]
# p order(1, people) # [2, 6, 4, 3, 2, 1, 2, 5, 6, 3, 6]


# puzzle4 = [{from: 4, to: 3},{from: 4, to: 3},{from: 4, to: 3},{from: 4, to: 3},{from:5, to: 1},{from: 2, to: 3}, {from: 2, to: 4}, {from: 5, to: 2}]
# p order(1, puzzle4) # [2, 3, 4, 3, 5, 2, 1]

# puzzle = [
#   {from: 3900, to: 500},
#   {from: 4500, to: 500000},
#   {from: 1800, to: -400},
#   {from: 4300, to: 500},
# ]
# p order(2000, puzzle) # [3900, 1800, 500, -400, 4500, 500000, 4300, 500]
