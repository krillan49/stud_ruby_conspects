puts '                                       Rails разное'

# ТУДУ:
# 1. Создать фаил со всеми гемами и их описанием, чтобы потом их удобно выбирать



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
# про форматы
# some.xlsx.axlsx
# some.html.erb
# axlsx и erb - это хэндлеры, которые обрабатывают програмный код написанный на Руби, для последующей генерации фаила
# xlsx и html - это формат в котором мы генерируем итоговый фаил


puts
# гем pry-rails  для дебага в Рэилс при помощи остановки выполнения кода в некой точке
group :development, :test do
  gem 'pry-rails'
end
# > bundle i

binding.pry # ставим это на любой позиции в коде, например в контроллере, тогда программа прерывается, когда код дойдет до этой точки и можно проверять все переменные и другой функционал в этой точке, прямо в выводе Рэилс


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
# На выходе на странице получим такие записи для каждого объекта
{
  id: 1,
  title: 'some'
}


puts
redirect_to(request.referer) # редирект на страницу с которой делали переход на этот контроллер



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























#
