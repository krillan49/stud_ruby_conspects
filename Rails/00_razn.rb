puts '                                           Rails разное'

# bundle:
# > bundle install      - устанавливает гемы, указанные в Gemfile проекта, учитывая указанные версии
# > bundle i            - тоже самое что и bundle install
# > bundle              - тоже самое что и bundle install, раньше этого не было
# > bundle update
# > bundle outdated     - проверить какие библиотеки в нашем приложении можно обновить
# > bundle out          - алиас для outdated
# > bundle exec some    - запускает что либо(тут some) с набором именно тех гемов что есть в гемфаиле
# Останавливаем сервер Рэилс при манипуляциях с бандл



# https://dev.to/cherryramatis/simple-repository-pattern-for-ruby-on-rails-2lje    модель-репозиторий паттерн

# https://softwareengineering.stackexchange.com/questions/230307/mvc-what-is-the-difference-between-a-model-and-a-service       отличия модели и сервиса

# Модель это потомок ActiveRecord, это класс-обертка над записью из БД.

# Сервис это класс, который взаимодействует с одним или несколькими другими классами, моделями или сервисами или другими типами
# Тоесть сервис это управляющий класс для взаимодействия других классов, как контроллер, только не для взаимодейсвия моделей и вьюх, а для чегото другого

# Есть еще один популярный паттерн — query object, он очень похож на сервисы, но там только работа с базой, всякие огромные запросы с фильтрами и т.п.
# Как пример, построенный вокруг юзера: нам нужно создать юзера и назначить ему ментора плюс подключить рассылку. Реализация:
# * в UsersController#create вызываем сервис CreateUser
# * в сервисе CreateUser создаем пользователя, тут все обычно
# * в сервисе CreateUser вызываем сервис AssignMentor
# * в сервисе AssignMentor запускаем query-объект класса SelectNotStupidUsers, выбираем наименее занятого, назначаем новому юзеру
# * возвращаемся в сервис CreateUser, вызываем сервис SubscribeToSpam
# * в SubscribeToSpam создаем объект Subscription с нашим юзером
# * возвращаемся в сервис CreateUser, выходим из него



# "Опыт оптимизации sql запросов и приложения под высокую нагрузку" - Какие действия можно таковыми считать?
# исключение n+1 в запросах
# оптимизация индексов (а какие они вообще бывают?)
# работа с локами БД.
# Eager loading vs lazy loading - что, когда.
# Кэширование запросов
# для приложения - connection pool, параллелизм и конкаренси, треды и ракторы. Мьютексы. Как много IO может блокировать тред и как с этим бороться. Race conditions и как с этим бороться
# в БД добавить - нормализация/денормализация, вывод непринципиальных вещей типа счетчиков в in-memory хранилище.



# load_async - метод позволяет в контроллере создавать ассинхронные запросы к БД(тоесть не один за другим а парраллельно). Это значительно ускоряет загрузку данных на страницу если запросы между собой не связаны
def index
  @tags = Tag.where(id: params[:tag_ids]).load_async # просто добавляем его последним методов в запросе
  @questions = Question.all.load_async
  # Теперь эти запросы будут выполняться параллельно
end



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

















#
