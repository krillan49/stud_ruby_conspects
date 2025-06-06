# (??? Разбить фаили на отдельные для моделей и миграций, отдельный для контроллеров и маршрутов и отдельные еще для всякого, либо отделить только генераторы и консоль ???)

puts '                                               generate'

#  Вместе с гемом Рэлс поставляется специальный бинарный фаил который отвечает за команду "rails" которая отвечает за множество всего: запуск приложения, создание приложения, генераоры итд

# Генератор - команда которая создает типовой код

# generate - команда для запуска генераторов с различными параметрами

# > rails generate генератор параметры_генератора
# > rails g генератор параметры_генератора
# > rails g                                        - проверить все существующие в проекте генераторы(как от Рэилс так и от гемов)

# Виды генераторов(бывают как от самого Рэилс так и от различных гемов):
# controller - генератор контроллеров с маршрутами и предсталениями для них
# model      - генератор моделей и миграций
# migration  - генератор миграции без модели
# scaffold   - генератор одновременно для модели, контроллера, экшенов, маршрутов, представлений, тестов по REST resourses.

# Не обязательно пользоваться генераторами и можно все создавать вручную



puts '                                                  MVC'

# MVC(Model, View, Controller) - архитектура/паттерн, разделяющий приложение на 3 части, в каждой из которых высокая связанность, при слабой связанности между самими частями
# Model      - бизнес логика/функционал, упарвление базами данных, возвращает данные
# View       - виды/представления, то что видит пользователь
# Controller - управляющая прослойка между Model и View, осуществляет их взимодействие


# В случае с Рэилс запрос браузера сначало попадает в Rails router(его конфигурация находится в /config/routes.rb), а уже оттуда, в соответсвии с прописанными там машрутами, передается в контроллер, контроллер делает запрос к модели, модель обращается в БД, передает данные в виде сущности контроллеру, он передает их в представление, получает html-страницу, сенерированную на базе этого представления и отпрвлет эту html-страницу браузеру

# Controller - выполняет обработку URL запросов от браузера. В зависимости от типа и URL запроса, возвращает браузеру определенный HTML шаблон. Перед открытием шаблона контроллер может связаться с моделью и получить значения из БД, которые будут переданы в шаблон.
# View       - выполняет роль обычного HTML шаблона, который будет показан пользователю в качестве страницы веб сайта. Эти шаблоны вызываются при помощи контроллеров в зависимости от URL адреса запроса.
# Model      - отвечает за функциональную часть в приложении. В моделях происходит связь с базой данных, работа с API итд. Получив какие-либо значения из базы данных их можно передать обратно в контроллер и далее они будут переданы во view.

# Зачем вообще нужно разеление на слои M, V и C, а не например распихать все по отдельным сервисам? Чтобы код был более поддерживаемым и понятным?



puts '                                     MVC и многоуровневая архитектура'

# Есть например контроллеры и модели, контроллеры "знают" о моделях или зависят от них, тк они используют какой-то ункционал из них, но модели "не знают" о контроллерах и не зависят от них. Лучсше всегда согхранять эту однонаправленность в зависимостях и не создавать например в модели функционад както зависящий от контроллера, а добавлять такой функционал в контроллер. В этом случае мы эту независимую(зависимую только от БД) модель использовать не только в этом контроллере, но и гдето еще, даже параллельно в другом приложении, например консольном, с вешним API или для Телеграм-бота

# Лучше всего слои раскладывать примерно так:
# 1. Модели - не зависят ни от чего кроме БД (но в Рэилс всетаки немного зависит, например метод permited у params)
# 2. Контроллеры - могут зависеть от моделей
# 3. Хэлперы - могут зависеть от моделей, но не зависят от вьюх и контроллеров
# 4. Вьюхи - могут зависеть от моделей, хелперов и контроллеров. По сути это часть контроллера, как вспомогательная функция, тк имеет доступ к переменным контроллера

# Если надо добавить какой-то доп метод в приложение нужно учесть от каких слоев он будет зависеть для возможности своей работы и соответсвенно создавать его в соответсвующем слое




puts '                                     Модели и миграции(ActiveRecord)'

# Миграции - это руби код, с помощью которого описывается, какие таблицы в БД нужно создать, модифицировать итд. Миграции располагаются по меткам времени(в названии 20230701043625_cr...), те можно четко отследить что и в какой последовательности делали. Когда наш проект переносится на другой носитель, то мы можем при помощи одной команды применить все миграции и таким образом наша БД оказывается сразу в нужном нам состоянии, со всеми нужными таблицами, связями итд

# Роль миграции - это изменение структуры БД (не данных), приведение ее в соответсвие с нашим кодом, тоесть например таблица имела все поля соответсвующие свойствам модели итд. В каждой миграции есть описание изменений структуры БД. Нужны чтобы развернуть приложение с 0 на другой машине.
# Структура данных - это не сами данные, а набор таблиц и их свойств
# В Рэилс миграция это код на Руби, который навпрямую генерит SQL запросы и меняет структуру БД

# В начале имени фаила миграции всегда идет дата, например 20230701043625_create_articles.rb она обозначает момент создания этой миграции, она нужна чтобы миграции накатывались потом в порядке этих дат

# rails db:migrate - команда выплняет все миграции, а каждая миграция отправляет в БД инструкцию(SQL-запросы) на создание, изменение, удаление таблиц или их элементов, приводя БД в соответсвие с кодом приложения

# rails db:rollback - откат всех миграций, приведет БД к состоянию о наката этих миграций

# Не стоит менять что-то в классе миграции, когда ее уже накатили, правильный вариант сперва откатить миграцию, потом поменять что-то в ней, а потом снова накатить

# После того как создали миграции и залили их в репозиторий лучше их уже не менять, а создавать другие миграции которые что-то изменять, тк у других разработчиков уже может быть другая структура БД и они сами чтото меняли поверх старых миграций



# Создание БД через командную строку(в Rails 7 уже есть по умолчанию development.sqlite3 и создаст только test.sqlite3):
# > rails db:create RAILS_ENV=development       -  для Виндоус
# > RAILS_ENV=development rails db:create       -  для *никс
# Если используется другая СУБД например PostgreSQL, перед выполнением команды она должна быть запущена

# Модели в Рэилс, хранятся в отдельных фаилах в каталоге app/models/

# Модели можно создавать при помощи генератора или вручную

# Роль модели в Рэилс приложении - это предоставлять возожность читать и менять данные из БД, по принципу "1 Модель - 1 таблица"

# Примечание. Почти всегда название таблицы это множественное число от названия модели переведенное в снэйк-кейс, но иногда Рэилс делает нестандартно, например для модели Person создаст таблицу people, а не persons
# В книге "Rails. Гибкая разработка веб-приложений" (Руби, Томас, Хэнссон) можно прочитать про соглашения об именах.


# config/database.yml  - настройки БД Рэилс проекта (в том числе пароли если например СУБД Постгресс, где будет хранится фаилы БД и всякие другие доп настройки) хранятся в этом фаиле. !!! Данный фаил от реального проекта не должен попадать в репозиторий, те может содержать пароли для продакшена !!!

# По умолчанию Rails настроен на работу с СУБД sqlite3



puts '                                      Генерация модели и миграции'

# 1. Создание модели и миграции при помощи команды генератора модели:

# > rails g model Article title:string text:text
# model                     - генератор модели и миграции;
# Article                   - название модели(в единственном числе, не обязательно с большой буквы);
# title:string text:text    - свойства класса модели, те столбцы таблицы и типы данных для них(при генерации модели :string не обязателен тк этот тип данных будет и по умолчанию);

# После запуска команды при помощи active record будет автоматически созданы и описаны в выводе:

# а. app/models/article.rb  -  фаил модели
class Article < ApplicationRecord # Название в единственном числе
  # Модели наследуются от главной модели ApplicationRecord, а она от ActiveRecord::Base (для методов AR ?) содержит has_many, validates итд
end

# Как Рэилс понимает какие методы есть в Модели (например свойства сущностей) - в момент 1го обращения(создания экземпляра, тоесть сущности) к этому классу, Рэилс берут из config/database.yml инфу о БД, обращаются к этой БД, чтобы запросить набор доступных полей, на лету добавляют классу модели геттеры и сеттеры соответсвующие названиям колонок таблицы.
# Колонки стоит называть так чтобы они не конфликтовали с уже имеющимися ключевыми словами или методамси Руби или Рэилс, тк от их имен будут созданы и методы модели

# б. db/migrate/20230701043625_create_articles.rb (articles - множественное число) - миграция(с уже заполненным методом change)
class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|  # таблица создается в той БД, которая указана в конфигурации config/database.yml
      t.string :title
      t.text :text

      t.timestamps                 # добавлено автоматически без необходимости указания в команде генерации модели
    end
  end
end

# в. юнит тесты для модели (можно удалить, тк чаще всего используются тесты Rspec)


# 2. далее выполняем миграцию при помощи команды, которая создаст таблицу в БД и саму БД(если она еще не создана).
# Можно использовать или rake или rails как алиасы:
# > rake db:migrate
# > rails db:migrate


# 3. Отмена миграций, если сделали что-то не так
# > rails db:rollback         - отменит все сделанные миграции(именно выполнение, те удалятся из схемы, но фаилы миграций останутся, делает дроп тайбл, тоесть данные теряются)
# > rails db:rollback STEP=1  - отменит столько последних миграций какой указан параметр после STEP=



puts '                                     Rails console(работа с моделями)'

# Консоль Рэилс - это как irb к которому добавлен функционал Рэилс и весь код нашего приложения, тоесть можно писать в ней любой рубикод и рэилскод с использованием функционала нашего приложения, например модели.


# > rails console  -  вход в консоль
# > rails c        -  вход в консоль
# > reload!        -  ??? подгрут модели ???
# > exit           -  выход
# > quit           -  выход


# 0. Всякая инфа
Rails.version      # вернет версию Рэилс
# 1. Можно создавать данные в БД при помощи AR синтаксиса:
question = Question.create(body: 'Hi Pizduc', user_id: 1)
question.body = 'Hi Kroker' # меняем значение свойства объекта модели
question.save               # изменяем в таблице в БД сзначение в колоке соответсвующей этому свойсчтву
question.destroy            # удаляем объект и строку из БД
# 2. Можно извлекать данные из БД или классов Рэилс:
Contact.attribute_names #=> ["id", "email", "message", "created_at", "updated_at"] # узнать какие свойства(поля) у сущности
Contact.all             #=> SELECT "contacts".* FROM "contacts"  => []
Article.find(6)         #=> SELECT "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 6], ["LIMIT", 1]]
Comment.last



puts '                                              Контроллеры'

# https://rusrails.ru/action-controller-overview

# Controller - это специальный класс (?или объект этого класса?) который находится в своем фаиле, он отвечает за обработку запросов с пришедших с какого-то URL адреса, он чаще всего взамодействует с какой-либо моделью (либо разными модеями, сервисами или другим функциональными классами) и возврат представлений браузеру. Тоесть контроллер запускает все необходимые действия на сервере, чтобы вернуть что либо в ответ на запрос пользователя.

# Чаще всего контроллер соответсвует определенной модели и отвечает за обработку запросов, навправленных на взаимодействие с данными за которые отвечает эта модель. Так же бывают контроллеры вообще не связанные с моделью и обрабатывабщие гдубу какихто объединенных по смыслу действий, либо контроллеры управляющие несколькими моделями

# Каждый экземпляр класса контроллера обрабатывает свой запрос, новый экземпляр контроллера создается для каждого запроса, когда Рэилс при помщи routes.rb понимает, для какого контроллера предназначен этот запрос. А между запросами данные хранятся только в куки сессиях итд.
# 1 инстанс(объект) контроллера отвечает за 1 конкретный запрос, обрабатываемый 1м экшеном этого контроллера и возвращающим один ответ

# Экшен (действие) - это метод в классе-контроллере, отвечающий за определенный обработчик(get, post итд) определенного URL

# Все контроллеры наследуются от ApplicationController, а ApplicationController наследуется от ActionController::Base
ApplicationController  # /app/controllers/application_controller.rb Не имеет своего маршрута. Методы и другие параметры из него унаследуют все наши контроллеры, поэтому подходит для добавления общего для всех контроллеров функционала
ActionController::Base # (для встроенных методов Рзэилс ?) содержит методы params, respond_to итд

# Контроллер(а так же маршруты, экшены, виды итд для него) можно полностью создать вручную, а можно при помощи специальных команд в терминале.

# Название фаила контроллера somename_controller.rb где somename обычно в множественном числе, например pages



puts '                                         Генерация контроллера'

# Команда создания контроллера:
# > rails generate controller home index
# controller     - генератор контроллера, говорит о том что мы будем создавать контроллер;
# home           - название контроллера;
# index          - action(название метода/действия), можно задать несколько.

# -f  - флаг чтобы пересоздать уже существующий контроллер (удалить старый и создать новый)
# $ rails generate controller home index show -f

# В итоге было сгенерировано(В отладочной инфе пишет все что добавилось):

# 1. app/controllers/home_controller.rb - фаил в котором находится код контроллера:
class HomeController < ApplicationController # контроллер это класс наследующий от главного контроллера
  def index # экшен/действие это метод в этом классе(отвечающий за обработку URL-запросов)
    # по умолчанию обрабатывает GET 'home/index'
    # по умолчанию рэндерит представление с именем экшена из поддиректории с именем контроллера, тоесть тут это будет views/home/index.html.erb
  end
end

# 2. маршрут home/index в config/routes.rb

# 3. поддиректорию для шаблонов этого контроллера (тут app/views/home/) и в ней шаблоны для указанных в генераторе экшенах (тут index.html.erb)

# 4. тесты для контроллера (можно удалить тк обычно используется Rspec)

# 5. хэлперы хэлперы для контроллера



puts '                                Пошаговое создание контроллера(resourses)'

# Сделаем контроллер для работы с сущностями модели Article пошагово

# 1. http://localhost:3000/articles/new - выпадет ошибка Routing Error. Это происходит потому что у нас нет контроллера articles и соотв такого маршрута. Создадим контроллер(без указания экшенов):
# > rails g controller articles  (можно не использовать генератор вообще и создать вручную и фаил и сам класс)
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  # Создался пустым, тк мы не задавали 2й параметр(new)
end

# 2. http://localhost:3000/articles/new - выпадет ошибка Unknown action The action 'new' could not be found for ArticlesController. Тк как у нас не было метода экшена в классе контроллера, далее добавим его вручную:
class ArticlesController < ApplicationController
  def new
  end
end



puts '                                         Маршруты(routes.rb)'

# http://rusrails.ru/rails-routing             -  Rusrails: Роутинг в Rails
# https://guides.rubyonrails.org/routing.html

# Маршрут - это то что пишется в адресной строке браузера

# config/routes.rb - (routes - пути) в этом фаиле прописываются и присваиваются экшенам контроллеров маршруты, которые будут использоваться в приложении. Когда приходит HTTP запрос, он содержит в заголовках метод и маршрут, Рэилс смотрит в routes.rb и определяет в какой экшен какого контроллера его передавать для обработки. Этот фаил управляет тем экхемпляр какого контроллера будет создан в ответ за запрос пол какому пути

# /config/routes.rb - пропишем маршруты, те закрепим обработчики URLов за определенными экшенами определенных контроллеров:
Rails.application.routes.draw do
  # 1. Создадим корневой маршрут: home#index обычно создаётся для главной страницы, поэтому можно поменять 'home/index'(создан контроллером по умочанию) на корневой маршрут:
  get '/' => 'home#index'  # определяем маршрут вручную(хардкод). Теперь GET-запросы, которые придут с URL-адреса '/', будут отправлены на обработку в экшен index контроллера home
  # Теперь когда придет GET-запрос с URL-адреса '/' Рэилс инициализирует экемпляр контроллера home и помимо прочего будет вызван метод index этого контроллера
  # Для обработки 1 конкретный запрос, создается одельный инстанс(объект) контроллера, к которому применится 1 экшеном этого контроллера и возвращающим один ответ

  # 2. Создадим resources маршруты по паттерну REST которые будут обрабатываться контроллером ArticlesController, для работы с моделью Article:
  resources :articles
end
# Примечание: если мы прописываем несколько маршрутов URL для одного и тогоже экшена и контроллера, то он будет обрабатывать все эти маршруты


# > rails routes  -  (До версии Rails 6.1 - rake routes) эта команда из каталога конфигурации берёт файл config/routes.rb исполняет его и выводит нам список маршрутов - URLы, типы запросов и к каким представлениям они ведут.
# Так же можно смотреть маршруты в браузере введя несуществующий URL от нашего корня, либо перейти по адресу /rails/info/routes

# $ rails routes | grep questions              - например если хотим посмотреть маршруты только для вопросов
# $ rails routes | grep questions | grep show  - дополнительно выбрать пути содержанищ "show"



puts '                                           Шаблоны (Views)'

# Views - отвечают за то, что увидит пользователь, за интерфейсприложения: html-шаблоны, css-фаилы, js-скрипты и любые другие фаилы которые передаются клиенту или выполняются на стороне клиента

# Нужно минимизировать логику в html-шаблонах: выносить в хелперы, в модели, выносить итерации в паршалы

# Рэилс по умолчанию использует шаблонизатор erb чтобы интегрировать рубикод в html

# Шаблоны что рендерятся по умолчанию, берутся контроллерами по маршруту, например:
# app/views/questions/show.html.erb
# questions - имя контроллера
# show      - имя экшена
# html      - формат фаила, который был запрошен браузером и будет в нем ему отдаваться (json, xml, txt итд)
# erb       - шаблонизатор, способ всвить рубикод в шаблон (slim, haml или может отсутствовать, если отдаем стат страницу)


# @переменные видны в предстьавлении потому, что оно изначально рендерится в методе экземпляра контроллера унаследованного от ActionController::Base


# Рэилс автоматически отрисовывает Лэйаут (или макет) layouts/application.html.erb
# HTML-код лэйаута отрисовывается пока не встретит ключевое слово yield и подставляет(отрисовывает там шаблон/вью)
# Стоит с отсторожностью использовать инстанс переменные объектов в лэйаут, тк он может использоваться с теми экшенами контроллева в которых они не определяются

# Подключение стилей Font Awesome
# https://github.com/bokmann/font-awesome-rails          - гем для подключения
gem "font-awesome-rails"
# В структуре гема есть папка app/assets/stylesheets там и лежит фаил со стилями font-awesome.css.erb, его мы можем подключить в наш application.css или application.scss
fa_icon('pencil') # хэлпер гема font-awesome-rails, отображающий иконку, имя которой указываем в параметрах
link_to fa_icon('pencil'), article_path(article), title: "Четотам" # пример использования с хэлпером ссылки
button_to fa_icon('trash-o'), article_path(article), method: :delete, title: "Удалить" # пример использования с кнопкой



puts '                           Контроллер и роутинг статических страниц(не по REST)'

# Статические страницы это те, которые не изменяются динамически, те не содержат динамической информации и всегда отображаются одинаково ?? не принимают переменные из экшенов ??. Подходит например для страниц "О нас", "Контакты" итд

# Удобно создать отдельный контроллер для статических страниц
# > rails g controller pages

# Создаётся контроллер /app/controllers/pages_controller.rb, добавим экшены:
class PagesController < ApplicationController
  def terms
  end

  def about
  end
end

# Пропишем маршруты(тк удобнее получать их от корня, а не от /pages) в /config/routes.rb:
Rails.application.routes.draw do
  get 'terms' => 'pages#terms'
  get 'about' => 'pages#about', as: 'about'
  # as: 'about' - для статических тоже можно создать хэлперы юрлов, тут about_path
end

# Создадим представления /app/views/pages/terms.html.erb и /app/views/pages/about.html.erb



puts '                      Полный цикл создания контроллера, маршрутов, модели, видов(resourse)'

# Сделаем страницу /contacts с формой для контактов. Чтобы на сервер и далее в БД передавались email и message из формы контактов.

# 1. > rails g controller contacts  -  Создаем новый контроллер без экшенов
# Создалось: app/controllers/contacts_controller.rb и app/views/contacts
class ContactsController < ApplicationController
  # Добавим в ContactsController экшены
  def new    # получение страницы(форма с текстовыми полями) от сервера  - get (new по REST)
  end
  def create # отправка и обработка данных введенных пользователем на сервер - post (create по REST)
  end
end

# 2. Прописываем маршруты. Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  resource :contacts, only: [:new, :create] # resource(единственное число).

  # Но так при GET-запросе на URL /contacts выпадет Routing Error. No route matches [GET] "/contacts", потому что у этого маршрута есть только POST-обработчик(create). Переназначим маршрут GET '/contacts', чтобы он обрабатывался в экшене new, соотв возвращался вид new.html.erb с формой.(У resource по этому запросу по умолчнию show.)

  # Способ 1(хардкод):
  get 'contacts' => 'contacts#new'    # добавим обработку запроса get 'contacts' в экшен new
  resource :contacts, only: [:create] # удаляем :new из [:new, :create], те удалим обработчик get 'contacts/new ' из экшена new
  # (Чтобы пользователь получал вид и при GET запросе и на /contacts/new и на /contacts то изменим последнюю строку на resource :contacts, only: [:new, :create], те обратоно добавим :new в маршрут)

  # Способ 2(Лучше тк меняет имя хэлпера и не будет ошибок, например с приемочными тестами):
  resource :contacts, only: [:new, :create], path_names: { :new => '' } # Перенаправление идет по базовому пути { :new => '' } (По умолчанию был {:new => '/new'} ). А базовый путь для контроллера contacts это как раз /contacts
end

# 3. Создаем модель и миграцию и запускаем миграцию.
# > rails g model Contact email:string message:text
# AR создал миграцию: db/migrate/20230704072035_create_contacts.rb
class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
# AR создал модель: app/models/contact.rb
class Contact < ApplicationRecord
end
# rake db:migrate  -  запускаем миграцию и создаем таблицу в БД

# 4. Создадим представление contacts/new.html.erb и заполняем(формой)
# Добавим предствление /app/views/contacts/create.html.erb















#
