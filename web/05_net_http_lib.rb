puts '                                         Библиотека Net::HTTP'

# https://ruby-doc.org/stdlib-3.1.2/libdoc/net/http/rdoc/Net/HTTP.html - документация к библиотеке Net::HTTP



puts '                                            Библиотека uri'

# https://ruby-doc.org/stdlib-2.7.0/libdoc/uri/rdoc/URI/Escape.html

require 'uri'

# escape и unescape почемуто выдают ошибку (? проверить на Линукс ?)

URI.escape("http://example.com/?a=\11\15") #=> "http://example.com/?a=%09%0D"

URI.unescape("http://example.com/?a=%09%0D") #=> "http://example.com/?a=\t\r"



puts '                                              Get запрос'

# Получить страницу по URL адресу и вывести ее на экран:


# Вариант1 - со стеками параметров(тут 'fighttime.ru', '/news.html')
require 'net/http'  # загрузка библиотеки(модуля) Net::HTTP  (библиотека отправляющая запросы)
page = Net::HTTP.get('fighttime.ru', '/news.html') # от модуля Net обращаемся к классу HTTP и его методу get, который принимает 2 параметра - название домена и путь по которому расположена сама страница
puts page #=> <!DOCTYPE html><html lang=en><meta charset=utf-8><meta ...  # Выводим HTML код(так же можно получать XML и JSON итд) запрашиваемой страницы


# Вариант 2 - со ссылкой, тк не очень удобно выводить длинные строки параметров
require 'net/http'
require 'uri' # библиотека чтобы правильно формировать адреса
# URI - универсальный идентификатор ресурса / Universal Resource Identifier. Он называется так потому, что содержит в себе("http://localhost:4567/login﻿") 4 составляющих: протокол (http), имя хоста (localhost), порт (4567), путь (/login)
uri = URI.parse "https://fighttime.ru/news.html" # помещаем в переменную новый объект созданный статическим методом
p uri #=> #<URI::HTTPS https://fighttime.ru/news.html>
response = Net::HTTP.get(uri) # теперь этот объект мы может задать как параметр
puts response  #=>  <!DOCTYPE html> <html prefix="og: ... # Ответ почемуто немного другой(изза https ??)

# get_response - ? альтернатива методу get ??
response = Net::HTTP.get_response(uri)



puts '                                              Post запрос'

# За отправку данных(например логина и пароля) (POST запрос) отвечает метод post_form класса: Net::HTTP
require 'net/http'
require 'uri'
uri = URI.parse('http://www.example.com/search.cgi')
# передаем методу post_form объект URI и хэш с данными для POST запроса
# Делаем POST запрос/отправляем форму(как бы нажимаем кнопку ввести например логин и пароль):
response = Net::HTTP.post_form(uri, :login=>"ruby", "password"=>"50") # в хэше можно использовать как символы так и строки. данные в виде хэша отправляются как q=ruby&max=50
puts response      # Запрос возвращает объект ответа сервера
puts response.body # body - оператор который выводит html код страницы из oбъекта ответа, без ненужной служебной информации


puts
# Проверяем при помощи оператора include? закрыт ли доступ('denied' в данном примере код страницы содержит именно такое значение если доступ закрыт) или нет после пост запрса с логином и паролем
require 'net/http'
require 'uri'
uri = URI.parse "https://rubyschool.us/router"
response = Net::HTTP.post_form(uri, login: 'aaa', password: 'ruby').body # оператор body можно ставить сразу тут
puts response.include?('denied') #=> true или false


puts
# Подбираем пароль при помощи запросов и програмы подборщика паролей
require 'net/http'
require 'uri'

def is_wrong_password?(password) # оформляем проверку доступа в виде функции
  uri = URI.parse "http://localhost:4567/login﻿"
  response = Net::HTTP.post_form(uri, username﻿: 'admin', password: password).body # передаем параметр в пост запрос
  response.include?('Wrong username or password, please try again') # возвращаем true или false
end

def find_password
  input = File.open("passwords.txt", "r")
  	while (line = input.gets)
      return line.strip unless is_wrong_password?(line.strip) # проверяем пароль
      puts
  	end
  input.close
end

puts "Password is #{find_password}"












#
