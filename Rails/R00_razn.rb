puts '                                           Rails разное'

# ТУДУ:
# 1. https://habr.com/ru/articles/191762/  - пройти (различные способы загрузки ассоциаций)


# load_async - метод позволяет в контроллере создавать ассинхронные запросы к БД(тоесть не один за другим а парраллельно). Это значительно ускоряет загрузку данных на страницу если запросы между собой не связаны
def index
  @tags = Tag.where(id: params[:tag_ids]).load_async # просто добавляем его последним методов в запросе
  @questions = Question.all.load_async
  # Теперь эти запросы будут выполняться параллельно
end



# Пример из blog2(с Devise):
# При редиректе с fallback_location: происходит почемуто множественный редирект если пользователь не соответсвует фильтру:
class ProtectedController < ApplicationController
  before_action :admin? # Если пользователь не админ то ...

  def users_list # get 'users_list'
    @users = User.all
  end

  private

  def admin?
    unless user_signed_in? && current_user.try(:admin?)
      # ... так будет множественный редирект и браузер выдаст ошибку
      redirect_back fallback_location: root_path, notice: 'User is not admin'

      # ... а так будет все ок
      redirect_to root_path, notice: 'User is not admin'
    end
  end
end


puts
# Пример из blog2(с Devise):
# при удалении контента по ссылкам с видов другого контроллера перенаправляет на страницу соотв контента, а нужно на ту же страницу(?? нужны отдельные экшены для удаления и создания в другом контроллере?)


puts
# что выводит params
params.inspect #=> #<ActionController::Parameters {"controller"=>"comments", "action"=>"index"} permitted: false>


puts
# https://stackoverflow.com/questions/2165665/how-do-i-get-the-current-absolute-url-in-ruby-on-rails
request.fullpath #=> возвращает относительный URL на который пришел запрос в данный экшен. Так же можно использовать в представлении

puts
redirect_to(request.referer) # редирект на страницу с которой делали переход на этот контроллер


puts
# про форматы
# some.xlsx.axlsx
# some.html.erb
# axlsx и erb - это хэндлеры, которые обрабатывают програмный код написанный на Руби, для последующей генерации фаила
# xlsx и html - это формат в котором мы генерируем итоговый фаил


puts
# Представления формата json. Пример для использования с jBuilder:
# index.json.jbuilder - название
# Пример содержания фаила с отображением свойств коллекции объектов
json.array! @tags do |tag|
  # json.array! - создаем массив из json объекта переданного сюда
  # @tags - коллекция сущностей из БД
  json.id tag.id
  # json.id - будет название поля в json объекте
  # tag.id - будет значение поля в json объекте
  json.title tag.title
end
{ id: 1, title: 'some' } # На выходе на странице получим такие записи для каждого объекта



puts
# Настройка временной зоны проиводится в фаиле config/application.rb
module AskIt
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.i18n.available_locales = %i[en ru]
    config.i18n.default_locale = :en
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"               # Вот тут можно ее переопределить
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end


puts
# ?? ( Рэилс )Возвращает true, если этот объект включен в аргумент. Аргументом должен быть любой объект, который отвечает на include?
characters = ["Konata", "Kagami", "Tsukasa"]
"Konata".in?(characters) # => true



# "Опыт оптимизации sql запросов и приложения под высокую нагрузку" - Какие действия можно таковыми считать?
# исключение n+1 в запросах
# оптимизация индексов (а какие они вообще бывают?)
# работа с локами БД.
# Eager loading vs lazy loading - что, когда.
# Кэширование запросов
# для приложения - connection pool, параллелизм и конкаренси, треды и ракторы. Мьютексы. Как много IO может блокировать тред и как с этим бороться. Race conditions и как с этим бороться
# в БД добавить - нормализация/денормализация, вывод непринципиальных вещей типа счетчиков в in-memory хранилище.





















#
