puts '                              TomSelect, ajax и поиск, парсинг json(serialize)'

# Альтернативы для TomSelect:
# 1. select2(устарел, тк зависит от JQuery) https://select2.org/data-sources/ajax
# 2. choices.js - библиотека.
# Так же есть и другие select библиотеки на ванильном JS


# TomSelect - решение для создания удобного селектора со стилями и JS. По умолчанию имеет поддержку Бутстрап 5

# Канал SupeRails делал ролик по TomSelect с реализацией на ванильном JS и Stimulus JS.
# https://blog.corsego.com/select-or-create-with-tom-select. - ещё подробнее инструкция. Эта реализация интересна ещё и тем что можно автоматически создавать тэги прямо в форме создания объекта. Есть алгоритм использования этой библиотеки с async/await.


# Установка TomSelect:
# > yarn add tom-select
# package.json - добавилось "tom-select": "^2.3.1"


# Подключение и скрипт для TomSelect:
# app/javascript/script - создадим подпаку для отдельных скриптов (можно и прямо в application.js писать скрипты, но тогда там будет каша)
# app/javascript/script/select.js - создадим фвил в котором собственно и будет код скрипта для нашего селектора с TomSelect, не забываем подключить фаил select.js в application.js
# app/javascript/script/i18n/select.json - для переводов придется сделать подпапку i18n с фаилом с переводами select.json
# app/assets/stylesheets/application.bootstrap.scss - так же подключим стили для TomSelect


# questions/index.html.erb - добавим секцию с формой для поиска вопросов по тегам, при помощи которой будем отображать на главной только те вопросы у которых есть выбранные в селекторе теги

# Для селектора, нужна коллекция всех теговн, потому в контроллере вопросов определим ее
def index
  # ...
  @tags = Tag.all if !@tags # добавляем список всех тегов для селектора тегов
end



puts '                               ajax и поиск, парсинг json(serialize)'

# Выведение результатов Tag.all для селектора слишком затратно и неудобно если тегов очень много, тк отобразит в селекторе абсолютно все теги
# Поэтому удалим эту строку с запросом(@tags = Tag.all if !@tags) и вместо этого списка тегов в селекторе реализуем асинхронный поиск по введенному тексту от юзера, при помощи ajax

# (Альтернатива serialize: jBuilder - урок 16)

# serialize/сериализатор это программа которая генерирует объект json (тут из коллекции объектов Руби)
# Бывают разные сеарилизаторы, например:
# https://github.com/jsonapi-serializer/jsonapi-serializer
# https://github.com/procore-oss/blueprinter?ref=procore-engineering-blog
# Тут используем 2й, тк он менее навороченый

# Добавим blueprinter в гемфаил
gem 'blueprinter'
# > bundle i

# Далее создаем дирректорию app/blueprints (название любое ??) и фаил tag_blueprint.rb с классом содержащим описание того как нужно сериализовать наши теги в json (те как именно генерировать json с коллекцией тегов)
class TagBlueprint < Blueprinter::Base
  identifier :id # тоесть идентификатором в json будет id тега
  fields :title  # значением будет title тега
end


# Нам понадобится пространство имен которое назовем api:

# Создадим новый namespace :api и в нем маршрут для тегов по которому будут передаваться введеные пользователем символы
Rails.application.routes.draw do
  # ...
  namespace :api do
    resources :tags, only: :index
  end
  # не помещвем его в скоуп с локалями, тк от локалей он зависеть не будет
end

# Создадим пространство имен и контроллер в директории контроллеров controllers/api/tags_controller.rb с экшеном index, который будет возвращать объект json
module Api
  class TagsController < ApplicationController
    def index # GET '/api/tags.json?term=k'  # если ввели букву k
      tags = Tag.arel_table
      # arel_table - метод использует ARIAL, изначально есть в Рэилс, создает чтото что посзволяет удобнее писать сложные SQL запросы на Руби
      @tags = Tag.where(tags[:title].matches("%#{params[:term]}%"))
      # tags[:title] - тоесть названия тегов из Tag.arel_table
      # matches("%#{params[:term]}%")) - метод проверяет на LIKE соответсвие
      # params[:term] - то что пользователь вводит в селектор
      render json: TagBlueprint.render(@tags)
      # render json:  -  рендерим на страницу json
      # TagBlueprint.render(@tags) - через наш класс сериализатора Blueprint превращаем коллекцию тегов в json
      # не нужно представление api/tags/index.json тк это просто рендер json на страницу
      # http://localhost:5000/api/tags.json - можно посмотреть объект целиком (через паблик ??)
    end
    # Тоесть теперь теги для селектора мы берем из json который генерится каждый раз когда пользователь чтото вводит в селектор
  end
end

# Так же дополнительно можно добавить атрибуты классов и data в форму questions/_form.html.erb чтобы использовать такойже ассинхронный запрос и там на страницах questions/new.html.erb и questions/edit.html.erb
# Теперь в questions_controller.rb нам больше не нужен функционал для отображения тегов в селекторах для new и edit
class QuestionsController < ApplicationController
  # ...
  before_action :fetch_tags, only: %i[new edit] # удаляем
  # ...
  def fetch_tags # удаляем
    @tags = Tag.all
  end
end















#
