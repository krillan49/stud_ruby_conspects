puts '                                         Регулярные выражения'

# Regexp.last_match - возвращает последнее совпадение последней регулярки ?
'jhfajbhvhg' =~ /(a|b|c)/
p Regexp.last_match #=> #<MatchData "b" 1:"b">
p Regexp.last_match(1) #=> "b"



# Регулярные выражения - Regular expression (regex)

# Ctrl + F   - в меню есть настройка для рег выражений(Тоесть можно заменять текст в фаилах прямо в редакторе при помощи рег выражений)
# Для их использования в меню поиска текстового редактора, он должен иметь поддержку find & replace (Все современные поддерживают)

# https://rubular.com/   -    Ruby-based regular expression editor(для тестирования регулярок)

# Регулярное выражение — это специальная последовательность символов, которая помогает сопоставлять или находить другие строки или наборы строк, используя специальный синтаксис, хранящийся в шаблоне. Нужны для проверки на совпадение или замены.

# Литерал регулярного выражения — это шаблон между косыми чертами или другими разделителями регулярного выражения
/pattern/

# https://docs.ruby-lang.org/en/master/Regexp.html



puts '                                    Разделители регулярных выражений'

# Ruby позволяет вам начинать регулярные выражения с символа %r, за которым следует разделитель по вашему выбору. Это полезно, когда описываемый вами шаблон содержит много символов косой черты, которые вы не хотите экранировать:
%r|/|          # соответствует одному символу косой черты, экранирование не требуется
%r!/usr/local! # общее регулярное выражение с ! разделителями
%r[</(.*)>]i   # Символы Flag также разрешены с помощью этого синтаксиса

# Пример с альтернативными разделителями и помещением регулярки в переменную:
reg = %r!<[^>]*>!
"<div>test</div>".gsub(reg, "") #=> "test"



puts '                                     Модификаторы регулярных выражений'

# Литералы регулярных выражений могут включать необязательный модификатор для управления различными аспектами сопоставления. Модификатор указывается после второго символа косой черты:
/pattern/im # может быть указано несколько опций сразу
# i       - Игнорирует регистр при сопоставлении текста.
# o       - Выполняет интерполяцию #{} только один раз, при первом вычислении литерала регулярного выражения.
# x       - Игнорирует пробелы и разрешает комментарии в регулярных выражениях
# m       - Соответствует нескольким строкам, распознавая новые строки как обычные символы.
# u,e,s,n - Интерпретирует регулярное выражение как Unicode (UTF-8), EUC, SJIS или ASCII. Если ни один из этих модификаторов не указан, предполагается, что регулярное выражение использует исходную кодировку.



puts '                                      Шаблоны регулярных выражений'

# За исключением управляющих символов + ? . * ^ $ ( ) [ ] { } | \, все символы соответствуют самим себе.
# Можно экранировать управляющий символ, поставив перед ним обратную косую черту "\".

/^/ # Соответсвует началу строки(в многострочном тексте - каждой(любой) строки)
'hello goodbye hello'.gsub(/^hello/, 'xuy') #=> "xuy goodbye hello"
"A\nB".gsub(/^/, '0')                       #=> "0A\n0B"

/$/ # Соответствует концу строки(в многострочном тексте - каждой строки)
"world, goodbye\ngoodbye, world".gsub(/bye$/, 'END') #=> "world, goodEND\ngoodbye, world"
"http://ex.com/events/
http://ex.com/places/".gsub(/$/, 'index.html') #=> "http://ex.com/events/index.html\nhttp://ex.com/places/index.html"

# Буквенные(Literal) символы:
/hgkjhg/ #=> 'hgkjhg' подстрока целиком соответсвует условию оператора

/[abc]/ # Соответсвует любому одиночному символу из указанных в скобках(a, b или c)
/[^abc]/ # Соответсвует любому одиночному символу кроме указанных в квадратных скобках после ^
# Квадратная скобка это каждый как в операторе tr

# Character Classes:
/[Rr]uby/     # Соответсвует "Ruby" или "ruby"
/[aeiou]/     # Соответсвует одной из букв в квадратных скобках(гласные) в нижнем регистре
/[0-9]/       # Соответсвует любой цифре, тоже что и /[0123456789]/
/[a-z]/       # Соответсвует любой строчной букве ASCII(русскрй может поддерживаться не всеми редакторами)
/[A-Z]/       # Соответсвует любой заглавной букве ASCII
/[a-zA-Z0-9]/ # Соответсвует любому символу из этих диапазонов
/[^aeiou]/    # Соответсвует любому символу кроме строчных гласных
/[^0-9]/      # Соответсвует любому символу кроме цифр

# Special Character Classes:
/./  # Соответсвует любому одиночному символу кроме новой строки. С параметром "m" соответствует и новой строке
/\d/ # Соответсвует любой цифре, эквивалентно /[0-9]/
/\D/ # Соответсвует нецифрам /[^0-9]/
/\s/ # Соответсвует пробелам(whitespase) /[\t\r\n\f]/   (\f - обычеый пробел ?)
/\S/ # Соответсвует непробельным символам /[^\t\r\n\f]/
/\w/ # Соответсвует символам слова /[A-Za-z0-9_]/
/\W/ # Соответсвует несловесным символам /[^A-Za-z0-9_]/
/\n/ # символ перевода строки;
/\t/ # символ табуляции;
/\v/ # символ вертикальной табуляции;
/\A/ # Соответсвует началу строки(в многострочном тексте началу 1й строки)
/\Z/ # Соответсвует концу строки. Если существует новая строка, она соответсвует непосредственно перед новой строкой
/\z/ # Соответсвует концу строки
/\G/ # Соответсвует точке где закончилось последнее совпадение
/\b/ # граница слов(не только пробел но и конец строки итд) вне квадратных скобок
  "hi world, it's hip".gsub(/\b/, '_')       #=> "_hi_ _world_, _it_'_s_ _hip_"
  'cat catatonic cat'.gsub(/cat\b/, '(!!!)') #=> "(!!!) catatonic (!!!)"
  '50000000000'.gsub(/0{6}\b/, ' millions')  #=> "50000 millions"
/\B/ # обозначает что символ должен быть не крайней буквой слова со стороны постановки \B, тоесть с этой стороны символ внутри слова, например \Babc соответсвует dabc или xabc
/\1/, /\9/ # Соответсвует энному сгруппированному подвыражению
/\1/ # Соответсвует 1му сгруппированному подвыражению если оно уже совпало. В противном случае относится к восьмеричному представлению кода символа
  'a+b c-d e'.gsub(/ ([a-zA-Z])/, '+\1') #=> "a+b+c-d+e"
/\uXXX/ # символ Unicdoe

# Случаи повторения:
/ruby*/   # Соответсвует 0 или более вхождениюям ("rub" плюс 0 или более "y")
/ruby+/   # Соответсвует 1 или более вхождениюям ("rub" плюс 1 или более "y")
/ruby?/   # Соотвествует 0 или 1 вхождению ("rub" или "ruby", символ y должен встречаться 0 или 1 раз)
/\d{3}/   # Соответсвует ровно 3м цифрам
/\d{3,}/  # Соответствует 3м и более цифрам
/\d{3,5}/ # Соответсвует 3, 4 или 5 цифрам

/<.*>/  # жадное повторение: соответсвует "<ruby>perl>" в "<ruby>perl>" (берет все символы до последнего символа(тут >))
/<.*?>/ # не жадное соответсвует "<ruby>" в "<ruby>perl>" (берет все символы до ближайшего символа(тут >))

# Альтернативы:
/ruby|rube/ # Соответсвует "ruby" или "rube"
/rub(y|le)/ # Соответсвует "ruby" или "ruble"
/ruby(!+|\?)/ # "ruby" за которым следует один или более знаков ! или один знак ?

# *далее re это некое предшествующее регулярное выражения:

# группировка со скобками:
/(re)/ # Группирует регулярные выражения и запоминает совпадающий текст
"bcdbcd".gsub(/bcd/, 'A')    #=> "AA"
"bcdbcd".gsub(/(bcd)+/, 'A') #=> "A"
/\D\d+/ # без группы (от + повторяется только \d)
/(\D\d)+/ # сгруппировано (от + повторяется пара \D\d)
/([Rr]uby(,)?)+/ # соответсвует например "Ruby, Ruby, ruby ruby" итд

# Группировка для разделения условий
'3/0 tsp aaa 2 tbsp 4 tspr'.gsub(/(\d+|\d\/\d) (tbsp|tsp)/, 'A') #=> "A aaa A Ar"

# Back References(назад ссылки):
/([Rr])uby&\1ails/ # Соответсвует "Ruby&Rails" или "ruby&rails". \1 - соответсвует 1й группировке в выражении

/(?: re)/ # Группирует регулярные выражения без запоминания совпадающего текста
/(?= re)/ # Задает положение при помощи шаблона. Не имеет диапазона
/(?! re)/ # Определяет позицию используя отрицание шаблона. Не имеет диапазона

/rub(?:y|le)/ # Только группа без создания обратной ссылки \1
/Ruby(?=!)/ # Соответсвует "Ruby" если за ним стоит восклицательный знак
/Ruby(?!!)/ # Соответсвует "Ruby" если за ним не стоит восклицательный знак
/^(?=.*[A-Z])(?=.*[0-9])[A-Z0-9]{6,}$/ # Регулярное выражение утверждает, что где-то в строке есть алфавитный символ в верхнем регистре(?=.*[A-Z]), и утверждает, что где-то в строке есть цифра(?=.*[0-9]), а затем проверяет, является ли все буквенным символом или цифрой и что колличество символов больше или равно 6.

/(?#...)/      # Комментарий
/R(?#comment)/ # Соответсвует "R" все остальное комментарий

/R(?!)uby/ # Нечувствителен к регистру при сопоставлении "uby"
/R(?!:uby)/ # Тоже что и выше

#         (!НЕпонятные)
/(?> re)/ # Соответсвует независимому шаблону без возврата
/(?imx)/ # Временно включает опции i, m или x в регулярном выражении, если в скобках затрагивается только эта область
/(?-imx)/ # Временно отключает параметры i, m или x в регулярном выражении, если в скобках затрагивается только эта область
/(?imx: re)/ # Временно включает опции i, m или x в скобках
/(?-imx: re)/ # Временно отключает параметры i, m или x в скобках
#         (!НЕпонятные)



puts '                                       Переменные регулярных выражений'

# (?<per>reg_part) - переменная
str_href = 'hello ((page1/page2/page3 [ctr]))'
p str_href.gsub(/\(\((?<path>[^ ]*)(.+)\)\)/, '<a href="[site]/\k<path>"></a>') #=>
# (?<path>[^\*]*) тоесть это переменная, в которую присваивается следующая за ней внутри тех же скобок регулярка, а в выводе \k<path> ее вызывает
# Но изза этой переменной есть проблемы с последующими обратными ссылками



puts '                                           Regexp class'

# Экранирование управляющих элементов
Regexp.escape("-..,.44$&%$--,.,") #=> "\\-\\.\\.,\\.44\\$&%\\$\\-\\-,\\.,"



puts '                                           Интерполяция'

# Интерполяция в регулярку
name = 'Vasya'
'strgVasyajhlhj'.gsub(/[^#{name}]/, '') #=> "sVasya"
"ultrarevolutionariees".scan(/#{'.'*2}/) #=> ["ul", "tr", "ar", "ev", "ol", "ut", "io", "na", "ri", "ee"]

# Интерполяция "сложная"
div_by_4 = /^\d*(#{('00'..'96').step(4).to_a.join('|')})$/
# тоже без интерполяции
div_by_4 = /([048]|(\d*([02468][048]|[13579][26])))$/



puts '                                       sub и gsub (Поиск + замена)'

# sub, gsub, sub!, gsub! - эти методы выполняют операцию поиска и замены с использованием шаблона Regexp.
# sub и sub! заменяет первое вхождение шаблона
# gsub & gsub! заменяет все вхождения.

"text\n0987, asd".gsub(/[0-9 ,\s]/, '')       #=> "textasd"                  # удаляем символы "0-9 ,\s"
"quick brown\n\nfox jumps".gsub(/\n\n/, '\n') #=> "quick brown\\nfox jumps"  # убираем пустую строку

phone = "2004-959-559 #This is Phone Number"
phone.sub!(/#.*$/, "") #=> 2004-959-559  # удаляем Ruby-style коментарии
phone.gsub!(/\D/, "")  #=> 2004959559    # удаляем все кроме цифр

# Меняет любую гласную на (!!!)
'ytesuityFTGFDI'.gsub(/[aeiou]/i, '(!!!)') #=> "yt(!!!)s(!!!)(!!!)tyFTGFD(!!!)"

# Замена на подвыражение. Обязательно одинарные скобки у 2го аргумента либо экранирование в 2йных
"phone number is (555) 867-5309".gsub(/.*\((\d+)\).*/, '\1') #=> "555"
"phone number is (555) 867-5309".gsub(/.*\((\d+)\).*/, "\1") #=> "\u0001"
"a+b c-d".gsub(/ ([a-zA-Z])/, "+\\1")                        #=> "a+b+c-d"

# Применение методов только для символов соотв регулярному выражению
'AEiouBCDfgh'.gsub(/[aeiou]/i, &:swapcase) #=> "aeIOUBCDfgh"
"ab-c 1d*30".gsub(/\w+/, &:reverse)        #=> "ba-c d1*03"

# Условие-хэш в gsub(замены разных символов на разные строки)
'abcd'.gsub!(/[ac]/, "a" => "X1", "c" => "Y2") #=> "X1bY2d"

# Блок для итерации по символу в gsub(в блок передаются и изменяются те подстроки что соотв условию, остальные части строки остаются неизменными)
'hello http://world.com !'.gsub(/http:\/\/[^ ]+/){|match| "<a href=\"#{match}\">#{match}</a>" } #=> hello <a href="http://world.com">http://world.com</a> !'
'abcdabcd'.gsub!(/[abc]/){|с| с == 'a' ? 'X' : 'y'} #=> "XyydXyyd"
'abcABC'.gsub(/[A-Z]/){|c| (c.ord - 65 - (c >= 'J' ? 1 : 0)).divmod(5).map{|x| x + 1}.join} #=> "abc111213"
"fun((a,b){a b})".gsub(/\{.+\}/){|c| c.gsub(/\b([a-z_]\w*)\b ?/, '\1;') } #=> "fun((a,b){a;b;})"



puts '                                             =~ и !~'

# =~ (тильда равенства) и !~ (тильда-тильда) - операторы/методы сопоставления с образцом, они используются для сопоставления строк и символов с шаблонами регулярных выражений.
# =~ - когда строка или символ соответствует шаблону регулярного выражения, возвращается целое число, которое является позицией (индексом) совпадения. Если совпадений нет, возвращается nil.
# !~ - является противоположностью оператора =~: он возвращает true, если совпадений нет, и false, если совпадение есть.

# Реализация этих методов в классах String и Symbol ожидает, в качестве аргумента, регулярное выражение (экземпляр класса Regexp).
"practice zazen" =~ /zen/                #=> 11
"practice zazen" =~ /discursive thought/ #=> nil
:zazen =~ /zen/                          #=> 2
:zazen =~ /discursive thought/           #=> nil

# Реализация класса Regexp ожидает в качестве аргумента строку или символ.
/zen/ =~ "practice zazen"     #=> 11
/zen/ =~ "discursive thought" #=> nil

# в Ruby любое целочисленное значение является «истинным», а nil — «ложным», поэтому оператор =~ можно использовать в операторах if и тернарных операторах.
"yes" if "zazen" =~ /zen/       #=> yes
"zazen" =~ /zen/ ? "yes" : "no" #=> yes

# Операторы сопоставления с образцом также полезны для написания более коротких операторов if, чтобы вместо такого
true if meditation_type == "zazen" || meditation_type == "shikantaza" || meditation_type == "kinhin"
# Написать что-то такое:
true if meditation_type =~ /^(zazen|shikantaza|kinhin)$/


# поиск индекса символа
'foo' =~ /f/ # => 0
'foo' =~ /o/ # => 1
'foo' =~ /a/ # => nil

# сосчитать кол символов в строке при помощи индекса конца строки $
"!!!!!" =~ /$/ #=> 5

# Включает ли значение переменной(возвращает ли индекс или nil) слово alligator вне зависимости от регистра
animal = 'тAlligAtorgoh'
animal =~ /alligator/i ? true : false #=> true



puts '                                               match?'

# Проверяет строку на соответсвие регулярке и возвращает true или false
'vasya123'.match?(/^[a-z\d_]{4,16}$/) #=> true   # только строчные буквы цифры и подчеркивание длинна строки от 4 до 16
'bbba'.match?(/[^aeiou]$/)            #=> false  # Оканчивается ли слово на согласную и "y"



puts '                                               split'

# Разбивка по подстрокам соотв регулярному выражению
"{{name}} likes {{animal_type}}".split(/[{}]/) #=> ["", "", "name", "", " likes ", "", "animal_type"]
"ultrarevolutionariees".split(/[^aeiou]/)      #=> ["u", "", "", "a", "e", "o", "u", "io", "a", "iee"]
" AbfCgg di Ejjj fii ".split(/\b/)             #=> [" ", "AbfCgg", " ", "di", " ", "Ejjj", " ", "fii", " "]
"AbfCgg di Ejjj fii".split(/ab|fi/i)           #=> ["", "fCgg di Ejjj ", "i"]
"asd fgh g\njku".split(/^\n| /)                #=> ["asd", "fgh", "g\njku"]



puts '                                               scan'

# Поиск слов в строке. Вырезает соотв подстроку
"milkshakepizzachickenfriescokeburgerpizzasandwichmilkshakepizza".scan(/milkshake/) #=> ["milkshake", "milkshake"]
"milkshakepizzachickenfriescokeburgerpizzasandwichmilkshakepizza".scan('milkshake') #=> ["milkshake", "milkshake"]

# Вырезат совпадения в скобках, при большим числе скобок, увеличивает длинну подмассивов, для каждого условия
text = "aLways seems  imPossible unti9l"
text.scan(/[a-z]([A-Z])/)              #=> [["L"], ["P"]]
text.scan(/[a-z]([A-Z])| ( )/)         #=> [["L", nil], [nil, " "], ["P", nil]]
text.scan(/[a-z]([A-Z])| ( )|([0-9])/) #=> [["L", nil, nil], [nil, " ", nil], ["P", nil, nil], [nil, nil, "9"]]

# Вернуть все буквы стоящие после символов заданных переменной letter в строке
str.scan(/(?<=#{letter})[a-z]/i).join

# метод scan вырезает только части выражения в скобках если строка соотв всему выражению иначе возвращает пустой массив
logparser = /\A(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}) {1,}(ERROR|INFO|DEBUG) {1,}\[([a-z0-9]{1,}):{0,1}([a-z0-9]{1,}):{0,1}([a-z0-9]{1,}){0,1}\] {1,}([a-zA-Z' ]{1,})\z/
p "2003-07-08 16:49:45,896 ERROR [user1:mainfunction:subfunction] We have a problem".scan(logparser)
#=> [["2003-07-08 16:49:45,896", "ERROR", "user1", "mainfunction", "subfunction", "We have a problem"]]
# возвращает элемент nil в массив если данное подвыражение отсутсвует(если это отсутсвие соотв выражению({0,}))
p "2003-07-08 16:49:46,896 INFO [user1:mainfunction] We don't have a problem".scan(logparser)
#=> [["2003-07-08 16:49:46,896", "INFO", "user1", "mainfunction", nil, "We don't have a problem"]]



puts '                                               ==='

# Регистр-равенство(===) в Реализации регулярного выражения - возвращает true, если строка справа соответствует регулярному выражению слева.
/zen/ === "practice zazen today" #=> true
# Это то же самое, что и:
"practice zazen today" =~ /zen/

# Переменная содержит какоето из этих слов(переменная всегда справа)
/hello|ciao|salut|hallo|hola|ahoj|czesc/i === greetings
p /hello|ciao|salut|hallo|hola|ahoj|czesc/i === 'AAAhallo' #=> true
# Содержится ли символ в икс
/[a-z]/ === x
# Соответсвие(каждая точка любой символ, число точек должно соотв числу пропущ символов)
/code...s/ === "codewars" #=> true
# строка должна содержать подстроку соотв выражению(тут поиск с подстрокой из оп символов опр размера)
s = 'abc'
/[#{s}]{#{s.size}}/ === 'Zabcc' #=> true
/[#{s}]{#{s.size}}/ === 'aacc' #=> true
/[#{s}]{#{s.size}}/ === 'aa' #=> false

# Принадлежит ли значение диапазону
('0'..'255') === '245' #=> true

# проверяет - строка состоит из эн одинаковых подстрок("abbaabbaabba" - true, "abbabbabba"-false)
/\A(\w+)\1+\z/ === s



puts '                                               Разные примеры'

# Подсчет символов соотв
s.count('^a-zA-Z0-9')

# убирает все символы после символа #
url = 'https://www.codewars.com/#ukfkh67879900jnjn'
url[/[^#]+/] #=> "https://www.codewars.com/"

# Не содержится ли символы в строке
self !~ /\S/

# начинается ли с строка с одной или другой буквы
"pello".start_with?(/H|P/i) #=> true

# строка соответсвует '+1 MDZHB 80 516 GANOMATIT 21 23 86 25'(только это 2цифры 3цифры люб.аглавные 4раза по 2 цифры)
!!(message =~ /\+1 \AMDZHB \d{2} \d{3} [A-Z]+ \d{2} \d{2} \d{2} \d{2}\z/)

# Совокупность многих условий
[/[A-Z]/, /[a-z]/, /\d/, /.{8}/].all?{ |re| string =~ re }

















#
