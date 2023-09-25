puts '                                            Rspec'

# Rspec - фреймворк для тестирования приложений.

# Тк Руби динамически типизированный язык и части программы запускаются только если до их расположения в коде добирается программа, те баги могут жить непойманными месяцы и даже годы. Поэтому в Руби тесты особенно важны.
# Написание тестов в большом приложении - это вклад в будущее, защита приложения от ошибок.

# > gem install rspec    # установка
# > rspec    # Запуск тестов

# Matchers - это то что мы пишем после expect, те способы для разных условий тестирования
# https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers


# Создадим и протестируем героя компьютерной игры.

# 1. Создадим файл hero.rb
class Hero
  attr_reader :name

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
describe Hero do # метод принимает тестируемый класс и лямбду с тестами
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
puts '                                               Метод before'

# У нас часто повторяется код hero = Hero.new 'foo', и это не совпадает с DRY (Don`t Repeat Yourself), потому оптимизируем, добавив before.

require './hero'

describe Hero do
  before do # аналогичен методу Синатры(запускается перед каждым тестом it ??)
    @hero = Hero.new 'foo' # не забываем сделать переменную глобальной
  end

  it "has a capitalized name" do
    expect(@hero.name).to eq 'Foo'
  end

  it "can power up" do
    expect(@hero.power_up).to eq 110
  end

  it "can power down" do
    expect(@hero.power_down).to eq 90
  end

  it "displays full hero info" do
    expect(@hero.hero_info).to eq "Foo has 100 health"
  end
end


puts
# Тесты должны быть:
# 1. надёжные (reliable) - дают тот же результат во множестве попыток, без зависимостей от соединения, но в Руби не удастся избежать зависимости от БД.
# 2. easy to write - если тест пишется не легко, то нужно например разбить класс на несколько подклассов.
# 3. easy to understand - лёгкие для понимания другими программистами.
# 4. скорость работы тестов не особо важна, тк может противоречить надежности и читаемости
# 5. DRY тоже не особо важен


puts
puts '                                            Структура тестов'

# Структура тестов: arrange, act, assert. Обычно тест описывается по этому принципу при помощи комментариев

# car.rb:
class Car
  Miles_Per_Gallon = 20

  def initialize
    @fuel = 0
  end

  def add_fuel(amount)
    @fuel += amount
  end

  def range # Как далеко мы сможем проехать на имеющемся топливе
    @fuel * Miles_Per_Gallon
  end
end

# car_spec.rb:
require "./car"

describe Car do
  it "must return range" do
    # arrange - подготовка всего необходимого(тут объекта) для проведения теста
    car = Car.new
    # act - действие
    car.add_fuel 10
    # assert - проверка действия
    expect(car.range).to eq 200
  end
end


















# 
