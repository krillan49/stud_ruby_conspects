puts '                                            debug'

# https://guides.rubyonrails.org/debugging_rails_applications.html



puts '                                          Gem debug'

# debug - гем который по умолчанию используется в Рэилс (с 7х) для дебага


# Пример дебага экшена в контроллере
class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token # отключаем специальный токен, который генерится в форме, чтобы можно было отправлять POST запросы, иммитируя форму из браузера при помощи curl

  def create
    # debugger - мктод гема debug
    debugger
  end
end

# Запустим сервер
# $ rails s

# Посылаем запрос на свой же локалхост и записываем ответ в фаил
# $ curl -X POST http://localhst:3000/questions > result.txt

# Даалее вывод сервера Рэилс как бы подвиснет и мы окажемся в дебагере внутри экшена create контроллера QuestionsController и все что будем вводить в дебагере будет доступно внутри этого метода (? просто вводим и жмем энтер?)
# c  - (continue) чтобы завершить "зависание" в дебагере


# Что можно выводить для инфы:

# 1. request - объект из котрого можно получить данные о том запросе, который в данный момент обабатвается данным экшеном
request.path           #=> "/questions"        # путь
request.method         #=> "POST"              # метод запроса
request.headers[:host] #=> "localhost:3000"    # можно посмотреть заголовки по их имени

# 2. params - объект наследуется по цепочке от ApplicationController <- ActionController::Base
params                                         # вернет хэш со всеми параметрами
params[:controller]    #=> "questions"         # контроллер из которого выван params
params[:action]        #=> "create"            # экшен из которого выван params


# Пример запроса с параметрами:
# $ curl -X POST http://localhst:3000/questions -F 'body=Some text' -F 'user_id=1' > result.txt
params[:body]       #=> "Some text"
params[:user_id]    #=> 1


# Пример запроса с параметрами, со вложенными значениями для params: 
# $ curl -X POST http://localhst:3000/questions -F 'question[body]=Some text' -F 'question[user_id]=1' > result.txt
params[:question][:body]       #=> "Some text"
params[:question][:user_id]    #=> 1



puts '                                  Дебаг в продакшене'

# В продакшене не получится так же манипулировать с кодом и вставлять в него что-то для проверки

# Инструменты для дебага в продакшене:
# 1. Смотреть логи сервера (первое что стоит сделать если какие-то ошибки)
# 2. Пользваться удаленной консолью
# 3. Можно попробовать скопировать БД из продакшена себе локально и попыталься воспроизвести ошибку


# 1. Логи - это специальные текстовые фалы в которые приложние в процессе своей работы сбрасывает текущую инфу, например какой был запрос, данные итд. Так же мы сами можем в своем коде добавлять инфу в логи

gem 'rails_12factor' # гем который делает логи в продакшене (например на хероку) полноценными
# заходим в config/enviroments/production.rb и меняем опцию:
config.log_level = :debug
# Далее ставим гем, коммитим и заливаем изменения на даленный сервер














#
