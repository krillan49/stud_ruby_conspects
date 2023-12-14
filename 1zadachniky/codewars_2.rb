# Symbolic differentiation of prefix expressions
# https://www.codewars.com/kata/584daf7215ac503d5a0001ae/train/ruby
class DiffExp
  def initialize(exp)
    @exp = exp_to_arr(exp)
  end

  def main
    recursion_cycle(@exp)
  end

  def recursion_cycle(exp) # гдето тут тупняк с рекурсией
    exp.map do |e|
      e = recursion_cycle(e) if e.class == Array
      e
    end
    simplify_inner_exp(exp)
  end

  def simplify_inner_exp(exp)
    p exp
    if exp.size == 1 && /^\d$/ === exp[0]
      '0'
    elsif !(/^\d$/ === exp[1]) && exp[1] == exp[2]
      hh = {'+'=>{exp[1]=>2}, '-'=>'0', '/'=>'1', '*'=>"(^ #{exp[1]} 2)"}
      hh[exp[0]]
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
             .map{|e|  /^\d*$|\[|\]| / === e ? e : "'#{e}'"}
             .join
             .gsub(/ /, ',')
    eval(exp)
  end

end


def diff(s)
  dif_exp = DiffExp.new(s)
  dif_exp.main
end

p diff("(- (+ x x) x)") # "1"

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
  ["Second deriv. sin(x) should return -1 * sin(x)", "(* -1 (sin x))",       "(sin x)"],
  ["Second deriv. exp(x) should return exp(x)",      "(exp x)",              "(exp x)"]
]
