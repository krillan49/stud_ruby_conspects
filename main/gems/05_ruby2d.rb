puts '                                              ruby2d'

# https://www.ruby2d.com

# https://www.ruby2d.com/learn/linux/#install-packages   - Linux need install few packages before installing the gem

# > gem install ruby2d

require 'ruby2d' # Оператор require добавляет доменно-специфичный язык и классы Ruby 2D

set title: "Hello Triangle" # метод set, чтобы изменить заголовок окна

# добавить цветной треугольник
Triangle.new(
  x1: 320, y1:  50,
  x2: 540, y2: 430,
  x3: 100, y3: 430,
  color: ['red', 'green', 'blue']
)

show() # метод show сообщает Ruby 2D о необходимости показать пустое окно

# > ruby triangle.rb
#=> вызовет отдельное окно Руби с картинкой разноцыетного треугольника на черном фоне
















#
