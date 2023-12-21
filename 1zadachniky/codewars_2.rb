# Symbolic differentiation of prefix expressions
# https://www.codewars.com/kata/584daf7215ac503d5a0001ae/train/ruby
class DiffExp
  def initialize(exp)
    @exp = exp_to_arr(exp) # ["-", ["+", {"x"=>1}, {"x"=>1}], {"x"=>1}]
    @oexp = ''
  end

  def main
    @exp = recursion_cycle(@exp) if @exp.class == Array
    derivative
    [@oexp, @exp]
  end

  def derivative # производная
    if @exp[0] == 'sin'
      @oexp = '(cos x)' # потом вставим упрощенное @exp вместо x
      @exp = @exp[1]
    elsif @exp[0] == 'cos'
      @oexp = '(* -1 (sin x))'
      @exp = @exp[1]
    elsif @exp[0] == 'exp'
      @oexp = '(exp x)'
      @exp = @exp[1]
    elsif @exp[0] == 'ln'
      @oexp = '(/ 1 x)'
      @exp = @exp[1]
    end
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
    if exp[1].class == Hash && exp[2].class == Hash && %w[+ -].include?(exp[0])  # оба с переменными
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

p diff("(cos x)") #


config = [
  ["constant should return 0",                       "0",                    "5"],
  ["x should return 1",                              "1",                    "x"],
  ["x+x should return 2",                            "2",                    "(+ x x)"],
  ["x-x should return 0",                            "0",                    "(- x x)"],
  ["2*x should return 2",                            "2",                    "(* x 2)"],
  ["x/2 should return 0.5",                          "0.5",                  "(/ x 2)"],
  ["x^2 should return 2*x",                          "(* 2 x)",              "(^ x 2)"],
  ["cos(x) should return -1 * sin(x)",               "(* -1 (sin x))",       "(cos x)"],
  ["sin(x) should return cos(x)",                    "(cos x)",              "(sin x)"],
  ["exp(x) should return exp(x)",                    "(exp x)",              "(exp x)"],
  ["ln(x) should return 1/x",                        "(/ 1 x)",              "(ln x)"],
  ["x+(x+x) should return 3",                        "3",                    "(+ x (+ x x))"],
  ["(x+x)-x should return 1",                        "1",                    "(- (+ x x) x)"],
  ["2*(x+2) should return 2",                        "2",                    "(* 2 (+ x 2))"],
  ["2/(1+x) should return -2/(1+x)^2",               "(/ -2 (^ (+ 1 x) 2))", "(/ 2 (+ 1 x))"],
  ["cos(x+1) should return -1 * sin(x+1)",           "(* -1 (sin (+ x 1)))", "(cos (+ x 1))"],
  ["sin(x+1) should return cos(x+1)",                "(cos (+ x 1))",        "(sin (+ x 1))"],
  ["sin(2*x) should return 2*cos(2*x)",              "(* 2 (cos (* 2 x)))",  "(sin (* 2 x))"],
  ["exp(2*x) should return 2*exp(2*x)",              "(* 2 (exp (* 2 x)))",  "(exp (* 2 x))"],
]
