# call одной и той же функции может встречаться в нескольких местах, соотв нужно отслеживать историю (уровней) вызовов??
# либо мб ретурн всегде не в тело самой же этой функции ??
# идет ли переход на следующую строку между функциями ??
class AssemblerInterpreter
  attr_reader :functions

  def initialize(string)
    @functions = {}
    @next_function = 'main'
    @calls = []
    @vars = {}
    @cmp = nil
    parser(string)
  end

  def main
    res = nil
    loop do
      return @res if res == 'end'
      return -1 if res == 'exit'
      if res == 'ret'
        # function_from = @functions.find{|name, func| func.include?(["call", @next_function])}[0]   # старый варик

        function_from = @calls.pop  # новый варик(тоже не работает)
        p @calls
        p function_from
        p @next_function
        i = @functions[function_from].index{|func| func == ["call", @next_function]} + 1
        # p i
        @next_function = function_from
        res = next_function_start(i)
      else
        res = next_function_start(0)
      end
    end
  end

  def next_function_start(i)
    @functions[@next_function][i..-1].each do |com|
      # p com[0]
      if com[0] == 'end' || com[0] == 'ret'
        return com[0]
      elsif com[0] == 'call'  # этого не было(call был в массиве ниже и у него был метод вызывающий true)
        @calls << @next_function
        @next_function = com[1]
        return 'next'
      elsif %w[jmp jne je jge jg jle jl].include?(com[0]) && send(*com)
        @next_function = com[1]
        return 'next'
      else
        send(*com)
      end
    end
    'exit'
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

  def jmp(arg) true end
  def cmp(arg)
    x = arg[0].class.superclass == Numeric ? arg[0] : @vars[arg[0]]
    y = arg[1].class.superclass == Numeric ? arg[1] : @vars[arg[1]]
    @cmp = x <=> y
  end
  def jne(arg) @cmp != 0 end
  def je(arg) @cmp == 0 end
  def jge(arg) @cmp >= 0 end
  def jg(arg) @cmp == 1 end
  def jle(arg) @cmp <= 0 end
  def jl(arg) @cmp == -1 end

  def msg(arg)
    @res = arg.map{|e| @vars[e] ? @vars[e] : e}.join
  end

  # Parsers:

  def parser(string)
    prog = string.gsub(/(;.+)(\n)/, '\2').strip.split("\n\n").map{|pr| pr.split("\n").reject(&:empty?).map(&:strip)}
    @functions['main'] = command_split_arg(prog[0])
    @functions.merge! prog[1..-1].map{|f| [f[0][0..-2], command_split_arg(f[1..-1])]}.to_h
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
  p ai.functions
  ai.main
end

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

{
  "main"=>[
    ["mov", [:a, 2]],
    ["mov", [:b, 10]],
    ["mov", [:c, :a]],
    ["mov", [:d, :b]],
    ["call", "proc_func"],
    ["call", "print"],
    ["end"]
  ],
  "proc_func"=>[
    ["cmp", [:d, 1]],
    ["je", "continue"],
    ["mul", [:c, :a]],
    ["dec", "d"],
    ["call", "proc_func"]
  ],
  "continue"=>[
    ["ret"]
  ],
  "print"=>[
    ["msg", [:a, "^", :b, " = ", :c]], ["ret"]
  ]
}

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
# program_fibonacci = "
# mov   a, 8            ; value
# mov   b, 0            ; next
# mov   c, 0            ; counter
# mov   d, 0            ; first
# mov   e, 1            ; second
# call  proc_fib
# call  print
# end
#
# proc_fib:
#     cmp   c, 2
#     jl    func_0
#     mov   b, d
#     add   b, e
#     mov   d, e
#     mov   e, b
#     inc   c
#     cmp   c, a
#     jle   proc_fib
#     ret
#
# func_0:
#     mov   b, c
#     inc   c
#     jmp   proc_fib
#
# print:
#     msg   'Term ', a, ' of Fibonacci series is: ', b        ; output text
#     ret
# "
# p assembler_interpreter(program_fibonacci)# 'Term 8 of Fibonacci series is: 21'
#
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
