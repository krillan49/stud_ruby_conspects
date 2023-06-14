# 5 УРОК. Сделать анимированную штуку из урока 5(1:24:20) Подзадание - сделать так чтоб крутилось медленее
# ТОЛЬКО ДЛЯ КОНСОЛИ иначе повиснет.

def roller(el, n)
  # Задаем скорость при помощи повторения элементов *2*n
  n.times {
    for i in 0...el.size()*2
      if i.even?
        el[i] += el[i]
      end
    end
  }
  # Цикл запускающий чередование элементов
  while el != "x"
    for i in 0...el.size
      print el[i]
      print "\r"
    end
  end
end
roller("\\|/-", 10)


# VER_2: Задать скорость при помощи оператора sleep. Задать последовательность символов и скорость вращения через терминал. Задать время вращения.

print "Enter your characters: "
chars = gets().strip

print "Enter speed from 1 to 4: "
speed = gets().to_i

print "Enter the working time(min): "
time = gets.to_f

while speed < 1 or speed > 4
  print "Wrong. Speed can be only from 1 to 4. Enter the speed: "
  speed = gets().to_i
end

case speed # Перевод скорости из обратнопропорциональной в заданные значения
when 1
  sp = 0.05
when 2
  sp = 0.03
when 3
  sp = 0.01
when 4
  sp = 0.005
end

# рассчет числа повторений для заданного времени
n = ((time * 60)/(sp * chars.size)).to_i
# Цикл запускающий чередование элементов
n.times do
  for i in 0...chars.size
    print chars[i]
    sleep sp
    print "\r"
  end
end


# VER_3 ------------------------------------------------------
line = "|/-\\"
100.times do
  0.upto(line.size) do |el|
    sleep(rand(0.1..0.3))
    print line[el], "\r"
  end
end
