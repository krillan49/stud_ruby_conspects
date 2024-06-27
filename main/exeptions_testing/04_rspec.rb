puts '                                            Rspec'

# https://rspec.info/

# Rspec - фреймворк для автоматического тестирования приложений. Реализует подход Behavior-driven development (BDD), тоесть тесты описывают ожидаемое поведение проверяемой программы на вызовы ее компонентов

# Установка:
# > gem install rspec

# Запуск:
# > rspec .                      # запуск всех тестов из директории spec, находясь в директории в которой находится spec
# > rspec . --format doc         # опция '--format' выводит в более удобочитаемом формате 'doc'
# > rspec filname.rb             # запуск конретного фаила с тестами
# > rspec ./spec/demo_spec.rb:14 # запуск конкретного теста(it) с указанием строки его начала


puts
puts '                                        Начало по Круковскому'

# Например мы хотип протестировать статический метод run класса Demo что лежит в фаиле demo.rb
class Demo
  def self.run
    42
  end
end

# spec - принято создавать директорию с таким названием для фаилов с тестами. В каком-то смысле это спецификация для нашей программы, тоесть там будут находиться фаилы(тесты), описывающие как наша программа должна себя вести
# spec/demo_spec.rb - для тестов создается фаил с названием состоящим из названия того фаила что тестируем и суффикса _spec.
# Это соглашения, которым принято следовать, но если хочется можно называть фаилы любыми именами и размещать в любых директориях

# внутри фаила spec/demo_spec.rb нужно подключить тестируемый фаил demo.rb
require_relative '../demo'

# Собственно тест в spec/demo_spec.rb
RSpec.describe 'this is a testing suite' do  # ?? почему тут статический метод с RSpec, а не просто ??
  # describe - (описывать) - метод опционально может принимать аргумент названия/описания для блока тестов(строку или константу) и собственно блок, который содержит в себе набор тестов (в блоках методов it, specify). Тоесть describe это как бы контейнер
  # 'this is a testing suite' - название может быть любым
end

# Запустить тест можно из директории с папкой spec. Запустить мжно и полностью пустой блок describe
# > rspec .
#=>
# No examples found.
# Finished in 0.00082 seconds (files took 6.16 seconds to load)
# 0 examples, 0 failures

# Напишем тест
RSpec.describe 'this is a testing suite' do
  # it - метод, которым чаще всего создается тест, он должен находиться в блоке метода describe. Принимает опциональный аргумент строку с описанием этого теста и блок с кодом теста
  it 'self.run' do
    result = Demo.run # создаем данные по функционалу что хотим проверить
    p result == 43 # при желании можно вывести в терминал кастомную проверку вместе с выводом теста, но так будет не совсем удобно смотреть в терминале результат, нужно будет искать к каждому тесту true или false, при этом для rspec это просто вывод и он не дает объяснений что тест нужно отмечать красным, потому будет отмечено зеленым
  end
end

# > rspec .
#=>
# false
# .
# Finished in 0.03918 seconds (files took 0.89442 seconds to load)
# 1 example, 0 failures

# . - зеленая точка в выводе обозначает тест который прошел(тоесть нет несоответсвий)

# Так выведет название describe, а вместо точки выведет зеленое название теста
# > rspec . --format doc
#=>
# this is a testing suite
# false
#   self.run
# Finished in 0.00692 seconds (files took 0.96044 seconds to load)
# 1 example, 0 failures

# Можно в ручную породить ошибку, чтобы rspec понял что проверка не пройдена и выделял красным и описал тест который провален. Тоесть в принципе можно писать тело тестов полностью в ручную без матчеров
RSpec.describe 'this is a testing suite' do
  it 'self.run' do
    result = Demo.run
    if result == 43
      puts 'ok'
    else
      raise 'not ok, value should be 42'
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
# Finished in 0.00661 seconds (files took 0.92463 seconds to load)
# 1 example, 1 failure
# Failed examples:
# rspec ./spec/demo_spec.rb:14 # this is a testing suite self.run


puts
puts '                                        Метод expect и matchers/матчеры'

# https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers

# Matchers/матчеры - методы для проверки разных типов условий тестирования(то что мы пишем после expect)

# При помощи expect и матчеров можно задать корректную конкретную инструкцию для RSpec теста и выдаст более подробный ответ что конкретно пошло не так без необходимости писать доб код в тесте
RSpec.describe 'this is a testing suite' do
  it 'self.run' do
    result = Demo.run
    expect(result).to(eq(43))
    # expect - (ожидать) - метод принимает значение, которорое мы будем проверять
    # to - метод который вызывается от объекта возвращенного методом expect и принимает проверочный объект возвращенный матчером с которым мы будем сравнивать
    # eq - метод, конкретный матчер принимает значение с которым сравниваем и задает ему условие сравнения ==
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
# Finished in 0.22334 seconds (files took 0.89851 seconds to load)
# 1 example, 1 failure
# Failed examples:
# rspec ./spec/demo_spec.rb:25 # this is a testing suite self.run


puts
puts '                                   Потом сопоставить с тем что выше'

# Создадим и протестируем героя компьютерной игры.

# 1. Создадим файл hero.rb
class Hero
  attr_reader :name, :health

  def initialize(name, health=100)
    @name = name.capitalize
    @health = health
  end

  def power_up
    @health += 10
  end

  def hero_info
    "#{@name} has #{@health} health"
  end
end

# 2. Создадим файл hero_spec.rb (название обычно состоит из имени тестируемой сущности и spec - спецификация/тест, но можно назвать как угодно по-другому)
require './hero' # необходимо подключить фаил, объекты из которого будем тестировать(тут по относительному пути)
# В Rspec существует 2 ключевых слова: describe и it
describe Hero do # метод принимает тестируемый класс как название(название можно задать и просто строкой) и блок с тестами
  # Тест 1
  it "has a capitalized name" do # метод принимает имя теста и его тело в блоке
    hero = Hero.new('foo') # создаем сущность для теста
    expect(hero.name).to eq 'Foo' # expect (ожидать) - матчер. ожидаем что аргумент hero.name метода expect соответсвует аргументу 'Foo' метода eq  (hero.name == 'Foo')
  end
  # Тест 2
  it "can power up" do
    hero = Hero.new('foo')
    expect(hero.power_up).to(eq(110), 'fuck') # чтобы вывести дополнительное сообщение, нужно просто дописать его доп параметром
  end
end

# 3. Запустим тест:
# > rspec hero_spec.rb

# 4а. Вывод. Все тесты прошли без ошибок
#=> ..   # 2 точки значит что в обоих тестах нет ошибок
#=> Finished in 0.03575 seconds (files took 2.92 seconds to load)
#=> 2 examples, 0 failures

# 4б. Вывод. Если обнаружены ошибки
# .F    # 1 точка знач 1й тест прошел, F - значит во втором тесте ошибка
# Failures:
#   1) Hero can power up
#      Failure/Error: expect(@hero.power_up).to eq 11
#        expected: 11
#             got: 110
#        (compared using ==)
#      # ./hero_spec.rb:14:in `block (2 levels) in <top (required)>'
# Finished in 0.23357 seconds (files took 0.72921 seconds to load)
# 2 examples, 1 failure
# Failed examples:
# rspec ./hero_spec.rb:13 # Hero can power up


puts
puts '                                  arrange, act, assert (Структура теста)'

# Структура теста:
# arrange - подготовка всех необходимых данных для проведения теста
# act     - действие с этими данными, результат которых будет проверять тест
# assert  - проверка действия на соответсвие желаемому результату
# Обычно тест описывается по этому принципу при помощи комментариев

require './hero'

describe Hero do
  it "displays full hero info after power up" do
    hero = Hero.new 'foo'                             # arrange
    hero.power_up                                     # act
    expect(hero.hero_info).to eq "Foo has 110 health" # assert
  end
end


puts
puts '                                           Синтаксис it тестов'

# it - метод теста может опционально принимать аргумент с названием и обязательно принимает блок с телом теста

require './hero'

describe Hero do
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


puts
puts '                                          Hooks: before, after'

# https://relishapp.com/rspec/rspec-core/v/3-8/docs/hooks/before-and-after-hooks
# https://www.rubydoc.info/github/rspec/rspec-core/RSpec/Core/Hooks

# Весь дополнительный код (мб кроме методов) стоит писать в хуках, соответсвующего дискрайба, а не просто в теле дискрайба

# before - метод (похож на одноименный метод Синатры), исполняет код в блоке перед(в) каждым тестом it

# ? По умолчанию аналогично before(:each) ?
before do
end

# Если надо использовать один и тот же код в разных тестах, и чтобы не повторяться, мы используем before, after итд hooks:
before(:each) do # Исполняется перед каждым it тестом в describe (или feature или другого типа)
end

before(:all) do # один раз исполняется перед всеми it тестами в describe (или feature или другого типа)
end


# (Пример) У нас часто повторяется код hero = Hero.new 'foo', и это не совпадает с DRY, потому оптимизируем, добавив before.
require './hero'

describe Hero do
  before do
    @hero = Hero.new('foo') # не забываем сделать переменную глобальной
  end

  it "has a capitalized name" do
    # @hero = Hero.new('foo')  - этот код исполняется тут
    expect(@hero.name).to eq 'Foo'
  end

  it "can power up" do
    # @hero = Hero.new('foo')  - этот код исполняется тут
    expect(@hero.power_up).to eq 110
  end
end


puts
puts '                                     Вложенный describe и его нэйминг'

# Вложенный describe - повышает читаемость кода тестов

# Нэйминг(желательный) после вложеного describe - помогает прогам считать какое коллич кода покрыто тестами
# Не методы:                     describe "something" do
# instance методы:               describe "#method_name" do
# class методы (self.method):    describe ".method_name" do

require './hero'

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
  describe "#power_up" do # используем правильный нэйминг
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
