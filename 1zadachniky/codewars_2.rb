# Expression Transpiler     https://www.codewars.com/kata/597ccf7613d879c4cb00000f/train/ruby

# Мб переделать заново и посчитать лямбды со стрелкой в конце ??

def transpile(exp)
  # убираем пробелы:
  exp = exp.strip
           .gsub(/\n/, '')
           .gsub(/( )\1+/, '\1')
           .gsub(/(\W) (\w)/, '\1\2')
           .gsub(/(\W) (.)/, '\1\2')
           .gsub(/(\w) (\W)/, '\1\2')
           .gsub(/(\W) (\W)/, '\1\2')
  # p exp
  return '' if exp.match?(/[^\w (){},->\n]/) # "%^&*("
  return '' if exp.match?(/[\d\w][^ ,\d\w(){}][\d\w]/) # "e>i"
  return '' if exp.match?(/(^|[ (){}])\d[a-z]/) #
  return '' if exp.match?(/^\(/) #
  return '' if exp.match?(/\)\w/) #
  return '' if exp.match?(/[\w\d],\)/) # "f(a,)"
  return '' if exp.match?(/\(,[\w\d]/) # 'f(,a)'
  return '' if exp.match?(/\(,/) # 'i(,{})'
  return '' if exp.gsub(/\{.*?\}/, '').include?(' ') # "o(V w o,b y{1,k->N M})"
  return '' if exp.match?(/[^\w]->/) # 'f(->)'
  return '' if exp.match?(/\{.*\}\{.*\}\{.*\}/) # '{}{}{}'
  return '' if exp.match?(/\{[\d\w]+ [^}]+->[^}]*\}/) # '{x y d->stuff}'
  return '' if exp.match?(/\{.*->[\d\w]+,.*\}/) # '{x,y,d->stuff,g,h}'
  return '' if exp.match?(/\{[\d\w]+,[^>]*\}/) # '{x,y,d jj}'
  return '' if exp.match?(/\}[\d\w]/) # "{}gYF2"
  # return '' if exp.gsub(/[\d\w]+(\(.*\)|\{.*\})/, '').gsub(/(\(.*\)|\{.*\})/, '').match?(/[\d\w]+/) # "that(is,the){}question"
  return '' if exp.tr('^({', '').size == 0 # 'a b c'
  return '' if exp.tr('^(', '').size != exp.tr('^)', '').size # "f(12,a"
  return '' if exp.tr('^{', '').size != exp.tr('^}', '').size # 'f({a->)'

  # общее 1й порядок (подготовка)
  exp = exp.gsub(/(\{.*\})(\{.*\})/, '\1(\2)') # '{...}{...}' => '{...}({...})'
  exp = exp.gsub(/([a-z_]\w*)(\{.*\})/, '\1(\2)') # 'fun{...}' => => 'fun({...})'

  # частное
  exp = exp.gsub(/([^)]|^)\{\}/, '\1(){}') # '{}' => '(){}'
  exp = exp.gsub(/\(\)\{\}\(\)\{\}/, '(){}((){})') # "(){}(){}" => "(){}((){})"
  # p exp
  exp = exp.gsub(/(\{.*\})\(([\d\w,]+)\)\{([\d\w,]*)->(.*)\}/, '\1(\2,(\3){\4})') # "{a->a}(cde,y,z){x,y,d->stuff}" => "(a){a}(cde,y,z,(x,y,d){stuff})"
  # p exp
  exp = exp.gsub(/([a-z_]\w*|\()\{([a-z_][\w,]*)\}/, '\1(){\2}') # "run{a}" => "run((){a})"
  # p exp
  while exp.include?('->')
    exp = exp.gsub(/\{([\d\w,]*)->(.*)\}/, '(\1){\2}') # '{a,b->a b}' => "(a,b){a b}"
  end
  # p exp
  exp = exp.gsub(/\{.+?\}/){|c| c.gsub(/\b([a-z_]\w*)\b ?/, '\1;')} # "fun((a,b){a b})" => "fun((a,b){a;b;})"
  exp = exp.gsub(/\{.+?\}/){|c| c.tr(' ', ';').gsub(/([^{;])\}/, '\1;}')} #=> "(c,in,8){n;22 1} => "(c,in,8){n;22;1;}"

  exp = exp.gsub(/([a-z_]\w*)(\(\)\{\})/, '\1(\2)') # "call(){}"     => "call((){})"
  # p exp
  exp = exp.gsub(/([a-z_]\w*\()([^()]+)\)\{\}/, '\1\2,(){})') # "invoke(a,b)(){}"=>"invoke(a,b,(){})"
  exp = exp.gsub(/(\{.*\}\()([^()]+)\)(\{.*\})/, '\1\2,()\3)') # "{6;2;}({7;E;},z){9;_t;}"=>"{6;2;}({7;E;},z,(){9;_t;})"
  # p exp

  # Последняя - Тут проблема с "f({a->a})"  ->  "f((a){a;})" => "f((a,{a;}))"
  exp = exp.gsub(/([\w\d]+)\((.+)\)(\{.+\})$/, '\1(\2,\3)') # "R((g,Q){h;D;},(2,g){J;6;}){2;Q;}">"R((g,Q){h;D;},(2,g){J;6;},{2;Q;})"

  # p exp
  exp = exp.gsub(/([a-z_]\w*)\((\w+)\)\{(.*)\}/, '\1(\2,(){\3})') # "run(a){as;}" => "run(a,(){as;})"

  exp = exp.gsub(/([a-z_]\w*)\(\)\((.*)\)\{(.*)\}/, '\1((\2){\3})') # "f()(a,b){}"   => "f((a,b){})"
  exp = exp.gsub(/([a-z_]\w*)\(([\w,]*)\)\((.*)\)\{(.*)\}/, '\1(\2,(\3){\4})') # "f(a,b)(a){a;}"    => "f(a,b,(a){a;})"

  # контрольгая скобка там где не проставилась:
  while exp.match?(/([^)]|^)\{.*\}/)
    exp = exp.gsub(/([^)]|^)(\{.*\})/, '\1()\2') # '{...}' => '(...){...}'
  end

  exp
  # nil
end

# exp = "R({g,Q->h D},{2,g->J 6}){2 Q}"
# p transpile(exp) # "R((g,Q){h;D;},(2,g){J;6;},(){2;Q;})"
# #                  "R((g,Q){h;D;},(2,g){J;6;},(){2;Q;})"

p transpile("f(a,b){a->a}")             # "f(a,b,(a){a;})"



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
# p transpile("{c,in,8->n 22 1}{h B5}") # "(c,in,8){n;22;1;}((){h;B5;})"
# p transpile("{a->a}(233)")          # "{a->a}(233)"      => "(a){a;}(233)"
# p transpile('{a, b -> a b} (1, 2)') # '{a,b->a b}(1,2)'  => '(a,b){a;b;}(1,2)'
# p transpile('f { a -> }')           # 'f{a->}'           => 'f((a){})'
# p transpile("call(\n){}")           # "call(){}"         => "call((){})"
# p transpile('fun(a, {})')           # 'fun(a,{})'        => 'fun(a,(){})'
# p transpile('fun(a) {}')            # 'fun(a){}'         => 'fun(a,(){})'
# p transpile("invoke (a,  b ) { } ") # "invoke(a,b){}"    => "invoke(a,b,(){})"
# p transpile("f({a->})")             # "f({a->})"         => "f((a){})"
# p transpile("f(x){a->}")            # "f(x){a->}"        => "f(x,(a){})"
# p transpile("f(a,b){a->a}")         # "f(a,b){a->a}"     => "f(a,b,(a){a;})"
# p transpile('f(){a,b->}')                # 'f(){a,b->}'     => "f((a,b){})"
# p transpile("run(a){as}")                # "run(a,(){as;})"
# p transpile("{a}()")                # "(){a;}()"
# p transpile("{a->a}(cde,y,z){x,y,d -> stuff}  ")                # "(a){a;}(cde,y,z,(x,y,d){stuff;})"

# p transpile("call(\n){}")                          # "call(){}"      => "call((){})"
# p transpile("invoke  (       a    ,   b   )")      # "invoke(a,b)"   => "invoke(a,b)"
# p transpile(" \n  call\n  \n  \n(\n   \n \n )\n  \n   ")                # "call()"

# p transpile("%^&*(")                               # ''
# p transpile("x9x92xb29xub29bx120()!(")             # ''
# p transpile("f(12,a")                #  ''
# p transpile("f(a,)")                # ''
# p transpile('a b c')                # ''
# p transpile('f (,a)')                # ''
# p transpile('f( a v)')                # ''
# p transpile('i(,{})')                # ''
# p transpile('{}{}{}')                # ""
# p transpile("{a->a}(cde,y,z){x y d->stuff}")                # ""
# p transpile("{a->a}(cde,y,z){x,y,d->stuff,g,h}")                # ""
# p transpile("{a}(cde,y,z){x,y,d jj}")                # ""
# p transpile("{}gYF2") # ""
# p transpile("that(is,the){}question")                # ""
# p transpile("e>i")                # ""
