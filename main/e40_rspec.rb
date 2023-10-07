puts '                                            Rspec'

# Rspec - фреймворк для тестирования приложений.

# Тк Руби динамически типизированный язык и части программы запускаются только если до их расположения в коде добирается программа, те баги могут жить непойманными месяцы и даже годы. Поэтому в Руби тесты особенно важны.
# Написание тестов в большом приложении - это вклад в будущее, защита приложения от ошибок.

# Тесты должны быть:
# 1. надёжные (reliable) - дают тот же результат во множестве попыток, без зависимостей от соединения, но в Руби не удастся избежать зависимости от БД.
# 2. easy to write - если тест пишется не легко, то нужно например разбить класс на несколько подклассов.
# 3. easy to understand - лёгкие для понимания другими программистами.
# 4. скорость работы тестов не особо важна, тк может противоречить надежности и читаемости
# 5. DRY тоже не особо важен


# > gem install rspec    # установка
# > rspec    # Запуск тестов

# Matchers - это то что мы пишем после expect, те способы для разных условий тестирования
# https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers


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

  def power_down
    @health -= 10
  end

  def hero_info
    "#{@name} has #{@health} health"
  end
end

# 2. Создадим файл hero_spec.rb
# (название обычно состоит из имени тестируемой сущности и spec - спецификация/тест, но можно назвать как угодно по-другому)
require './hero' # необходимо подключить фаил, объекты из которого будем тестировать(тут по относительному пути)
# В Rspec существует 2 ключевых слова: describe и it
describe Hero do # метод принимает тестируемый класс как название(так же название можно задать просто строкой) и лямбду с тестами
  # Тест 1
  it "has a capitalized name" do # метод принимает имя теста и его тело в лямбде
    hero = Hero.new 'foo' # создаем сущность для теста
    expect(hero.name).to eq 'Foo' # expect (ожидать) - матчер. ожидаем что аргуиент hero.name метода expect соответсвует аргументу 'Foo' метода eq  (hero.name == 'Foo')
  end
  # Тест 2
  it "can power up" do
    hero = Hero.new 'foo'
    expect(hero.power_up).to eq 110
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
puts '                                  arrange, act, assert (Структура тестов)'

# Структура тестов: arrange, act, assert. Обычно тест описывается по этому принципу при помощи комментариев

require './hero'

describe Hero do
  it "displays full hero info after power up" do
    # arrange - подготовка всего необходимого(тут объекта) для проведения теста
    hero = Hero.new 'foo'
    # act - действие
    hero.power_up
    # assert - проверка действия
    expect(hero.hero_info).to eq "Foo has 110 health"
  end
end


puts
puts '                                         before и синтаксис тестов'

# У нас часто повторяется код hero = Hero.new 'foo', и это не совпадает с DRY (Don`t Repeat Yourself), потому оптимизируем, добавив before.

require './hero'

describe Hero do
  before do # аналогичен методу Синатры(запускается перед каждым тестом it ??)
    @hero = Hero.new 'foo' # не забываем сделать переменную глобальной
  end

  # Тест с названием
  it "has a capitalized name" do
    expect(@hero.name).to eq 'Foo'
  end

  # Тест без названия
  it do # "can power up"
    expect(@hero.power_up).to eq 110
  end

  # Тест без названия с использованием {} вместо do end
  it { expect(@hero.power_down).to eq 90 } # "can power down"
  # !!! Выдаст ошибку, если добавить название при использовании синтаксиса с {}

  it "displays full hero info" do
    expect(@hero.hero_info).to eq "Foo has 100 health"
  end
end


puts
puts '                                          Hooks: before, after'

# https://relishapp.com/rspec/rspec-core/v/3-8/docs/hooks/before-and-after-hooks
# https://www.rubydoc.info/github/rspec/rspec-core/RSpec/Core/Hooks

# Если надо использовать один и тот же код в разных тестах, и чтобы не повторяться, мы используем before, after итд hooks:
before(:each) do # Исполняется перед каждым тестом в feature или describe
end

before(:all) do # Исполняется перед всеми(1 раз перед всеми) тестами в feature или describe
end


puts
puts '                                     Вложенный describe и его нэйминг'

# Вложенный describe - повышает читаемость кода тестов

# Нэйминг(желательный) после вложеного describe - помогает прогам считать какое коллич кода покрыто тестами
# НЕ методы:                     describe "something" do
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
