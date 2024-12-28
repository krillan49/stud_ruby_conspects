puts '                                            TomSelect'

# Альтернативы для TomSelect:
# 1. select2(устарел, тк зависит от JQuery) https://select2.org/data-sources/ajax
# 2. choices.js - библиотека.
# 3. Так же есть и другие select библиотеки на ванильном JS


# TomSelect - решение для создания удобного селектора со стилями и JS. По умолчанию имеет поддержку Бутстрап 5

# Канал SupeRails делал ролик по TomSelect с реализацией на ванильном JS и на Stimulus JS.
# https://blog.corsego.com/select-or-create-with-tom-select. - ещё подробнее инструкция. Эта реализация интересна ещё и тем что можно автоматически создавать тэги прямо в форме создания объекта. Есть алгоритм использования этой библиотеки с async/await.


# Установка TomSelect:
# > yarn add tom-select
# package.json - добавилось "tom-select": "^2.3.1"


# Подключение и скрипт для TomSelect:
# app/javascript/script - создадим подпаку для отдельных скриптов (можно писать скрипты и прямо в application.js, но тогда там будет каша)
# app/javascript/script/select.js - создадим фаил с кодом скрипта для нашего селектора с TomSelect, не забываем подключить фаил select.js в application.js
# app/javascript/script/i18n/select.json - для переводов придется сделать подпапку i18n с фаилом с переводами select.json
# app/assets/stylesheets/application.bootstrap.scss - так же подключим стили Бутстрапа для TomSelect


# questions/index.html.erb - добавим секцию с формой для поиска вопросов по тегам, при помощи которой будем отображать на главной только те вопросы у которых есть выбранные в селекторе теги

# (версия без ассинхронного поиска) Для селектора, нужна коллекция всех тегов, потому в контроллере вопросов определим ее
def index
  # ...
  @tags = Tag.all if !@tags # добавляем список всех тегов для селектора тегов
end



puts '                                        ajax и ассинхронный поиск'

# Выведение результатов Tag.all для селектора слишком затратно и неудобно если тегов очень много, тк отобразит в селекторе абсолютно все теги
# Поэтому удалим эту строку с запросом(@tags = Tag.all if !@tags) и вместо этого списка тегов в селекторе реализуем асинхронный поиск по введенному тексту от юзера, при помощи ajax


# Для ассинхронных запросов селектора TomSelect нам понадобится коллекция тегов в формате json:

# app/blueprints/tag_blueprint.rb - используем Serialize blueprinter, для серриализации (парсинга коллекции сущностей в json). Cоздадим фаил tag_blueprint.rb с классом содержащим описание того как как именно генерировать json из коллекции тегов
class TagBlueprint < Blueprinter::Base
  identifier :id # тоесть идентификатором в json будет id тега
  fields :title  # значением будет title тега
end


# Нам понадобится пространство имен которое назовем api:

# Создадим новый namespace :api и в нем маршрут для тегов по которому будут передаваться введеные пользователем символы
Rails.application.routes.draw do
  # не помещвем его в скоуп с локалями, тк от локалей он зависеть не будет
  namespace :api do
    resources :tags, only: :index
  end
end

# Создадим пространство имен и контроллер в директории контроллеров controllers/api/tags_controller.rb с экшеном index, который будет возвращать объект json для селектора TomSelect
module Api
  class TagsController < ApplicationController
    def index # GET '/api/tags.json?term=k'  # если ввели букву k
      tags = Tag.arel_table
      # arel_table - метод использует ARIAL, изначально есть в Рэилс, создает объект, используя который можно удобнее писать сложные SQL запросы на Руби
      @tags = Tag.where(tags[:title].matches("%#{params[:term]}%"))
      # tags[:title]                   - тоесть названия тегов из Tag.arel_table
      # matches("%#{params[:term]}%")) - метод проверяет на LIKE соответсвие
      # params[:term]                  - символ (или символы ?), что пользователь ввел в селектор для поиска тега
      render json: TagBlueprint.render(@tags) # рендерим на страницу(в селектор TomSelect) сгенерированный блюпринтером json на основе класса TagBlueprint с коллекцией тегов
      # не нужно представление api/tags/index.json тк нужен просто рендер json на страницу (в селектор TomSelect, который его использует) а не на другую отдельную страницу
    end
    # Теперь теги для селектора мы берем из json, который генерится каждый раз, когда пользователь что-то вводит в селектор
  end
end


# Так же дополнительно можно добавить атрибуты классов и data в форму questions/_form.html.erb чтобы использовать такой-же ассинхронный запрос и там, на страницах questions/new.html.erb и questions/edit.html.erb
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
