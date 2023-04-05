puts '                                  Отслеживание ошибок (Exceptions/Исключения)'

# (НЕПОНЯТНЫЙ МОМЕНТ 1)  Catch и Throw(?)
# (НЕПОНЯТНЫЙ МОМЕНТ 2)  Class Exception(Классы исключений)(?)

# Программа останавливается, если возникает исключение. Таким образом, исключения используются для обработки различных типов ошибок, которые могут возникнуть во время выполнения программы, и предпринимают соответствующие действия вместо полной остановки программы.

(t[i-1].count{|el| el=='O~'} rescue 0)+(t[i+1].count{|el| el=='~O'} rescue 0)


puts
# Обрабатываются исключения с использованием конструкции rescue. Опционально можно указать тип обрабатываемого исключения (по умолчанию обрабатываются все) и получение информации. Также можно добавлять блоки else (выполняется, если исключения отсутствовали) и ensure (выполняется в любом случае).
begin
# ... проверяемый код
rescue RuntimeError => e
  # обрабатываем конкретный тип ошибок
  puts e # напечатаем сообщение об ошибке
rescue
  # можно писать rescue => e, чтобы получить объект исключения
  # обрабатываем все исключения
else
  # сработает, если исключений не было
ensure
  # сработает в любом случае
end


puts
# Пример несколько ошибок
list = [9, 67, 5, 35, "sisya"]
begin # пробуем что-то сделать
  num = 10 / 0  # Ошибка(ZeroDivisionError) тк на 0 делить нельзя. Изза ошибки весь код что за ней не будет выполняться
  list["dog"] # Ошибка(TypeError) - обращение к массиву как к хэшу
# При данном походе непонятно какая именно ошибка и где именно она
rescue # Отслеживание на ошибку (Запускается если поле begin выявлена какая либо ошибка)
  puts "Какая-то ошибка"
end # После end дальнейший код работает нормально
puts "pisya"

# пример 1 ошибка
begin
  file = File.open("/unexistant_file")
  puts "File opened successfully" if file
rescue
  file = 'file is not exist'
end
puts file #=> file is not exist


puts
# (retry)Можно зафиксировать исключение, используя блок восстановления, а затем использовать оператор повторной попытки, чтобы выполнить блок начала с самого начала.
fname = "/unexistant_file"
begin
  # Исключения, вызванные этим кодом, будут перехвачены следующим предложением rescue
  file = File.open(fname)
  if file
    puts "File opened successfully"
    p file.read
    file.close
  end
rescue
  # Этот блок будет фиксировать все типы повторных попыток исключения
  fname = "ruby_exemples/text/simple.txt"
  retry # Это переместит элемент управления в начало begin
end
#=> "File opened successfully\n""Работа с файлами это распространенная вещь в программировании. Нам постоянно ..."
# Исключение произошло при открытии. Пошел rescue, fname было переназначено. По повторной попытке пошел к началу начала. На этот раз файл успешно открывается. Продолжение основного процесса.
# если файл с повторно замененным именем не существует, этот пример кода повторяется бесконечно. Будьте осторожны, если вы используете повторную попытку для процесса исключения


puts
# Определение ошибок по их типам например ZeroDivisionError или TypeError, ошибка указана при запуске в скобках
begin
  list["dog"]
  num = 10 / 0
  list["cat"]
rescue TypeError
  puts "TypeError" # Выведется только это, тк обрабатывет по первой строке из списка begin, "ZeroDivisionError" - выведено уже не будет.
rescue ZeroDivisionError
  puts "ZeroDivisionError"
end
puts "pisya"


puts
# Автоматическое описание типа ошибки через задание переменной
begin
  num = 10 / 0
rescue ZeroDivisionError => e
  puts e
end


puts
puts '                                            raise - оператор повышения'

# (raise) - оператор повышения. Исключения возбуждаются(Вызываются) с помощью конструкции raise (или fail), опционально могут быть добавлены текст с сообщением, тип исключения и информация о стеке вызовов:
raise # (OR...) просто повторно вызывает текущее исключение (или RuntimeError, если текущего исключения нет). Используется в обработчиках исключений, которым необходимо перехватить исключение перед его передачей.
raise "Error Message" # (...OR...) создает новое исключение RuntimeError , устанавливая его сообщение в заданную строку. Затем это исключение поднимается вверх по стеку вызовов.
raise ExceptionType, "Error Message" # (...OR...) использует первый аргумент для создания исключения, а затем устанавливает связанное сообщение со вторым аргументом.
raise ExceptionType, "Error Message" condition # (...OR) похожа на предыдущее, но вы можете добавить любой условный оператор, например, если не вызывает исключение.

begin
  puts 'I am before the raise.'
  raise 'An error has occurred.'
  puts 'I am after the raise.'
rescue
  puts 'I am rescued.'
end
puts 'I am after the begin block.'
#=> I am before the raise. #=> I am rescued. #=> I am after the begin block.

begin
   raise 'A test exception.'
rescue Exception => e
   puts e.message
   puts e.backtrace.inspect
end
#=> A test exception.
#=> ["E:/doc/ruby_exemples/test2.rb:2:in `<main>'"]


puts
puts '                                     ensure(гарантии/обеспечения)'

# Иногда нужно гарантировать, что некоторая обработка выполняется в конце блока кода, независимо от того, было ли возбуждено исключение. Например, у вас может быть файл, открытый при входе в блок, и вам нужно убедиться, что он закрывается при выходе из блока.
# гарантия идет после последнего предложения rescue и содержит кусок кода, который всегда будет выполняться, когда блок завершается. Неважно, завершается ли блок нормально, если он вызывает и спасает исключение или завершается из-за неперехваченного исключения, блок ensure будет запущен.
begin
  raise 'A test exception.'
rescue Exception => e
  #.. обработайте ошибку
  puts e.message
  puts e.backtrace.inspect
ensure
  #.. finally обеспечить выполнение
  puts "Ensuring execution" #.. Это всегда будет выполняться.
end
#=> A test exception.
#=> ["E:/doc/ruby_exemples/test2.rb:2:in `<main>'"]
#=> Ensuring execution


puts
puts '                                      Использование оператора else'

# Если присутствует предложение else, оно идет после предложений rescue и перед любыми ensure. Тело предложения else выполняется только в том случае, если основная часть кода не вызывает никаких исключений.
begin
  #.. процесс
  # raise 'A test exception.' #..вызвать исключения
  puts "I'm not raising exception"
rescue Exception => e # .. обработайте ошибку
  puts e.message
  puts e.backtrace.inspect
else
  #.. выполняется, если нет исключения.
  puts "Congratulations-- no errors!"
ensure
  #.. Это всегда будет выполняться.
  puts "Ensuring execution"
end
#=> I'm not raising exception
#=> Congratulations-- no errors!
#=> Ensuring execution

# Сообщение об ошибке может быть перехвачено с помощью $! переменная.


puts
puts '                                                 Catch и Throw(?)'

# Хотя механизм исключений raise и rescue отлично подходит для отказа от выполнения, когда что-то идет не так, иногда нужна возможность выпрыгнуть из какой-то глубоко вложенной конструкции во время обычной обработки. Вот где catch и throw пригодится.

# catch определяет блок, который помечен заданным именем (которое может быть Symbol или String). Блок выполняется нормально, пока не встретится throw.

# Синтаксис
throw :lablename
#.. это не будет выполнено
catch :lablename do
#.. соответствующий catch будет выполнен после обнаружения throw.
end

# Синтаксис 2
throw :lablename condition
#.. это не будет выполнено
catch :lablename do
#.. соответствующий catch будет выполнен после обнаружения throw.
end

# (НЕПОНЯТНО)В следующем примере используется catch для прекращения взаимодействия с пользователем, если '!' вводится в ответ на любое приглашение.
def promptAndGet(prompt)
  print prompt
  res = readline.chomp
  throw :quitRequested if res == "!"
  return res
end

catch :quitRequested do
  name = promptAndGet("Name: ")
  age = promptAndGet("Age: ")
  sex = promptAndGet("Sex: ")
  # ..
  # process information
end
promptAndGet("Name:")

# Вы должны попробовать вышеуказанную программу на своем компьютере, потому что она требует ручного взаимодействия. Это даст следующий результат —
#Name: Ruby on Rails
#Age: 3
#Sex: !
#Name:Just Ruby


puts
puts '                                                Ошибки в методе'

# С yield и соответсвенно блоком
def compute
  yield
end
p compute { "Block" } #=> "Block"
# Если блок не передан возникнет ошибка `compute': no block given (yield) (LocalJumpError)
p compute #=> `compute': no block given (yield) (LocalJumpError)

# Для исправления используем rescue и описание(по желанию)
def compute
  yield rescue "Do not compute"
end
p compute { "Block" } #=> "Block"
p compute #=> "Do not compute"


# Обычная функция:
def problem x
  x*50+6 rescue 'Error'
end
problem 'fff' #=> 'Error'


puts
puts '                                         Class Exception(Классы исключений)(?)'

# Стандартные классы и модули Ruby вызывают исключения. Все классы исключений образуют иерархию с классом Exception наверху. Следующий уровень содержит семь различных типов: Interrupt,  NoMemoryError,  SignalException,  ScriptError,  StandardError,  SystemExit. ScriptError, и StandardError имеют ряд подклассов. На этом уровне есть еще одно исключение, Fatal, но интерпретатор Ruby использует его только внутри себя.
# Если мы создадим свои собственные классы исключений, они должны быть подклассами либо класса Exception, либо одного из его потомков.

# Создаем наш класс исключений
class FileSaveError < StandardError
  attr_reader :reason
  def initialize(reason)
    @reason = reason
  end
end
# Используем наш класс исключений:
File.open(path, "w") do |file|
  begin
    # Write out the data ...
  rescue
    # Something went wrong!
    raise FileSaveError.new($!) # Сообщение об ошибке может быть перехвачено с помощью $! переменная.
  end
end
# Важная строка здесь — raise FileSaveError.new($!) . Мы вызываем повышение, чтобы сигнализировать о том, что произошло исключение, передавая ему новый экземпляр FileSaveError, по причине того, что конкретное исключение вызвало сбой записи данных.
