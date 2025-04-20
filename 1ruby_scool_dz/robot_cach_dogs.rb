# Пример программы(Роботы ловят собаку) где один управляющий класс управляет объектами других классов при помощи одних и тех же методов:
class Robot
  attr_accessor :x, :y
  # Конструктор, принимает хеш/пустой хеш. если начальные координаты не заданы, будут по-умолчанию равны нулю
  def initialize(options={})
    @x = options[:x] || 0
    @y = options[:y] || 0
  end
  def right
    self.x += 1
  end
  def left
    self.x -= 1
  end
  def up
    self.y += 1
  end
  def down
    self.y -= 1
  end
  # Метод — как отображать робота на экране
  def label
    '*'
  end
end

class Dog # Класс собаки, тот же самый интерфейс, но некоторые методы пустые.
  attr_accessor :x, :y

  def initialize(options={})
    @x = options[:x] || 0
    @y = options[:y] || 0
  end
  def right
    self.x += 1
  end
  # Пустые методы, но они существуют. Когда вызываются, ничего не делают.
  def left
  end
  def up
  end
  def down
    self.y -= 1
  end
  # Как отображаем собаку.
  def label
    '@'
  end
end

class Commander # Класс «Командир», который будет командовать, и двигать роботов и собаку.
  def move(who)
    m = [:right, :left, :up, :down].sample
    who.send(m) # Вот он, полиморфизм! Посылаем команду, но не знаем кому!
  end
end
commander = Commander.new

arr = Array.new(10) { Robot.new } # Массив из 10 роботов и...
2.times { arr.push(Dog.new(x: -12, y: 12)) } # ...и 2х собак. Т.к. собака реализует точно такой же интерфейс, все объекты в массиве «как будто» одного типа.

loop do # Цикл движения и отображения объектов
  puts "\e[H\e[2J" # Хитрый способ очистить экран
  # Рисуем воображаемую сетку. Сетка начинается от -12 до 12 по X и от 12 до -12 по Y
  (12).downto(-12) do |y|
    (-12).upto(12) do |x|
      # Проверяем, есть ли у нас в массиве кто-то с координатами x и y.
      somebody = arr.find { |somebody| somebody.x == x && somebody.y == y }
      # Если кто-то найден, рисуем label. Иначе точку.
      if somebody
        print somebody.label # Рисуем «*» или «@», но что это будет мы не знаем. ВОТ ОН, ПОЛИМОРФИЗМ!
      else
        print '.'
      end
    end
    puts # Просто переводим строку
  end
  # Если есть два объекта с одинаковыми координатами и их «label» не равны, то значит робот поймал собаку.
  game_over = arr.combination(2).any? do |a, b|
    a.x == b.x && a.y == b.y && a.label != b.label
  end
  if game_over
    puts 'Game over'
    exit
  end
  # Если все собаки дойдут до одного из противоположных краев то они победят
  dog_win = arr[10..-1].all? { |dog| dog.x >= 12 or dog.y <= -12 }
  if dog_win
    puts 'Win!'
    exit
  end
  # Каждый объект двигаем в случайном направлении
  arr.each do |somebody|
    commander.move(somebody) # Вызываем метод move Командир не знает кому он отдает приказ.
  end
  sleep 0.1
end














#
