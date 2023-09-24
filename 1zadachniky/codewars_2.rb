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
  # p program
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

program = "
; My first program
mov  a, 5
inc  a
call function
msg  '(5+1)/2 = ', a    ; output message
end

function:
    div  a, 2
    ret
"
p assembler_interpreter(program)# '(5+1)/2 = 3'

program_factorial = "
mov   a, 5
mov   b, a
mov   c, a
call  proc_fact
call  print
end

proc_fact:
    dec   b
    mul   c, b
    cmp   b, 1
    jne   proc_fact
    ret

print:
    msg   a, '! = ', c ; output text
    ret
"
p assembler_interpreter(program_factorial)# '5! = 120'


program_fibonacci = "
mov   a, 8            ; value
mov   b, 0            ; next
mov   c, 0            ; counter
mov   d, 0            ; first
mov   e, 1            ; second
call  proc_fib
call  print
end

proc_fib:
    cmp   c, 2
    jl    func_0
    mov   b, d
    add   b, e
    mov   d, e
    mov   e, b
    inc   c
    cmp   c, a
    jle   proc_fib
    ret

func_0:
    mov   b, c
    inc   c
    jmp   proc_fib

print:
    msg   'Term ', a, ' of Fibonacci series is: ', b        ; output text
    ret
"
p assembler_interpreter(program_fibonacci)# 'Term 8 of Fibonacci series is: 21'

program_mod = "
mov   a, 11           ; value1
mov   b, 3            ; value2
call  mod_func
msg   'mod(', a, ', ', b, ') = ', d        ; output
end

; Mod function
mod_func:
    mov   c, a        ; temp1
    div   c, b
    mul   c, b
    mov   d, a        ; temp2
    sub   d, c
    ret
"
p assembler_interpreter(program_mod)# 'mod(11, 3) = 2'

program_gcd = "
mov   a, 81         ; value1
mov   b, 153        ; value2
call  init
call  proc_gcd
call  print
end

proc_gcd:
    cmp   c, d
    jne   loop
    ret

loop:
    cmp   c, d
    jg    a_bigger
    jmp   b_bigger

a_bigger:
    sub   c, d
    jmp   proc_gcd

b_bigger:
    sub   d, c
    jmp   proc_gcd

init:
    cmp   a, 0
    jl    a_abs
    cmp   b, 0
    jl    b_abs
    mov   c, a            ; temp1
    mov   d, b            ; temp2
    ret

a_abs:
    mul   a, -1
    jmp   init

b_abs:
    mul   b, -1
    jmp   init

print:
    msg   'gcd(', a, ', ', b, ') = ', c
    ret
"
p assembler_interpreter(program_gcd)# 'gcd(81, 153) = 9'

program_fail = "
call  func1
call  print
end

func1:
    call  func2
    ret

func2:
    ret

print:
    msg 'This program should return -1'
"
p assembler_interpreter(program_fail)# -1

program_power = "
mov   a, 2            ; value1
mov   b, 10           ; value2
mov   c, a            ; temp1
mov   d, b            ; temp2
call  proc_func
call  print
end

proc_func:
    cmp   d, 1
    je    continue
    mul   c, a
    dec   d
    call  proc_func

continue:
    ret

print:
    msg a, '^', b, ' = ', c
    ret
"
p assembler_interpreter(program_power)# '2^10 = 1024'




# (!!!) Возможно придется пихать все в хэш или массив(или хэши массивов для каждой функции), чтоб переходить между командами
class AssemblerInterpreter
  attr_reader :program, :functions

  def initialize(string)
    @vars = {}
    @cmp = nil
    parser(string)
  end

  def main
    @program.each do |com|
      return @res if com[0] == 'end'
      send(*com)
    end
    -1
  end

  private

  # Assembler commands:

  def mov(arg)
    @vars[arg[0]] = arg[1].class.superclass == Numeric ? arg[1] : @vars[arg[1]]
  end

  def inc(arg)
    @vars[arg[0].to_sym] += 1
  end
  def dec(arg)
    @vars[arg[0].to_sym] -= 1
  end

  def add(arg)
    @vars[arg[0]] += arg[1].class.superclass == Numeric ? arg[1] : @vars[arg[1]]
  end
  def sub(arg)
    @vars[arg[0]] -= arg[1].class.superclass == Numeric ? arg[1] : @vars[arg[1]]
  end
  def mul(arg)
    @vars[arg[0]] *= arg[1].class.superclass == Numeric ? arg[1] : @vars[arg[1]]
  end
  def div(arg)
    @vars[arg[0]] /= arg[1].class.superclass == Numeric ? arg[1] : @vars[arg[1]]
  end

  def cmp(arg)
    x = arg[0].class.superclass == Numeric ? arg[0] : @vars[arg[0]]
    y = arg[1].class.superclass == Numeric ? arg[1] : @vars[arg[1]]
    @cmp = x <=> y
  end
  def jne(arg) # cmp command were not equal.
    call(arg) if @cmp != 0
  end
  def je(arg) # cmp command were equal
    call(arg) if @cmp == 0
  end
  def jge(arg) # x was greater or equal than y in the previous cmp command
    call(arg) if @cmp >= 0
  end
  def jg(arg) # x was greater than y in the previous cmp command.
    call(arg) if @cmp == 1
  end
  def jle(arg) # x was less or equal than y in the previous cmp command.
    call(arg) if @cmp <= 0
  end
  def jl(arg) # x was less than y in the previous cmp command.
    call(arg) if @cmp == -1
  end

  def jmp(arg)
    call(arg)
  end

  def call(arg)
    @functions[arg].each do |com|
      break if com[0] == 'ret'
      send(*com)
    end
  end

  def msg(arg)
    @res = arg.map{|e| @vars[e] ? @vars[e] : e}.join
  end

  # Parsers:

  def parser(string)
    prog = string.gsub(/(;.+)(\n)/, '\2').strip.split("\n\n").map{|pr| pr.split("\n").map(&:strip)}
    @program = command_split_arg(prog[0])
    @functions = prog[1..-1].map{|f| [f[0][0..-2], command_split_arg(f[1..-1])]}.to_h
  end

  def command_split_arg(com_arg)
    com_arg.map do |com|
      name, arg = com.split[0], com.split[1..-1].join(' ')
      arg = duble_arg_parser(arg) if %w[mov add sub mul div cmp].include?(name)
      arg = msg_parser(arg) if name == 'msg'
      [name, arg].reject(&:empty?)
    end
  end

  def duble_arg_parser(arg)
    arg.split(', ').map{|e| /[0-9]+/ === e ? e.to_i : e.to_sym}
  end

  def msg_parser(arg)
    j = arg[0] == "'" ? 0 : 1
    arg.split("'").reject(&:empty?).map.with_index{|e, i| (i + j).even? ? e : e.tr('^a-z', '').to_sym}
  end
end

def assembler_interpreter(program)
  ai = AssemblerInterpreter.new(program)
  p ai.program
  p ai.functions
  ai.main
end

# program = "
# ; My first program
# mov  a, 5
# inc  a
# call function
# msg  '(5+1)/2 = ', a    ; output message
# end
#
# function:
#     div  a, 2
#     ret
# "
# p assembler_interpreter(program)# '(5+1)/2 = 3'
#
#
# program_factorial = "
# mov   a, 5
# mov   b, a
# mov   c, a
# call  proc_fact
# call  print
# end
#
# proc_fact:
#     dec   b
#     mul   c, b
#     cmp   b, 1
#     jne   proc_fact
#     ret
#
# print:
#     msg   a, '! = ', c ; output text
#     ret
# "
# p assembler_interpreter(program_factorial)# '5! = 120'
#
#
program_fibonacci = "
mov   a, 8            ; value
mov   b, 0            ; next
mov   c, 0            ; counter
mov   d, 0            ; first
mov   e, 1            ; second
call  proc_fib
call  print
end

proc_fib:
    cmp   c, 2
    jl    func_0
    mov   b, d
    add   b, e
    mov   d, e
    mov   e, b
    inc   c
    cmp   c, a
    jle   proc_fib
    ret

func_0:
    mov   b, c
    inc   c
    jmp   proc_fib

print:
    msg   'Term ', a, ' of Fibonacci series is: ', b        ; output text
    ret
"
p assembler_interpreter(program_fibonacci)# 'Term 8 of Fibonacci series is: 21'

# program_mod = "
# mov   a, 11           ; value1
# mov   b, 3            ; value2
# call  mod_func
# msg   'mod(', a, ', ', b, ') = ', d        ; output
# end
#
# ; Mod function
# mod_func:
#     mov   c, a        ; temp1
#     div   c, b
#     mul   c, b
#     mov   d, a        ; temp2
#     sub   d, c
#     ret
# "
# p assembler_interpreter(program_mod)# 'mod(11, 3) = 2'
#
# program_gcd = "
# mov   a, 81         ; value1
# mov   b, 153        ; value2
# call  init
# call  proc_gcd
# call  print
# end
#
# proc_gcd:
#     cmp   c, d
#     jne   loop
#     ret
#
# loop:
#     cmp   c, d
#     jg    a_bigger
#     jmp   b_bigger
#
# a_bigger:
#     sub   c, d
#     jmp   proc_gcd
#
# b_bigger:
#     sub   d, c
#     jmp   proc_gcd
#
# init:
#     cmp   a, 0
#     jl    a_abs
#     cmp   b, 0
#     jl    b_abs
#     mov   c, a            ; temp1
#     mov   d, b            ; temp2
#     ret
#
# a_abs:
#     mul   a, -1
#     jmp   init
#
# b_abs:
#     mul   b, -1
#     jmp   init
#
# print:
#     msg   'gcd(', a, ', ', b, ') = ', c
#     ret
# "
# p assembler_interpreter(program_gcd)# 'gcd(81, 153) = 9'
#
# program_fail = "
# call  func1
# call  print
# end
#
# func1:
#     call  func2
#     ret
#
# func2:
#     ret
#
# print:
#     msg 'This program should return -1'
# "
# p assembler_interpreter(program_fail)# -1
#
# program_power = "
# mov   a, 2            ; value1
# mov   b, 10           ; value2
# mov   c, a            ; temp1
# mov   d, b            ; temp2
# call  proc_func
# call  print
# end
#
# proc_func:
#     cmp   d, 1
#     je    continue
#     mul   c, a
#     dec   d
#     call  proc_func
#
# continue:
#     ret
#
# print:
#     msg a, '^', b, ' = ', c
#     ret
# "
# p assembler_interpreter(program_power)# '2^10 = 1024'
