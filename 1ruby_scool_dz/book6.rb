# p158
# Задание: задайте базу данных (хеш) своих контактов. Для каждого контакта (фамилия) может быть задано три параметра: email, cell_phone (номер моб.телефона), work_phone (номер рабочего телефона). Напишите программу, которая будет спрашивать фамилию и выводить на экран контактную информацию.
@phone_book = {
  petrov: {email: 'petrov@mail.ru', cell_phone: 89057778888, work_phone: 62456},
  ivanov: {email: 'ivanov@mail.ru', cell_phone: 89216664444, work_phone: 62189},
  sidorov: {email: 'sidorov@mail.ru', cell_phone: 89032221111, work_phone: 67890}
}


begin
  print 'Enter surname '
  surname = gets.strip.downcase.to_sym
  puts 'Wrong surname' if !@phone_book.key?(surname)
end until @phone_book.key?(surname)

puts surname.to_s.capitalize

@phone_book[surname].each do |k, v|
  puts "#{k}: #{v}"
end


# p 162 
# Задание: напишите программу, которая считает частотность букв и выводит на экран список букв и их количество в предложении.
str = 'the quick brown fox jumps over the lazy dog'
arr = str.split('')
arr.delete(' ')
puts arr.to_s

hh = Hash.new(0)
arr.each do |el|
  hh[el] += 1
end
puts hh
