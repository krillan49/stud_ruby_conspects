# Структура данных “Хеш” (Hash) p148

earth_obj = {
  soccer_ball: 410,
  tennis_ball: 58,
  golf_ball: 45
}
# Напишите код, который адаптирует этот хеш для условий на Луне. Известно, что вес на луне в 6 раз меньше, чем вес на Земле.
moon_obj = {}
obj = {
  soccer_ball: [],
  tennis_ball: [],
  golf_ball: []
}

earth_obj.each do |k, v|
  moon_obj[k] = (v.to_f / 6).round(1)
  obj[k][0] = v
  obj[k][1] = moon_obj[k]
end

# Задание: “лунный магазин”. Используя хеш с новым весом из предыдущего задания напишите программу, которая для каждого типа спрашивает пользователя какое количество мячей пользователь хотел бы купить в магазине (ввод числа из консоли). В конце программа выдает общий вес всех товаров в корзине. Для сравнения программа должна также выдавать общий вес всех товаров, если бы они находились на Земле.

print 'How many soccer ball you wanna buy? '
obj[:soccer_ball][2] = gets.to_i
print 'How many tennis ball you wanna buy? '
obj[:tennis_ball][2] = gets.to_i
print 'How many golf ball you wanna buy? '
obj[:golf_ball][2] = gets.to_i

s_m = 0
s_e = 0
obj.each_value do |v|
  s_e += v[0] * v[2]
  s_m += v[1] * v[2]
end

puts obj.inspect
puts "mass all balls at moon = #{s_m}"
puts "mass all balls at earth = #{s_e}"
