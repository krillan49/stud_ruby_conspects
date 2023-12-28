# Symbolic differentiation of prefix expressions
# https://www.codewars.com/kata/584daf7215ac503d5a0001ae/train/ruby
class DiffExp
  def initialize(exp)
    # если не получится мб распарсить так ? : ["-", ["+", ["*", "x", 1], ["*", "x", 1]], ["*", "x", 1]]
    @exp = exp_to_arr(exp) # ["-", ["+", {"x"=>1}, {"x"=>1}], {"x"=>1}]
  end

  def main
    @exp = recursion_cycle(@exp) if @exp.class == Array
    @exp = derivative(@exp)
    @exp = recursion_cycle(@exp) if @exp.class == Array
    @exp
  end

  def derivative(exp) # производная # потом вставим упрощенное @exp вместо x в oexp
    # p exp
    if exp[0] == 'sin' # sin(n*x) => n*cos(n*x)"
      newexp = ['*', derivative(exp[1]), ['cos', exp[1]]]
    elsif exp[0] == 'cos'
      newexp = ['*', -1, ['*', derivative(exp[1]), ['sin', exp[1]]]]
    elsif exp[0] == 'exp' # '(exp x)'
      newexp = ['*', derivative(exp[1]), ['exp', exp[1]]]
    elsif exp[0] == 'ln' # '(/ 1 x)'
      p exp
      newexp = ['/', 1, exp[1]]
    elsif exp[0] == '^'
      newexp = ["^", ["*", exp[2], exp[1]], exp[2] - 1]
    elsif exp[0] == '/' # (u/v)' = (u'v - uv')/v^2
      newexp = [
        '/',
        ['-', ['*', derivative(exp[1]), exp[2]], ['*', derivative(exp[2]), exp[1]]],
        ['^', exp[2], 2]
      ]
    elsif exp[0] == '*'
      if exp[1].class == Integer
        exp[2] = exp[2].map{|e| e.class == Hash ? {'x' => e['x'] *= exp[1]} : e.class == Integer ? e * exp[1] : e} # * на коэф
        newexp = derivative(exp[2]).compact
      elsif exp[2].class == Integer
        exp[1] = exp[1].map{|e| e.class == Hash ? {'x' => e['x'] *= exp[2]} : e.class == Integer ? e * exp[2] : e} # * на коэф
        newexp = derivative(exp[1]).compact
      end
    elsif exp[0] == '+'
      # newexp = "(+ #{exp[1]['x']}x #{exp[2]})"
      newexp = ["+", derivative(exp[1]), derivative(exp[2])]
    elsif exp.class == Hash # переменная и множитель
      newexp = exp['x']
    elsif exp.class == Integer
      newexp = 0
    end
    newexp
  end

  def recursion_cycle(exp) # упрощаем выражение
    exp = exp.map do |ex|
      if ex.class == Array
        ex.any?{|e| e.class == Array} ? recursion_cycle(ex) : simplify_inner_exp(ex)
      else
        ex
      end
    end
    simplify_inner_exp(exp)
  end

  def simplify_inner_exp(exp) # упрощаем внутренний массив
    # p exp
    if exp[1].class == Integer && exp[2].class == Integer
      exp[0] == '**' if exp[0] == '^'
      exp[1].send(exp[0], exp[2])
    elsif exp[0] == '+' && (exp[1] == 0 || exp[2] == 0)
      exp[1] == 0 ? exp[2] : exp[1]
    elsif exp[0] == '-' && (exp[1] == 0 || exp[2] == 0)
      exp[1] == 0 ? -exp[2] : exp[1]
    elsif exp[0] == '*' && (exp[1] == 0 || exp[2] == 0)
      0
    elsif exp[0] == '^'
      if exp[1] == 0
        0
      elsif exp[2] == 0 || exp[1] == 1
        1
      elsif exp[2] == 1
        exp[1]
      else
        exp
      end
    elsif exp[1].class == Hash && exp[2].class == Hash && %w[+ -].include?(exp[0])  # оба с переменными
      k = exp[1].keys[0]
      exp = {k => exp[1][k].send(exp[0], exp[2][k])}
    elsif exp[1..-1].any?{|e| e.class == Hash} && exp[1..-1].any?{|e| e.class != Hash} && %w[* /].include?(exp[0]) # одно с переменной
      hh = exp[1..-1].find{|e| e.class == Hash}
      n = exp[1..-1].find{|e| e.class != Hash}
      k = hh.keys[0]
      res = hh[k].send(exp[0], n.to_f)
      res = res.to_i if res % 1 == 0
      exp = {k => res}
    else
      exp
    end
  end

  private

  def exp_to_arr(exp)
    exp = exp.tr('()', '[]')
             .split('')
             .map{|e| e.chars.slice_when{|a, b| a == '[' || b == ']'}.map(&:join)}
             .flatten
             .map{|e| /^\d*$|\[|\]| / === e ? e : "'#{e}'"}
             .join
             .gsub(/ /, ',')
             .gsub(/'e''x''p'/, "'exp'")
             .gsub(/'x'/, '{"x" => 1}')
    eval(exp)
  end

end


def diff(s)
  dif_exp = DiffExp.new(s)
  dif_exp.main
end

# p diff('5')             # 0                     # constant should return 0"
# p diff('x')             # 1                     # x should return 1"
# p diff('(+ x x)')       # 2                     # x+x should return 2"
# p diff('(- x x)')       # 0                     # x-x should return 0"
# p diff('(* x 2)')       # 2                     # 2*x should return 2"
# p diff('(/ x 2)')       # 0.5                   # x/2 should return 0.5"
# p diff('(^ x 2)')       # (* 2 x)               # x^2 should return 2*x"
# p diff('(+ x (+ x x))') # 3                     # x+(x+x) should return 3"
# p diff('(- (+ x x) x)') # 1                     # (x+x)-x should return 1"
# p diff('(* 2 (+ x 2))') # 2                     # 2*(x+2) should return 2"
# p diff('(/ 2 (+ 1 x))') # (/ -2 (^ (+ 1 x) 2))  # 2/(1+x) should return -2/(1+x)^2"
# p diff('(cos x)')       # (* -1 (sin x))        # cos(x) should return -1 * sin(x)"
# p diff('(sin x)')       # (cos x)               # sin(x) should return cos(x)"
# p diff('(exp x)')       # (exp x)               # exp(x) should return exp(x)"
p diff('(ln x)')        # (/ 1 x)               # ln(x) should return 1/x"
# p diff('(cos (+ x 1))') # (* -1 (sin (+ x 1)))  # cos(x+1) should return -1 * sin(x+1)"
# p diff('(sin (+ x 1))') # (cos (+ x 1))         # sin(x+1) should return cos(x+1)"
# p diff('(sin (* 2 x))') # (* 2 (cos (* 2 x)))   # sin(2*x) should return 2*cos(2*x)"
# p diff('(cos (* 2 x))') # (* -2 (sin (* 2 x)))
# p diff('(exp (* 2 x))') # (* 2 (exp (* 2 x)))   # exp(2*x) should return 2*exp(2*x)"


def recursion_cycle(exp) # упрощаем выражение
  exp = exp.map do |ex|
    if ex.class == Array
      ex.any?{|e| e.class == Array} ? recursion_cycle(ex) : simplify_inner_exp(ex)
    else
      ex
    end
  end
  simplify_inner_exp(exp)
end

def simplify_inner_exp(exp) # упрощаем внутренний массив
  # p exp
  if exp[1].class == Integer && exp[2].class == Integer
    exp[0] == '**' if exp[0] == '^'
    exp[1].send(exp[0], exp[2])
  elsif exp[0] == '+' && (exp[1] == 0 || exp[2] == 0)
    exp[1] == 0 ? exp[2] : exp[1]
  elsif exp[0] == '-' && (exp[1] == 0 || exp[2] == 0)
    exp[1] == 0 ? -exp[2] : exp[1]
  elsif exp[0] == '*' && (exp[1] == 0 || exp[2] == 0)
    0
  elsif exp[0] == '^'
    if exp[1] == 0
      0
    elsif exp[2] == 0 || exp[1] == 1
      1
    elsif exp[2] == 1
      exp[1]
    else
      exp
    end
  elsif exp[1].class == Hash && exp[2].class == Hash && %w[+ -].include?(exp[0])  # оба с переменными
    k = exp[1].keys[0]
    exp = {k => exp[1][k].send(exp[0], exp[2][k])}
  elsif exp[1..-1].any?{|e| e.class == Hash} && exp[1..-1].any?{|e| e.class != Hash} && %w[* /].include?(exp[0]) # одно с переменной
    hh = exp[1..-1].find{|e| e.class == Hash}
    n = exp[1..-1].find{|e| e.class != Hash}
    k = hh.keys[0]
    res = hh[k].send(exp[0], n.to_f)
    res = res.to_i if res % 1 == 0
    exp = {k => res}
  else
    exp
  end
end

exp = ["/", 1, {"x"=>1}]
p recursion_cycle(exp)
