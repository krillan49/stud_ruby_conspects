puts '                                            Rspec'

# (?? почему у Круковского RSpec.describe статический метод с RSpec, а не просто, мб просто это потому что область класса там и по умочанию метод касса ??)
# (??  когда let а когда before  ??)


# https://rspec.info/

# Rspec - фреймворк для автоматического тестирования приложений. Реализует подход Behavior-driven development (BDD), тоесть тесты описывают ожидаемое поведение проверяемой программы на вызовы ее компонентов

# Основой синтаксиса RSpec является т.н. DSL — Domain Specific Language (язык предметной области) - Помимо стандартных ключевых слов, появляются новые: describe, it, let, before, after - свой синтаксис внутри языка руби. Использует декларативный стиль

# spec - это то же самое, что и тест. Это слово образовано от «specification» (спецификация)


# Установка (но лучше устанавливать через Gemfile):
# > gem install rspec


# $ gem which rspec               - посмотреть путь где установлен rspec в Линукс


# Версии Rspec и его подгемов:
# > rspec -v
#=>
# RSpec 3.12
#   - rspec-core 3.12.2
#   - rspec-expectations 3.12.3
#   - rspec-mocks 3.12.6
#   - rspec-rails 6.0.3
#   - rspec-support 3.12.1


# $ rspec --help                 - справка поможет определить что делать дальше


# Команда для автоматического создания начальных фаилов и директорий, если надо:
# $ rspec --init
#=>
# create .rspec
# create spec/spec_helper.rb
# spec_helper.rb создастся достаточно объемный (порядка сотни строк), но по большей части это комментарии


# Режимы запуска:
# > rspec .                        # запуск всех тестов из директории spec, находясь в директории в которой находится spec
# > rspec                          # тоже, что и выше
# > rspec name_spec.rb             # запуск конретного фаила с тестами
# > rspec ./spec/demo_spec.rb:14   # запуск конкретного теста(it) отдельно с указанием строки его начала
# > rspec . --format doc           # опция '--format' выводит в более удобочитаемом формате, например в формате 'doc' (выведет так же название describe, а вместо точки выведет зеленое название теста)
# $ rspec . -f d                   # тоже что и выше


# spec - принято создавать директорию с таким названием для фаилов с тестами. В каком-то смысле это спецификация для нашей программы, тк фаилы с тестами, что находятся там, описывают как наша программа должна себя вести

# spec/demo_spec.rb - для тестов создается фаил с названием, состоящим из названия того фаила что тестируем и суффикса _spec.

# Это соглашения, которым принято следовать, но если хочется можно называть фаилы любыми именами и размещать в любых директориях

# Внутри фаила spec/demo_spec.rb нужно подключить тестируемый фаил demo.rb (код там)
require_relative '../demo'



puts '                                 Фаил инструкций запуска тестов .rspec'

# .rspec - создается(не обязательно) в корне проекта, содержит инструкци(аргументы) командной строки, которые будут исполнены при вызове тестов. Например для опций Rspec и дополнительных задач.

# Например
# --format doc               # подключаем формат вывода doc по умолчанию
# --color                    # подключаем формат вывода в цвете(?? сейчас не актуально цветное по умочанию ??)
# --order rand               # подключаем случайный порядок выполения тестов(по умолчанию в порядке очереди расположения)
# --require spec_helper      # подгружаем фаил из директории spec



puts '                                          spec_helper.rb'

# spec_helper.rb - главный фаил(не обязательный), который нужен чтобы настраивать все тесты. Располагается в директории spec

# Чтобы при вызове тестов этот фаил вызывался автоматически добавим его вызов в .rspec

# Содержит например:
# строки подключения фаилов(require_relative '../demo') с проверяемым кодом



puts '                                           Метод describe'

# describe - (описывать) - метод опционально может принимать аргумент строку или константу для названия/описания блока тестов и  блок, который содержит в себе набор тестов (it или specify). Тоесть describe это как бы контейнер для группировки разных тестов в рамках какой-то обощающей их темы

# spec/demo_spec.rb:
RSpec.describe 'this is a testing suite' do # 'this is a testing suite' - описание, может быть любым(строка, константа)
end

# Запустить тест можно из директории с папкой spec (Запустить мжно и полностью пустой блок describe):
# > rspec .
#=>
# No examples found.
# Finished in 0.00082 seconds (files took 6.16 seconds to load)
# 0 examples, 0 failures



puts '                                               Метод it'

# it - метод, которым чаще всего создается тест, он должен(?) находиться в блоке метода describe. Принимает опциональный аргумент в виде строки с описанием этого теста и блок с кодом теста

# spec/demo_spec.rb:
RSpec.describe 'this is a testing suite' do
  it 'self.run' do
    # Тк тут пусто тест автоматически пройдет
  end
end
# > rspec .
#=>
# .                       - зеленая точка в выводе обозначает тест который прошел(тоесть нет несоответсвий)
# 1 example, 0 failures



puts '                                           Синтаксис it тестов'

# it - метод теста может опционально принимать аргумент с названием и обязательно принимает блок с телом теста
describe 'types of it' do
  # Тест с названием
  it "has a capitalized name" do
    hero = Hero.new 'foo'
    expect(hero.name).to eq 'Foo'
  end

  # Тест без названия
  it do
    hero = Hero.new 'foo'
    expect(hero.power_up).to eq 110
  end

  # Тест без названия с {} синтаксисом
  it { expect(Hero.new('foo').power_up).to eq 110 }

  # Тест с названием с {} синтаксисом. 1й аргумент обязательно в скобках
  it("displays full hero info") { expect(Hero.new('foo').hero_info).to eq "Foo has 100 health" }
end



puts '                                  arrange, act, assert (Структура теста)'

# arrange - подготовка всех необходимых данных для проведения теста
# act     - действие с этими данными, результат которых будет проверять тест
# assert  - проверка действия на соответсвие желаемому результату

# Обычно тест описывается по этому принципу при помощи комментариев

describe 'strucure of it' do
  it "displays full hero info after power up" do
    hero = Hero.new 'foo'                             # arrange
    hero.power_up                                     # act
    expect(hero.hero_info).to eq "Foo has 110 health" # assert
  end
end



puts '                                     Кастомная реализация матчеров'

# При желании можно вывести в терминал кастомную проверку вместе с выводом теста чрез обычные операторы вывода, но так будет не совсем удобно смотреть в терминале результат, нужно будет искать к каждому тесту true или false или другой вывод, при этом для rspec это просто вывод и он не дает объяснений, что тест нужно отмечать красным, потому будет отмечено зеленым
RSpec.describe 'this is a testing suite' do
  it 'self.run' do
    result = Demo.run # создаем данные по тому функционалу что хотим проверить
    p result == 43    #=Ю true или false
  end
end
# > rspec .
#=>
# false
# .
# 1 example, 0 failures

# Можно вручную породить исключение, чтобы rspec понял, что проверка не пройдена и выделял красным и описал тест который провален. Тоесть в принципе можно писать тело тестов полностью вручную без матчеров rspec
RSpec.describe 'this is a testing suite' do
  it 'self.run' do
    result = Demo.run
    if result == 43
      puts 'ok'
    else
      raise 'not ok, value should be 42' # порождаем ошибку
    end
  end
end
# > rspec . --format doc
#=>
# this is a testing suite
#   self.run (FAILED - 1)
# Failures:
#   1) this is a testing suite self.run
#      Failure/Error: raise 'not ok, value should be 42'
#      RuntimeError:
#        not ok, value should be 42
#      # ./spec/demo_spec.rb:19:in `block (2 levels) in <top (required)>'
# 1 example, 1 failure
# Failed examples:
# rspec ./spec/demo_spec.rb:14 # this is a testing suite self.run



puts '                                   Метод expect и matchers/матчеры'

# https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers

# Matchers/матчеры - методы для проверки разных типов условий тестирования(то что мы пишем после expect)

# При помощи метода expect и матчеров можно задать конкретную инструкцию проверки для RSpec теста и в выводе будет более подробный ответ о том, что конкретно пошло не так, без необходимости писать дополнительный код с исключениями в тесте
RSpec.describe 'this is a testing suite' do
  it 'self.run' do
    result = Demo.run
    expect(result).to(eq(43))
    # expect - (ожидать) - метод принимает значение, которорое мы будем проверять
    # to     - метод который вызывается от объекта, возвращенного методом expect и принимает проверочный объект, возвращенный матчером с которым мы будем сравнивать
    # eq     - метод, конкретный матчер принимает значение с которым сравниваем и задает ему условие сравнения ==

    # Выражения типа expect(son).to и expect(result).to являются ожиданием(expectation)
    # выражения eq(...) (от слова “equal”), be(...) называют матчерами (matchers)
  end
end
# > rspec .
#=>
# F
# Failures:
#   1) this is a testing suite self.run
#      Failure/Error: expect(result).to(eq(43))
#
#        expected: 43
#             got: 42
#
#        (compared using ==)
#      # ./spec/demo_spec.rb:27:in `block (2 levels) in <top (required)>'
# 1 example, 1 failure
# Failed examples:
# rspec ./spec/demo_spec.rb:25 # this is a testing suite self.run


# В одном тесте возможно поместить множество проверок, но если не пройдет 1я, то остальные проверены не будут.
RSpec.describe 'this is a testing suite' do
  it 'self.run' do
    result = Demo.run
    expect(result).to(eq(43))
    expect(result).to(eq(45))
    expect(result).to(eq(47))
  end
end


# Метод expect может принимать и блоки с кодом, а не только aргументы:
expect do
  post('/translate/yoda.json', test_client, text: nil) # код который породит необходимое исключение
end.to raise_error( described_class::BadRequest, 'Bad Request: text is missing.' )

# Блоки в ожидании(expect) используются когда требуется или проверить что-то во время операции, или сделать какое-то измерение. Например: проверить, что метод выдает исключение, если запущен с определенными параметрами; проверить, что метод меняет состояние экземпляра класса — например, добавляем товар в корзину, а общее количество элементов в корзине увеличилось на один.
expect { Shipment.total_weight(ford_trucks: 100) }.to raise_error
expect { some_order.add(item) }.to change { order.item_count }.by(1)



puts '                                         matchers/матчеры'

# https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers

# not_to - проверка на то чтобы значение не соответсвовало матчеру, тут мачеру be_nil
expect(value).not_to be_nil

# raise_error - матчер проверяющий, что в блоке expect было порождено исключение, класс которого соответсвует переданному в параметр, а сообщение переданной строке или регулярке во 2й параметр, если не передать параметры, то проверит просто на то что какое-то исключение порождено, но так делать не рекомендуется
expect do
  post('/translate/yoda.json', test_client, text: nil) # код который породит необходимое исключение
end.to raise_error( described_class::BadRequest, 'Bad Request: text is missing.' )

# output - матчер проверяет что метод выводит чтото в термилнал, обычно это stdout
expect { process = described_object.export!.first.process }.to output(/complete!/).to_stdout

# be_nil - проверка на `nil`
expect(value).not_to be_nil

# be_truthy - проверка на существование и ненулевое значение
expect(value).to be_truthy

# be_present - проверка на то существует ли значение и оно не пустое, например массив или строка
expect(value).to be_present

# include(expected_value) - принимает значение и проверяет включено это значение в массив или строку
expect(array).to include(expected_value)

# be_an_instance_of - принимает константу и проверяет является ли объект экземпляром этого класса
expect(obj).to be_an_instance_of(described_class)


# следует упомянуть о различии матчеров eq и be. Be означает «быть», т.е. быть в смысле «точно вот этим». А eq означает «равен» (equals). Т.е. не обязательно быть точно таким же, но нужно равняться. Например, надписи на заборах из трех букв обычно равны (eq), но каждая из них уникальная по-своему, поэтому нельзя применить к ним матчер be. Ведь надпись может быть нарисована разной краской, разным размером и т.д. Т.к. все в руби объект, то это важно. Например, переменные a и b ниже равны, но их идентификаторы разные, т.к. это разные объекты и они расположены в разных областях памяти.



puts '                             Тестирование класса. described_class. specify'

# Когда мы тестируем класс или модуль, то вместо строкового описания в метод describe принято передавать константу этого класса или модуля, это сработает, тк фаил с этим классом или модулем мы подключали в фаил теста

# described_class - метод RSpec возвращает константу тестируемого класса или модуля, если она была передана аргументом в метод describe

# specify - метод теста, похож на it, его принято использовать тогда, когда тестируется метод класса или экземпляра класса

# Нэиминг аргумента описания, передаваемого в метод specify(помогает прогам считать какое коллич кода покрыто тестами ?):
# '.metod_name'  - если тестируемый метод это метод класса
# '#metod_name'  - если тестируемый метод это метод экземпляра класса

RSpec.describe Demo do
  specify '.run' do # тестируем статический метод
    p "My class is #{described_class.inspect}" #=> "My class is Demo"
    result = described_class.run # тк возвращает константу Demo, то можем вызывать от нее метод этого класса
    expect(result).to eq(42)
  end

  specify '#calc' do # тестируем метод экземпляра
    obj = described_class.new # тк возвращает константу Demo, то можем создать от нее экземпляр соответствующего класса
    expect(obj).to be_an_instance_of(described_class)
    # be_an_instance_of - матчер RSpec принимает константу и проверяет является ли объект экземпляром этого класса
  end

  specify '#my_arr' do
    obj = described_class.new
    expect(obj.my_arr).to include(2)
  end
end
# > rspec . --format doc
#=>
# Demo
# "My class is Demo"
#   .run
#   #calc
#   #my_arr
# 3 examples, 0 failures



puts '                                     Кастомные методы в describe'

# Ничего не мешает создавать в describe методы и использовать их для того чтобы не дублировать код
RSpec.describe Demo do
  def obj
    described_class.new # возвращаем объект
  end

  specify '#calc' do
    expect(obj().calc(2, 3)).to eq(6) # вызываем наш метод obj чтобы использовать возвращенный объект
  end

  specify '#my_arr' do
    expect(obj().my_arr).to include(2)
  end
end



puts '                                      Директория spec/support'

# spec/support - (?можно называть как угодно?) директория для кастомных методов, которые мы хотим использовать в тестах

# Создадим в ней фаил spec/support/test_obj.rb с методом(можно например в модуле)

# Подключим всю директорию support(тоесть подгрузим все фаилы что в ней лежат) в spec_helper.rb
# Если исользовали модуль в spec/support/test_obj.rb то так же подрлючим его во все тесты. Но можно импортировать в конкретные  describe через include Modulename так же как везде

# Теперь мы можем использовать этот метод у нас в тестах
RSpec.describe Demo do
  it 'calc with support' do
    res = obj().calc(2, 3) # используем метод из spec/support/test_obj.rb
    expect(res).to eq(6)
  end
end



puts '                                            Метод let'

# let - метод RSpec, принимает аргументом символ от которого создает одноименную локальную переменную и блок кода, возвращаемое значение которого присваивается в эту переменную. Блок кода будет исполнен и эта переменная будет определена только для каждого теста, в котором есть явное к ней обращение. Для каждого вызвавшего эту переменную теста она будет создана независимо отдельная

# Удобнее кастомных методов для того чтобы не дублировать один и тот же код в нескольких тестах

# spec/demo_spec.rb:
RSpec.describe Demo do
  let(:obj) { puts 'obj created!' ; described_class.new } # при вызове переменной obj из любого теста будет исполнен весь код блока и возвращено значение described_class.new

  specify '.run' do
    # в этом тесте нет обращения к переменной obj, потому блок кода из let не исполняется
    result = described_class.run
    expect(result).to eq(42)
  end

  specify '#calc' do
    p obj
    #=> obj created!
    #=> #<Demo:0x0000021e07e5ba38 @val=42>
    obj.val = 1 # изменение значения никак не повлияет на другой тест, тк объект в let создается каждый раз отдельный
    expect(obj.calc(2, 3)).to eq(6)
  end

  specify '#my_arr' do
    p obj
    #=> obj created!
    #=> <Demo:0x0000021e07e46908 @val=42>
    expect(obj.my_arr).to include(2)
  end
end
# > rspec . --format doc
#=>
# Demo
#   .run
# obj created!
# #<Demo:0x0000021c84e12038 @val=42>
#   #calc
# obj created!
# #<Demo:0x0000021c84e108f0 @val=42>
#   #my_arr
# 3 examples, 0 failures



puts '                                          Hooks: before, after'

# https://relishapp.com/rspec/rspec-core/v/3-8/docs/hooks/before-and-after-hooks
# https://www.rubydoc.info/github/rspec/rspec-core/RSpec/Core/Hooks

# Дополнительный код (мб кроме методов) можно писать в хуках, соответсвующего дискрайба, а не просто в теле дискрайба

# before - метод исполняет код в блоке перед(в) каждым тестом it

# ? По умолчанию аналогично before(:each) ?
before do
end

# Если надо использовать один и тот же код в разных тестах, и чтобы не повторяться, мы используем before, after итд hooks:
before(:each) do # Исполняется перед каждым it тестом в describe (или feature или другого типа)
end

before(:all) do # один раз исполняется перед всеми it тестами в describe (или feature или другого типа)
end


# повторяется код hero = Hero.new 'foo'
describe Hero do
  before do
    @hero = Hero.new('foo') # не забываем сделать переменную глобальной
  end

  specify "has a capitalized name" do
    # @hero = Hero.new('foo')  - этот код исполняется тут
    expect(@hero.name).to eq 'Foo'
  end

  specify "#power_up" do
    # @hero = Hero.new('foo')  - этот код исполняется тут
    expect(@hero.power_up).to eq 110
  end
end



puts '                                     Вложенный describe и его нэйминг'

# Вложенный describe - повышает читаемость кода тестов.
# Вложенные describe можно писать просто, без RSpec.
# ? Во вложенных describe уже используем it, а не specify ?

# Для каждого вложенного describe можно использовать before и let внешнего describe и создавать свои before и let

# Нэйминг(желательный) после вложеного describe - помогает прогам считать какое коллич кода покрыто тестами
# Не методы:                     describe "something" do
# instance методы:               describe "#method_name" do
# class методы (self.method):    describe ".method_name" do

describe Hero do
  before do # так же работает и с тестами внутри вложенных describe
    @hero = Hero.new 'foo'
  end

  # разбиваем на логически обоснованные разделы:

  # Раздел проверки переменных
  describe "start variables is correct" do
    it "has a capitalized name" do
      expect(@hero.name).to eq 'Foo'
    end
    it "has a standart health points" do
      expect(@hero.health).to eq 100
    end
  end

  # Раздел проверки метода экземпляра
  describe "#power_up" do # используем правильный нэйминг, тут будет набор тестов для этого метода
    it "can power up 1 time" do
      expect(@hero.power_up).to eq 110
    end
    it "can power up 2 times" do
      @hero.power_up
      expect(@hero.power_up).to eq 120
    end
  end
end















#
