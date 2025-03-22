puts '                                           Glimmer DSL'

# https://github.com/AndyObtiva/glimmer-dsl-libui

# Glimmer DSL - обёртка вокруг обёртки (LibUI) для кросс-платформенного построения нативных приложений, оконный native GUI на Ruby. Создает графические приложения для Mac, Windows, Linux на Руби.

# (Обычно заводить GUI сложно, тем более кросс-платформенный, если речь не о Java, но с Glimmer DSL легко)

# Пример создания окна с кнопкой
require 'glimmer-dsl-libui'

include Glimmer

window('hello world', 300, 200) {
  button('Button') {
    on_clicked do
      msg_box('Information', 'You clicked the button')
    end
  }
}.show
