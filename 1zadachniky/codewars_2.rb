# Expression Transpiler     https://www.codewars.com/kata/597ccf7613d879c4cb00000f/train/ruby
def transpile(exp)
  return '' if exp.match?(/[^\w (){},->\n]/)
  # убираем пробелы:
  exp = exp.strip
           .gsub(/( )\1+/, '\1')
           .gsub(/(.) (\w)/, '\1\2')
           .gsub(/(\W) (.)/, '\1\2')
           .gsub(/(\w) (\W)/, '\1\2')
           .gsub(/(\W) (\W)/, '\1\2')
           .gsub(/\n/, '')
  # общее 1й порядок (подготовка)
  exp = exp.gsub(/(\{.*\})(\{.*\})/, '\1(\2)') # '{...}{...}' => '{...}({...})'
  exp = exp.gsub(/([a-z_]\w*)(\{.*\})/, '\1(\2)') # 'fun{...}' => => 'fun({...})'

  # частное
  exp = exp.gsub(/([^)]|^)\{\}/, '\1(){}') # '{}' => '(){}'

  exp = exp.gsub(/([a-z_]\w*|\()\{([a-z_][\w,]*)\}/, '\1(){\2}') # "run{a}" => "run((){a})"
  # exp = exp.gsub(/\{([a-z_][\w,]*)->(.*)\}/, '(\1){\2}') # 'fun{a,b->a b}' => "fun((a,b){a b})"
  exp = exp.gsub(/\{([a-z_][\w,]*)->(.*)\}/, '(\1){\2}') # 'fun{a,b->a b}' => "fun((a,b){a b})"
  exp = exp.gsub(/\{.+\}/){|c| c.gsub(/\b([a-z_]\w*)\b ?/, '\1;') } # "fun((a,b){a b})" => "fun((a,b){a;b;})"

  # эта регулярка ломает "f((a){})" в "f((a,(){}))"
  # exp = exp.gsub(/([a-z_]\w*\()(.*)\)\{\}/, '\1\2,(){})') # "fun(a)(){}"=>'fun(a,(){})', "invoke(a,b)(){}"=>"invoke(a,b,(){})"
  exp
end

# Эти примеры охватывают все возможности языка
p transpile("f({a->})")             # "f({a->})"         => "f((a){})"
# p transpile("f(x){a->}")            # "f(x){a->}"        => "f(x,(a){})"
# p transpile("f(a,b){a->a}")         # "f(a,b){a->a}"     => "f(a,b,(a){a;})"


# p transpile('fun()')                # 'fun()'            => 'fun()'
# p transpile('fun(a)')               # 'fun(a)'           => 'fun(a)'
# p transpile('fun(a, b)')            # 'fun(a,b)'         => 'fun(a,b)'
# p transpile('{}()')                 # '{}()'             => '(){}()'
# p transpile('{}{}')                 # '{}{}'             => '(){}((){})'
# p transpile("call({})")             # "call({})"         => "call((){})"
# p transpile('fun {}')               # 'fun{}'            => 'fun((){})'
# p transpile("run{a}")               # "run{a}"           => "run((){a;})"
# p transpile('fun {a -> a}')         # 'fun{a->a}'        => 'fun((a){a;})'
# p transpile("f({a->a})")            # "f({a->a})"        => "f((a){a;})"
# p transpile('fun { a, b -> a b }')  # 'fun{a,b->a b}'    => 'fun((a,b){a;b;})'
# p transpile("{a->a}(233)")          # "{a->a}(233)"      => "(a){a;}(233)"
# p transpile('{a, b -> a b} (1, 2)') # '{a,b->a b}(1,2)'  => '(a,b){a;b;}(1,2)'
# p transpile('f { a -> }')           # 'f{a->}'           => 'f((a){})'
# p transpile('fun(a, {})')           # 'fun(a,{})'        => 'fun(a,(){})'
# p transpile('fun(a) {}')            # 'fun(a){}'         => 'fun(a,(){})'
# p transpile("invoke (a,  b ) { } ") # "invoke(a,b){}"    => "invoke(a,b,(){})"

# p transpile("call(\n){}")                          # "call(){}"      => "call((){})"
# p transpile("invoke  (       a    ,   b   )")      # "invoke(a,b)"   => "invoke(a,b)"

# p transpile("%^&*(")                               # ''
# p transpile("x9x92xb29xub29bx120()!(")             # ''
