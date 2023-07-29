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
