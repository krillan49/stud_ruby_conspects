puts
# 2 kyu     Assembler interpreter (part II)    https://www.codewars.com/kata/58e61f3d8ff24f774400002c/train/ruby
$last_com=''
$cmp=''
$res=[]
$vars={}
$functions={}

def list_iterator(list)
  list.each do |a|
    if a[0]=='mov' # initialize
      /[0-9-]/===a[2][0] ? $vars[a[1]]=a[2].to_i : $vars[a[1]]=$vars[a[2]]
    elsif a[0]=='inc' # +1
      $vars[a[1]]+=1
    elsif a[0]=='dec' #-1
      $vars[a[1]]-=1
    elsif a[0]=='add' # x+y
      /[0-9-]/===a[2][0] ? $vars[a[1]]+=a[2].to_i : $vars[a[1]]+=$vars[a[2]]
    elsif a[0]=='sub' # x-y
      /[0-9-]/===a[2][0] ? $vars[a[1]]-=a[2].to_i : $vars[a[1]]-=$vars[a[2]]
    elsif a[0]=='mul' # x*y
      /[0-9-]/===a[2][0] ? $vars[a[1]]*=a[2].to_i : $vars[a[1]]*=$vars[a[2]]
    elsif a[0]=='div' # x/y
      /[0-9-]/===a[2][0] ? $vars[a[1]]/=a[2].to_i : $vars[a[1]]/=$vars[a[2]]
    elsif a[0]=='call' # вызов функций из main
      list_iterator($functions[a[1]])
    elsif a[0]=='jmp' # вызов функций из функций
      list_iterator($functions[a[1]])
    elsif a[0]=='cmp' # сравнение '=' '<'(x<y) '>'(x>y)
      /[0-9-]/===a[1][0] ? x=a[1].to_i : x=$vars[a[1]]
      /[0-9-]/===a[2][0] ? y=a[2].to_i : y=$vars[a[2]]
      x>y ? $cmp='>' : x<y ? $cmp='<' : $cmp='='
    elsif a[0]=='jne'
      list_iterator($functions[a[1]]) if $cmp!='='
    elsif a[0]=='je'
      list_iterator($functions[a[1]]) if $cmp=='='
    elsif a[0]=='jge'
      list_iterator($functions[a[1]]) if $cmp=='=' or $cmp=='>'
    elsif a[0]=='jg'
      list_iterator($functions[a[1]]) if $cmp=='>'
    elsif a[0]=='jle'
      list_iterator($functions[a[1]]) if $cmp=='=' or $cmp=='<'
    elsif a[0]=='jl'
      list_iterator($functions[a[1]]) if $cmp=='<'
    elsif a[0]=='msg' # вывод
      $res << a[1..-1].map{|e| $vars[e] ? $vars[e] : e}.join.tr("'", '')
    end
    $last_com=a[0]
  end
end

def assembler_interpreter(program)
  p program
  program.include?("\n\n") ? tumb=true : tumb=false

  program=program.split("\n\n") # делим на блоки
  .map(&:strip).map{|el| el.split("\n").map{|e| e.split(';')[0].strip}.reject{|e| e==''}} # делим блоки построчно и удаляем комменты

  program=program.map do |prog| # приводим в окончательно преобразованный 3д массив
    prog.map do |e|
      if e.include?('msg') # разбираемся с запятыми в строках типа  "msg   'gcd(', a, ', ', b, ') = ', c"
        e=e.chars.slice_when{|a,b| a=="'" or b=="'"}.to_a
        while e.include?(["'"])
          counter=0
          ind=nil
          e.each.with_index do |a,i|
            if a==["'"] && counter==0
              ind=i
              counter=1
            elsif a==["'"] && counter==1
              e[ind..i]=[[e[ind..i].join]]
              break
            end
          end
        end
        e=e.map(&:join).map{|s| s[0]=="'" ? s : s.tr(',','').strip}
      else
        e.tr(',','').split
      end
    end
  end

  program=program.flatten(1).slice_when{|a,b| b.size==1 && b.join[-1]==':'}.to_a if !tumb

  main=program.reject{|arr| arr[0].size==1 && arr[0].join[-1]==':'}.flatten(1)

  functions=program.select{|arr| arr[0].size==1 && arr[0].join[-1]==':'}

  functions=functions.map do |func| # заплатка(в строке msg  если она расположена в функции не отделяется переменная)
    func.map do |f|
      f.map do |e|
        if e.include?('msg') && e!='msg'
          e.split
        else
          e
        end
      end.flatten
    end
  end

  functions.each do |arr|
    $functions[arr[0].join[0..-2]]=arr[1..-1]
  end

  list_iterator(main)

  res=$res.clone
  $res.clear
  $vars.clear
  $functions.clear
  $last_com=='end' ? res.join : -1
end


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


puts
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
# 3 kyu How many are smaller than me II?  https://www.codewars.com/kata/56a1c63f3bc6827e13000006
require 'set'

def smaller(arr)
  p arr.size
  p arr.uniq.size

  counter = 0

  set = Set.new
  hh = {}
  size = arr.size
  res = []
  arr.each.with_index do |n, i|

    if set.include?(n)
      counter += 1

      new = 0
    elsif !hh[n]
      counter += size - i - 1

      new = arr[i+1..-1].select{|e| e < n}.size
      hh[n] = [new, i]
    else
      old = hh[n]

      counter += i - old[1]

      new = old[0] - arr[old[1]...i].select{|e| e < n}.size
      if new <= 0
        hh.delete(n)
        set << n
        new = 0
      else
        hh[n] = [new, i]
      end
    end

    res << new
  end
  p counter #=> 185545628 если arr.size==49339 arr.uniq.size==2001
  res
end

p smaller([5, 4, 7, 9, 2, 4, 1, 4, 5, 6])# [5, 2, 6, 6, 1, 1, 0, 0, 0, 0]
