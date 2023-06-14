# ООП: Состояние, пример программы
# Пусть метод initialize принимает опцию — номер робота. Сделайте так, чтобы номер робота был еще одним параметром, который будет определять его состояние (также как и координаты). Измените методы up и down — если номер робота четный, эти методы не должны производить операции над координатами. Измените методы left и right — если номер робота нечетный, эти методы также не должны производить никаких операций над координатами. Попробуйте догадаться, что будет на экране при запуске программы.
class Robot
  attr_accessor :x, :y, :num # zad

  def initialize(options = {}) # В хеше мы ожидаем два параметра(по умолчанию пустой) — начальные координаты робота
    @x = options[:x] || 0
    @y = options[:y] || 0
    @num = options[:num] || rand(100) # zad
  end
  def right
    self.x += 1 if self.num.even? # zad
  end
  def left
    self.x -= 1 if self.num.even? # zad
  end
  def up
    self.y += 1 if self.num.odd? # zad
  end
  def down
    self.y -= 1 if self.num.odd? # zad
  end
end

class Commander # Класс «Командир», который будет командовать и двигать роботов
  # Дать команду на движение робота. Метод принимает объект и посылает ему случайную команду.
  def move(who)
    m = [:right, :left, :up, :down].sample
    who.send(m)
  end
end

commander = Commander.new
robots = Array.new(10) { Robot.new } # Массив из 10 роботов

loop do
  gets
  puts "\e[H\e[2J" # Хитрый способ очистить экран

  # Рисуем воображаемую сетку. Сетка начинается от -30 до 30 по X, и от 12 до -12 по Y
  (12).downto(-12) do |y|
    (-30).upto(30) do |x|
      # Проверяем, есть ли у нас в массиве роботов робот с координатами x и y
      found = robots.any? { |robot| robot.x == x && robot.y == y }

      if found # Если найден, рисуем звездочку, иначе точку
        print '*'
      else
        print '.'
      end
    end
    puts # Просто переводим строку
  end
  # Каждого робота двигаем в случайном направлении
  robots.each do |robot|
    commander.move(robot)
  end
  sleep 0.5
end
