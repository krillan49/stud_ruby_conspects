#============================================
# https://ruby-doc.org/   Документация руби
#============================================

# https://www.tutorialspoint.com/ruby/index.htm
# http://phrogz.net/programmingruby/

# https://namingconvention.org/   -   ruby naming convention (как правильно называть переменные методы классы итд)

# В руби принято делать отступы 2мя пробелами а не табуляцией

# Код в руби можно писать через точку с запятой в одной строке
a = 5; puts a #=> 5


Kernel.methods #=> все методы, по которым можно посмотреть и другие методы

# & - это safe navigation. Убеждается, что объект не nil, после чего идёт дальше, либо возвращает nil
[1, 2, 3].find{|e| e.class == Array }&.sum #=> nil
[1, 2, 3].find{|e| e.class == Array }.sum #=> undefined method `sum' for nil:NilClass (NoMethodError)


# перевод 2ичной строки в 8битные числа перевод в 10чные и применение к ним .chr
['0100100001100101011011000110110001101111'].pack('B*') #=> "Hello"

'122.99.9.99.999'.next #=> "123.00.0.00.000"

# сравнение версий
Gem::Version.new('3.0.10') <=> Gem::Version.new('3.01.1') #=> -1


# tap позволяет манипулировать object и возвращать его после блока(создает новый объект те не мутирует):
[1,2].tap{ |arr| arr << 't'} #=> [1, 2, "t"]


p 'a'.itself #=> "a"
# пример применения
p 3.times.to_a.zip([:to_s,:to_f,:itself]).map{|s, o| s.send(o)} #=> ["0", 1.0, 2


# Подключение в текущий фаил всех фаилов из директории(тут support/) по относительному адресу
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each {|f| require f}
# File.dirname(__FILE__) - директория текущего фаила
# __FILE__ - специальная константа, указывающая на текущий фаил
# /**/ - тоесть все фаилы в этой директори или во всех поддиректориях
# *.rb - все фаилы с расширением .rb
# require f   - подгружаем каждый из найденных фаилов




#  Цвета для терминала для Руби и не толлько
print 'Enter :  '
word = gets.strip
loop do
  word.each_char do |chr|
    print "\u001b[38;5;#{rand(255)}m"
    print chr
    print "\u001b[0m"
  end
  print ' '
  sleep 0.03
end

print 'Enter : '
 word = gets.strip
 loop do
  background = "\e[48;5;#{rand(255)}m"
  word.each_char do |chr|
    print background
    print "\e[38;5;#{rand(255)}m"
    print chr,'-'
    print "\e[0m"
  end
  print "\e[0m"
  sleep 0.1
end

# ANSI коды
RESET = "\e[0m"      # Сброс
BOLD = "\e[1m"       # Жирный текст
UNDERLINE = "\e[4m"  # Подчеркивание

# Цвета текста (Foreground colors)
BLACK = "\e[30m"
RED = "\e[31m"
GREEN = "\e[32m"
YELLOW = "\e[33m"
BLUE = "\e[34m"
MAGENTA = "\e[35m"
CYAN = "\e[36m"
WHITE = "\e[37m"

# Цвета фона (Background colors)
BG_BLACK = "\e[40m"
BG_RED = "\e[41m"
BG_GREEN = "\e[42m"
BG_YELLOW = "\e[43m"
BG_BLUE = "\e[44m"
BG_MAGENTA = "\e[45m"
BG_CYAN = "\e[46m"
BG_WHITE = "\e[47m"

# Примеры использования
puts "#{BOLD}Это жирный текст#{RESET}"
puts "#{UNDERLINE}Это подчеркивание#{RESET}"
puts "#{RED}Это красный текст#{RESET}"
puts "#{GREEN}Это зеленый текст#{RESET}"
puts "#{BLUE}Это синий текст#{RESET}"
puts "#{YELLOW}Это желтый текст на черном фоне#{BG_BLACK}#{RESET}"

# Комбинирование стилей и цветов
puts "#{BOLD}#{MAGENTA}Это жирный и фиолетовый текст#{RESET}"
puts "#{UNDERLINE}#{CYAN}Это подчеркивание и голубой текст#{RESET}"


# Проверить разные символы chr(Encoding::UTF_8)
(0..0x10FFFF).each.with_index do |codepoint, i|
  puts codepoint.chr(Encoding::UTF_8)
  break if i == 500
end




# Существует ли ли в языке руби какой нибудь аналог winform что то типо форм ввода, кнопки, текстбоксы, поля итд...?
# FxRuby, ruby-gtk3, Tk, Shoes  - они почти все кросс-платформенные
# FxRuby и GTK(Ruby-GNOME2, Ruby-GNOME3) - наиболее популярные из них
# есть ли формы для винды и можно ли запускать приложения на руби с .exe файла?
# все что я перечислил - да, надо будет прост добавить еще один гем - какой нибудь Ocra или Rubyscript2exe или https://github.com/Largo/ocran
#
# Для игр
# надо брать либу типа sdl и компилить в wasm












#
