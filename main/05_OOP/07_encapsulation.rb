puts '                                  Сокрытие реализации функционала'

class Robot
  attr_accessor :x, :y
  def initialize
    @x, @y = 0, 0
  end

  def right
    self.x += 1 # Обращаемся к атрибуту(тут к сеттеру) через self
  end
  def left; self.x -= 1 end
  def up; self.y += 1 end
  def down; self.y -= 1 end
end

robot1 = Robot.new
# Меняем значение переменной(состояние объекта) @y в соотв с тем как задоно в методе up вместо того чтоб менять его при вызове, если вызывать просто через атрибут
robot1.up    #=> 1 (@y += 1)
robot1.right #=> 1 (@x += 1)
p "x = #{robot1.x}, y = #{robot1.y}" #=> "x = 1, y = 1"
