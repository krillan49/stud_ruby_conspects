# 0. Методы из доки пройти заново, массивы, строки, хэши

# 1. Отличия и свойства операторов сравнения (== === eql? equal?)
# https://stackoverflow.com/questions/7156955/whats-the-difference-between-equal-eql-and


3.times.map{gets.chomp}.zip([:to_i,:to_i,:itself]).map{|s,o|s.send(o)}
# мап без переменной
# gets в блоке
# itself метод вызывающий сам объект ?
