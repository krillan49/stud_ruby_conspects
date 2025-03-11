puts '                                            debug'

# https://guides.rubyonrails.org/debugging_rails_applications.html



puts '                                          Gem debug'

# debug - гем который по умолчанию используется в Рэилс (с 7х) для дебага


# Пример дебага экшена в контроллере
class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token # отключаем специальный токен который генерится в форме, чтобы можно было отправлять POST запросы иммитируя форму из браузера при помощи curl

  def create
    # debugger - мктод гема debug
    debugger
  end
end

# Запустим сервер
# $ rails s

# Посылаем запрос на свой же локалхост и записываем ответ в фаил
# $ curl -X POST http://localhst:3000/questions > result.txt

# Даалее вывод сервера Рэилс как бы подвиснет и мы окажемся в дебагере внутри экшена create контроллера QuestionsController и все что будем вводить в дебагере будет доступно внутри этого метода (? просто вводим и жмем энтер?), например:

# 1. request - объект из котрого можно получить данные о том запросе, который в данный момент обабатвается данным экшеном
request.path           #=> "/questions"        # путь
request.method         #=> "POST"              # метод запроса
request.headers[:host] #=> "localhost:3000"    # можно посмотреть заголовки по их имени

# 2. params - объект приходит по наследованию от ApplicationController а к нему от ActionController::Base
params                 # вернет хэш со всеми параметрами
params[:controller]    #=> "questions"         # контроллер из которого выван params
params[:action]        #=> "create"            # экшен из которого выван params

# c  - (continue) ввести чтобы завершить "зависание" в дебагере

# Посылаем еще запрос
# $ curl -X POST http://localhst:3000/questions -F 'body=Some text' -F 'user_id=1' > result.txt
params[:body]       #=> "Some text"
params[:user_id]    #=> 1

# Посылаем еще запрос, чтобы сделать в params вложенные значения
# $ curl -X POST http://localhst:3000/questions -F 'question[body]=Some text' -F 'question[user_id]=1' > result.txt
params[:question][:body]       #=> "Some text"
params[:question][:user_id]    #=> 1














#
