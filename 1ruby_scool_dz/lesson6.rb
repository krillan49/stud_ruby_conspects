# Задача из примера на разделение слово дефисами и посимвольный вывод несколько раз(улучшена относительно варианта автора)
def prim()
  print "Введите строку: "
  str = gets().chomp()

  3.times do
    str.size.times do |x|
      print str[x]
      sleep rand(0.02..0.3)
      if x != str.size-1
        print "-"
      end
    end
    print " "
  end
end

# Задача из ДЗ про накопления
def dz()
  print "Какую сумму будем откладывать в месяц: "
  sum = gets().to_f
  print "Сколько лет будем копить: "
  years = gets().to_i

  1.upto(years) do |y|
    1.upto(12) do |m|
      print "Год #{y} , месяц #{m}. Отложено: #{y * m * sum}\n"
    end
  end
end
