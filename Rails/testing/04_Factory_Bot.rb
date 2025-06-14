puts '                                             Factory Bot'

# https://github.com/thoughtbot/factory_bot

# FactoryBot - гем для создания тестовых данных при помощи фабрик. Он заменяет множество конструкций вроде `User.create(...)` на простые и читаемые фабрики, которые можно переиспользовать в разных тестах.

# FactoryBot по умолчанию создает объекты через ActiveRecord и потом, если объекты создавались через `create` - сохраняет их в тестовую БД, а если использовались стратегия `build` или `build_stubbed` тогда объекты остаются в памяти без сохранения в БД

# Фабрика для тестирования (Factory) - это шаблон для создания объектов, чтобы не создавать объекты для теста вручную, вместо этого создаётся фабрика, которая и будет создавать объекты для теста. Это соответствует принципу DRY. 

# Вместо ручного заполнения полей, например:
user = User.create(name: "John", email: "john@example.com", admin: false)
# Один раз описывается фабрика, например:
FactoryBot.define do
  factory :user do
    name { "John" }
    email { "john@example.com" }
    admin { false }
  end
end
# А затем в тестах просто вызывается один из методов создания объектов фабрикой, например:
user = create(:user)

# FactoryBot поддерживает:
# 1. ActiveRecord (стандартно для Rails)
# 2. Другие ORM (например, Sequel, Mongoid)
# 3. Plain Ruby-объекты (если у них есть сеттеры для атрибутов)

# Плюсы FactoryBot
# 1. Уменьшает дублирование кода - один шаблон для всех тестов (DRY)
# 2. Делает тесты читаемыми - `create(:user)` вместо 10 строк `User.new(...)`
# 3. Гибкость - traits, наследование, динамические значения
# 4. Интеграция с Faker - реалистичные тестовые данные
# 5. Удобно использовать вместе RSpec, Minitest или при наполнении БД через rails console

# Раньше был другой гем gem Factory Girl(устарел)
# https://github.com/thoughtbot/factory_bot/blob/v4.9.0/UPGRADE_FROM_FACTORY_GIRL.md
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md



puts '                                         Установка и настройка'

# Установка для Рэилс (Для Рэилс и без него разные подгемы и разная настройка):

# 1. Gemfile:
group :development, :test do
  gem "factory_bot_rails"
end
# > bundle install


# 2. Настройка конфигурации:

# а) Для rspec:
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
# добавить эти настройки конфигурации можно напрямую в /spec/rails_helper.rb, либо более правильный вариант добавить настройки конфигурации в spec/support/factory_bot.rb и подключить этот файл в фаиле rails_helper.rb
require 'support/factory_bot'

# б) Для minitest - подключить в test/test_helper.rb
class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  # ...
end



puts '                                              Разное'

# !!! Для Windows 10 - тесты с использованием Factory Bot нужно запускать в классической командной строке, в повершелл тесты будут выполняться 2 раза: по полному адресу и относительному, что может привести к ошибкам в некоторых тестах



puts '                                     Создание и применение фабрики'

# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Defining_factories

# /spec/factories - создадается каталог с фабриками для rspec
# /test/factories - создадается каталог с фабриками для minitest

# /spec/factories/articles.rb - создадим файл для фабрики создающей объекты модели Article.
FactoryBot.define do # определяем фабрики
  # factory - метод создает фабрику, принимает ее имя, например :article, по умолчанию будет использовать соответсвующую имени фабрики модель Article
  factory :article do
    # Атрибуты (Attributes) задаются методами, одноименными полям целевой модели, а в блоках принимаются значения по умолчанию для них, которые будут присвоены во все создаваемые объекты, можно прописать другие значения уже непосредственно при создании объекта. При создании объектов будет происходить валидация, если она прописана в модели, так что значения должны соответсвовать, если мы хотим ее пройти в тесте
    title { "Article title" }       # а) атрибут со статическим значением           
    email { Faker::Internet.email } # б) значение можно генерировать динамически, например при помощи Faker
    # Поля могут зависить от других атрибутов (через ленивые вычисления)
  end
end
# Теперь эта фабрика может создавать сущности модели Article со значениями для полей title и email

# Добавим метод в models/article.rb чтобы протестировать его с использованием созданной фабрики:
class Article < ApplicationRecord
  validates :title, presence: true
  validates :email, presence: true

  def subject # метод экземпляра который будем тестировать (возвращает название статьи через ее геттер)
    title
  end
end

# Добавим новый тест в /spec/models/article_spec.rb
describe Article do
  # ...какието describe/it
  describe "#subject" do
    it "returns the article title" do
      article = create(:article, title: 'Foo Bar') # создаем объект Article при помощи фабрики
      # create           - статический метод factory_bot для создания сущности
      # :article         - имя фабрики
      # title: 'Foo Bar' - (опционально) меняем значение title со значения по умолчанию заданное в фабрике на другое

      expect(article.subject).to eq 'Foo Bar' # проверяем что метод subject возвращает указанное значение title сущности
    end
  end
end
# > rake spec



puts '                           FactoryBot + ActiveRecord. Методы создания объектов'

# FactoryBot по умолчанию использует модели (например, User, Product) и объекты через ActiveRecord

# FactoryBot учитывает валидации модели, соответсвенно фабрика должна иметь все поля, наличие которых требуется валидациями и они должны соответсвовать доп условиям валидации


# Пример фабрики:
FactoryBot.define do
  factory :user do
    name { "John" }
  end
end


# 1. create - создание объектов с записью данных в тестовую БД (например, db/test.sqlite3 или test-схема в PostgreSQL). Из-за того что `create` записывает данные в БД он медленнее чем `build`
# Если в тесте вызывается, например:
user = create(:user)
# FactoryBot под капотом: 
User.new(name: "John") # а) создает объект модели User и заполняет атрибуты соответсвующими данными из фабрики 
user.save!             # б) вызывает `user.save!`, чтобы записать данные в тестовую БД (INSERT INTO users ...)

# RSpec/Minitest автоматически очищают БД после каждого теста (через транзакции). В других случаях, если автоматической очистки нет, подключите `database_cleaner`
# При запуске тестов Rails автоматически перезагружает тестовую БД из schema.rb/structure.sql

# Чтобы проверить, что FactoryBot работает с БД, после создания объекта фабрикой в тесте можно зайти в консоль тестовой БД и выполнить SQL-запрос, на который должна вернутся запись:
# $ rails dbconsole -e test
# > SELECT * FROM users;


# 2. build - (работа без БД) создает объект в памяти через .new, но не сохраняя данные в БД. Используйте `build` там, где не нужна работа с БД, тк он работает быстрее чем `create`
# Если в тесте вызывается например:
user = build(:user)
# FactoryBot под капотом:
User.new(name: "John") # берет модель User, создает объект и заполняет атрибуты соответсвующими данными из фабрики
# Но далее не сохраняет эти данные в БД:
user.persisted? #=> false


# 3. build_stubbed - (работа без БД, но с иммитацией этого) создает заглушку с fake id, но без обращения к БД. Полезно для тестов, где нужно имитировать сохраненный объект без реальных запросов к БД
user = build_stubbed(:user)
# FactoryBot под капотом:
User.new(name: "John", id: 123) # берет модель User, создает объект, заполняет атрибуты соответсвующими данными из фабрики и дополнительно заполняет атрибут `id` фэйковым айдишником
# Далее ActiveRecord считает, что это сохраненный объект
user.persisted? #=> true       (но в БД ничего нет!)


# 4. ???
attributes_for(:user) # возвращает хэш атрибутов (полезно для API-тестов)



puts '                                Использование FactoryBot без ActiveRecord'

# Можно использовать FactoryBot Без ActiveRecord, но это редкий сценарий

# Обычный класс создающий Ruby-объект без участия БД:
class User
  attr_accessor :name
end

FactoryBot.define do
  factory :user do
    name { "John" }
  end
end

user = build(:user) # Просто вызовет `User.new`



puts '                              Фабрики с ассоциациями (для модели с belongs_to)'

# Ассоциации (Associations) - позволяют фабрике автоматически создавать связанные объекты.

# Если модель, для которой фабрика создает объекты, имеет ассоциацию `belongs_to` к другой модели, то и фабрика должна иметь ассоциацию с другой фабрикой, которая описывает связанную модель с ассоциацией, например `has_many`, иначе вылезет ошибка (например "User must exist")

# Модель Post
class Post < ApplicationRecord
  belongs_to :user, required: true
end

# Модель User
class User < ApplicationRecord
  has_many :posts
end

# Фабрика users.rb
FactoryBot.define do
  factory :user do
    email { "user@mail.ru" }
    username { "username" }
    password { "123456" }    # password, для колонки encrypted_password
  end
end

# Отдельная фабрика для админов для примера 4а в фабрике :post:
FactoryBot.define do
  factory :admin_user, parent: :user do
    role { 'admin' }
  end
end

# association - метод, это "умная" версия create, который учитывает настройки ассоциаций в модели (например, optional: true) и эффективнее работает в цепочках фабрик

# Фабрика posts.rb - добавляем в нее связь с user
FactoryBot.define do
  factory :post do
    content { "Post content" }

    # Вариант 1 - полная форма с явным указанием ассоциации
    association :user # метод создает связанный объект User и привязывает его к посту через ассоциацию user_id.
    # Под капотом FactoryBot ищет фабрику `:user` (по имени ассоциации), cоздает объект User через эту фабрику (со всеми её атрибутами) и присваивает созданного пользователя полю user в модели Post. Если в тесте используется create(:post), то сначала сохраняет User в БД, а затем сохраняет Post с подставленным user_id.
    # Эквивалент: Post.create(content: "Post content", user: User.create(email: "user@mail.ru", ...))

    # Вариант 2 - короткая форма, делает тоже самое что и вариант 1. Автоматически использует фабрику :user (так как ассоциация в модели Post называется user). Создает нового пользователя через create(:user) и привязывает его к посту
    user
    # Удобно использовать когда  в модели Post есть стандартная ассоциация `belongs_to :user`

    # Вариант 3 - ручное создание объекта вместо метода association. Подходит, если нужно переопределить атрибуты пользователя
    user { create(:user) }  # Явное создание без переопределения это аналог вариантов 1 и 2
    user { create(:user, email: "custom@example.com") } # Позволяет переопределить атрибуты пользователя
    
    # Вариант 4 - полная форма с дополнительными параметрами, например:
    association :user, factory: :admin_user      # а) Можно использовать другую альтернативную фабрику, например тут отдельная фабрика для админов (которая должна быть)
    association :author, factory: :user          # б) Ассоциация с другим именем, например ассоциация в модели Post `belongs_to :author, class_name: "User"`. Создает пользователя через :user, но привязывает его к полю author_id в Post. Это будет эквивалентно: Post.create( content: "Post content", author: User.create(email: "user@mail.ru", ...) )
    association :user, strategy: :build          # в) Использование `build` вместо `create` не сохраняет пользователя в БД. Если в тесте не нужны реальные записи в БД (ускоряет тесты)
    association :user, strategy: :build_stubbed  # г) build_stubbed - Пользователь не сохраняется в БД, но у него есть id (например, 123)
  end
end

# Вложенные ассоциации: если фабрика :user сама имеет ассоциации, они тоже будут созданы 
factory :user do
  association :company  # Будет создана и компания! (Используйте build для вложенных ассоциаций, если они не нужны)
end
create(:post)  # Создаст Post -> User -> Company

# Использование traits, если нужно несколько типов авторов:
factory :post do
  content { "Post content" }

  trait :with_admin_author do
    association :author, factory: :user, admin: true
  end
end
# Использование
post = create(:post, :with_admin_author)

# post_spec.rb (для вариантов из фабрики 1 и 2)
describe Post do
  # ...
  describe "#columns" do
    it "returns the post content" do
      # а) Метод association позволяет создать post без явного создания пользователя, тк :post автоматически создаст пользователя через фабрику :user и привязывает его к посту, благодаря `association :user` в фабрике :post
      post = create(:post, content: 'a' * 100)  # Автоматически создаст user

      # б) Но если тест должен изменять пользователя, то можно задать все явно:
      user = create(:user, email: "vasya@gmail.com")       # Создаём пользователя явно, чтобы кастомизировать его email
      post = create(:post, content: 'a' * 100, user: user) # Привязываем пост к созданному юзеру явно, тк это уже не тот же юзер что создается в фабрике по умолчанию

      expect(post.content).to eq 'a' * 100
    end
  end
end


# Пример создания сущности с 2мя связями явно
create(:order, user: create(:user, :admin), product: build(:product))



puts '                               Фабрика для модели с polymorphic ассоциацией'

# Такой же как прошлый (используем фабрики из него), только для полиморфно ассоциированного комментария(к постам и картинкам и одновременно 1 ту мэни к юзерам)

# Модель Comment
class Comment < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :commentable, polymorphic: true
end

# Модель Post
class Post < ApplicationRecord
  belongs_to :user, required: true
  has_many :comments, as: :commentable
end

# Модель User
class User < ApplicationRecord
  has_many :posts
end

# Фабрика users.rb
FactoryBot.define do
  factory :user do
    email { "user@mail.ru" } # либо sequence(:email) { |n| "user#{n}@mail.ru" }
    username { "username" }  # либо sequence(:username) { |n| "username#{n}" }
    password { "123456" }    # password, для колонки encrypted_password
  end
end

# Фабрика posts.rb - добавляем в нее связь с user
FactoryBot.define do
  factory :post do
    content { "Post content" }

    # Вариант 1 - короткая форма. Автоматически использует фабрику :user (так как ассоциация в модели Post называется user). Создает нового пользователя через create(:user) и привязывает его к посту
    user
    # Эквивалент: Post.create(content: "Post content", user: User.create(email: "user@mail.ru", ...))
    # Удобно использовать когда  в модели Post есть стандартная ассоциация b`elongs_to :user`

    # Вариант 2 - полная форма с явным указанием ассоциации, делает тоже самое что и вариант 1.
    association :user
    
    # Вариант 3 - полная форма с дополнительными параметрами, например:
    association :user, factory: :admin_user  # а) Можно использовать другую альтернативную фабрику
    association :author, factory: :user      # б) Ассоциация с другим именем, например ассоциация в модели Post `belongs_to :author, class_name: "User"`. Создает пользователя через :user, но привязывает его к полю author_id в Post. Это будет эквивалентно:
    # Post.create( content: "Post content", author: User.create(email: "user@mail.ru", ...) )
  end
end

# Фабрика comments.rb
FactoryBot.define do
  factory :comment do
    body { "Comment body" }
    user
  end
end

# Тест comment_spec.rb
require 'rails_helper'
describe Comment do
  # ...
  describe "#columns" do
    it "returns the comment body" do
      user = create :user
      post = create(:post, content: 'a' * 100, user: user)     # создаем пост тк ему тоже принадлежит как комментайбл
      comment = create(:comment, body: 'aaa', commentable: post, user: user) # тут добавляем пост в commentable
      expect(comment.body).to eq 'aaa'
    end
  end
end
# > rake spec



puts '                                   Sequences. Вложенная фабрика'

# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Sequences   # Sequences (последовательности):
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md             # create_list (через поиск по странице):

# Добавим метод в модель /app/models/article.rb
class Article < ApplicationRecord
  # ... пред код ....

  # Создадим метод last_comment и протестируем его:
  def last_comment # метод возврата последнего комментария(это метод экземпляра а экземпляр это сущность статьи)
    comments.last # последний комментарий из колекции комментов этой статьи, тк comments, тоже метод экземпляра, возвращающий массив комментариев
  end
end

# Создадим фабрику для создания комментариев /spec/factories/comments.rb:
FactoryBot.define do
  factory :comment do
    author { "Chuck Norris" }
    # вместо, например, body { "Kick" } напишем:
    sequence(:body) { |n| "Comment body #{n}" } # так комментарии будут создаваться разными значениями поля body, например 1й коммент "Comment body 1", 2й "Comment body 2" итд
    # sequence - метод принимает название поля и блок со значением
  end
end

# Добавим в фабрику article, чтобы возвращать статью сразу с комментариями /spec/factories/articles.rb:
FactoryBot.define do
  factory :article do
    title { "Article title" }
    text { "Article text" }

    # создаём фабрику для создания статьи с несколькими комментариями(создаем фабрику внутри блока фабрики article)
    factory :article_with_comments do
      after :create do |article, evaluator|
      # after     - метод срабатывающий после чего либо.
      # :create   - имя метода вызванного в тесте после которого сработает after. Те после создания article в тесте
      # article   - каждая статья (много если бы создавали с sequence)
      # evaluator - не обязательный параметр
        create_list :comment, 3, article: article # создаём список из 3-х комментариев(:comment из фабрики комментариев ??)
        # article: article - указываем тк в модели у нас коммент принадлежит статье, параметр статья созданная в тесте, значение ее айди попадет в каждый созданный фабрикой коммент ??
      end
      # Те после создания article создаём список из 3-х комментариев в каждом из которых есть айдишник этой статьи ??
    end

  end
end

# В /spec/models/article_spec.rb создадим статью с комментариями для тестирования:
require 'rails_helper'

describe Article do
  # ... предыдущие тесты ...

  describe "#last_comment" do
    it "returns the last comment" do
      article = create(:article_with_comments) # создаём статью с 3 комментариями
      expect(article.last_comment.body).to eq "Comment body 3" # проверка: проверяем значение поля боди последнего коммента(тк у нас их 3, то и в значении будет 3)
    end
  end
end
# > rake spec






FactoryBot.define do
  factory :product do
    sequence(:nm_id)      { |n| n }
    sequence(:imt_id)     { |n| n }
    brand                 { "Sample Brand" }
    title                 { "Sample Product Title" }
    description           { "This is a sample product description." }
    big_photo_url         { "https://picsum.photos/500" }
    small_photo_url       { "https://picsum.photos/100" }
    color                 { "Red" }
    vendor_code           { "ADC987654" }

    association :status,   factory: :dictionary
    association :category, factory: :product_category
    cabinet
  end
end

association :status,   factory: :dictionary
association :category, factory: :product_category
# Эти строки в фабрике Product определяют ассоциации (связи) с другими моделями через FactoryBot


association :status, factory: :dictionary # Создает связь между Product и моделью Dictionary (предположительно, справочник статусов товаров)
# :status              - имя ассоциации в модели Product (например, belongs_to :status).
# factory: :dictionary - указывает, что для создания связанного объекта нужно использовать фабрику :dictionary.

# Аналог без association:
status { create(:dictionary) }

# Если у товара (Product) есть статус (например, "в наличии", "под заказ"), он хранится в отдельной таблице dictionaries. Эта строка автоматически создает запись в таблице dictionaries и связывает ее с товаром.


association :category, factory: :product_category
# Создает связь между Product и моделью ProductCategory (категория товара).
# :category                  - имя ассоциации в модели Product (например, belongs_to :category).
# factory: :product_category - использует фабрику :product_category для создания связанной категории.

# Аналог без association:
category { create(:product_category) }

# Категории товаров обычно вынесены в отдельную таблицу. Эта строка создает категорию через фабрику :product_category и привязывает ее к товару.




# Если не указать `factory: :product_category`, то FactoryBot попытается найти фабрику с именем, как у ассоциации (тоесть :category). Указание factory нужно, если имя фабрики отличается от имени ассоциации.

# Как избежать создания лишних объектов?
# Если тест не требует реальной категории/статуса, можно использовать build_stubbed (создает заглушку без сохранения в БД):
association :status, factory: :dictionary, strategy: :build_stubbed


# Пример в контексте модели Product. Предположим, модель выглядит так:
class Product < ApplicationRecord
  belongs_to :status, class_name: "Dictionary"
  belongs_to :category, class_name: "ProductCategory"
end
# Тогда фабрика создаст:
# Продукт (Product).
# Отдельную запись в таблице dictionaries (через фабрику :dictionary)
# Отдельную запись в таблице product_categories (через фабрику :product_category)
# Все объекты будут автоматически связаны через внешние ключи (product.status_id и product.category_id).
