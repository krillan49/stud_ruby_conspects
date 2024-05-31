puts '                                          Готовые решения'

puts "\e[H\e[2J" # Хитрый способ очистить экран


# Для переключения переключателя булевой переменной
@hero_tern = true
@hero_tern = !@hero_tern


# код грея  https://translated.turbopages.org/proxy_u/en-ru.ru.a92bc5bb-637a4195-d42522da-74722d776562/https/www.tutorialspoint.com/conversion-of-gray-code-to-binary

# https://mathworld.wolfram.com/TowerofHanoi.html  (Tower of Hanoi)


# ???
file = File.open ARGV[0]
cnt = file.gets.chomp.to_i
sum = 0
cnt.times do
  sum += file.gets.chomp.to_i
end
puts sum


# Быстрая пермутация до определенного момента(энной по счету пермутации) при помощи find
def nth_perm(n, d)
  ('0'..(d-1).to_s).to_a.permutation(d).find.with_index(1){|e, i| i == n}.join
end
p nth_perm(1000, 8) #=> '02436571'















#
