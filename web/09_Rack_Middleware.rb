puts '                                       Rack и Middleware'

# Rack - это модульный интерфейс для веб-серверов Ruby, который предоставляет простой и стандартизированный способ взаимодействия веб-серверов с веб-приложениями. Он позволяет создавать компоненты middleware, которые могут обрабатывать HTTP-запросы и ответы

# Middleware - это слой кода, который находится между веб-сервером и приложением, это способ инкапсуляции функциональности, которая может быть применена к запросам и ответам по мере их прохождения через стек приложения. Он может изменять запросы и ответы и выполнять действия до или после обработки запроса приложением

# Распространенные способы использования Middleware:
# 1. Логирование: Захват деталей запроса и ответа для отладки или аналитики
# 2. Аутентификация: Проверка учетных данных пользователя перед предоставлением доступа к определенным маршрутам
# 3. Управление пользовательскими сессиями между запросами
# 4. Обработка ошибок: Перехват исключений и возврат удобных для пользователя страниц ошибок
# 5. CORS: Обработка заголовков Cross-Origin Resource Sharing для ответов API

# Использование Rack middleware является важным аспектом разработки веб-приложений на Ruby, будь то небольшое приложение на Sinatra или крупное на Rails



puts '                        Структура и использование Middleware в Rack-приложении'

# Компоненты middleware предназначены для обработки HTTP-запросов определенным образом. Каждый компонент middleware имеет метод call, который принимает хэш окружения (содержащий информацию о запросе) в качестве аргумента и возвращает массив, содержащий статус HTTP-ответа, заголовки и тело

# простой пример middleware:
class MyMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    puts "Действие перед передачей запроса в приложение"

    # Вызов следующего middleware/приложения в стеке
    status, headers, response = @app.call(env)

    puts "Действие после обработки запроса приложением"

    # Возвращаем ответ
    [status, headers, response]
  end
end


# Чтобы использовать ваше middleware в Rack-приложении, обычно настраивают его в файле config.ru:
require 'rack'
require_relative 'my_middleware'

app = Proc.new do |env|
  [200, { 'Content-Type' => 'text/html' }, ['Привет, мир!']]
end

use MyMiddleware  # Вставляем ваше middleware в стек

run app



puts '                             Пример 1: Простое Rack-приложение'

# Создадим простое Rack-приложение, которое отвечает на HTTP-запросы

# config.ru
run Proc.new { |env| ['200', { 'Content-Type' => 'text/plain' }, ['Привет, мир!']] }

# Команда запуска Rack-приложения из фаила config.ru:
# $ rackup config.ru



puts '                            Пример 2: Middleware для логирования'

# 1. Cоздадим middleware, который будет логировать все входящие запросы.

# Логирование - захват деталей запроса и ответа для отладки или аналитики

# logger_middleware.rb
class LoggerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    puts "Запрос: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"

    status, headers, response = @app.call(env)

    puts "Ответ: #{status}"

    [status, headers, response]
  end
end


# 2. Добавим это middleware в наше Rack-приложение:

# config.ru
require_relative 'logger_middleware'

class MyApp
  def call(env)
    ['200', { 'Content-Type' => 'text/plain' }, ['Привет, мир!']]
  end
end

use LoggerMiddleware  # Вставляем middleware в стек

run MyApp.new



puts '                          Пример 3: Middleware для аутентификации'

# 1. Создадим middleware, которое проверяет наличие заголовка Authorization для доступа к приложению

# auth_middleware.rb
class AuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['HTTP_AUTHORIZATION'] == 'Bearer секретный_токен'
      @app.call(env)  # Если токен правильный, передаем управление дальше
    else
      ['401', { 'Content-Type' => 'text/plain' }, ['Неавторизован']]
    end
  end
end


# 2. Добавим это middleware в наше приложение:

# config.ru
require_relative 'auth_middleware'
require_relative 'logger_middleware'

class MyApp
  def call(env)
    ['200', { 'Content-Type' => 'text/plain' }, ['Привет, авторизованный пользователь!']]
  end
end

use LoggerMiddleware  # Логируем запросы
use AuthMiddleware    # Проверяем аутентификацию

run MyApp.new



puts '                          Пример 4: Middleware для обработки ошибок'

# 1. Создадим middleware, который будет обрабатывать ошибки и возвращать пользовательскую страницу ошибки

# error_handling_middleware.rb
class ErrorHandlingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue StandardError => e
      ['500', { 'Content-Type' => 'text/plain' }, ["Произошла ошибка: #{e.message}"]]
    end
  end
end


# 2. Добавим это middleware в наше приложение:

# config.ru
require_relative 'error_handling_middleware'
require_relative 'auth_middleware'
require_relative 'logger_middleware'

class MyApp
  def call(env)
    # Искусственно вызываем ошибку для демонстрации обработки ошибок
    raise "Что-то пошло не так!" if env['PATH_INFO'] == '/error'

    ['200', { 'Content-Type' => 'text/plain' }, ['Привет, мир!']]
  end
end

use LoggerMiddleware        # Логируем запросы
use AuthMiddleware          # Проверяем аутентификацию
use ErrorHandlingMiddleware # Обрабатываем ошибки

run MyApp.new


# 3. Запуск приложения
# $ rackup config.ru


# 4. Теперь можно протестировать различные маршруты:
# http://localhost:9292/                                                 - получите "Привет, мир!".
# http://localhost:9292/error                                            - получите сообщение об ошибке.
# Используйте заголовок Authorization для доступа к защищенному ресурсу












#
