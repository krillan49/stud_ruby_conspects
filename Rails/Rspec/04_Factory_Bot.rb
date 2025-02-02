puts '                                         Factory Bot. Настройка'

# https://github.com/thoughtbot/factory_bot

# Factory Bot - гем для создания фабрик при тестировании

# Фабрика для тестирования - нужна чтобы не создавать в AR объекты для теста и тестовую БД, вместо этого создаётся фабрика, и она будет создавать нам объекты для теста. Это соотв принципу DRY тк не нужно создавать тестовую БД

# ?? Создается в БД просто данные после теста затираются или просто в памяти ??

# Раньше был другой гем gem Factory Girl(устарел)
# https://github.com/thoughtbot/factory_bot/blob/v4.9.0/UPGRADE_FROM_FACTORY_GIRL.md
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md


# Установка для Рэилс (Для Рэилс и без него разные подгемы и разная настройка):

# Gemfile:
group :development, :test do
  gem "factory_bot_rails"
end
# > bundle install

# Настройка конфигурации(2 варианта, оба работают, оставил 2й):
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
# 1.(из конспектов рубишколы) добавить настройки конфигурации в /spec/rails_helper.rb.
# 2.(из документации) добавьте настройки конфигурации в spec/support/factory_bot.rb (предварительно создав папку support).
# и обязательно подключить этот файл(support/factory_bot.rb) в фаиле rails_helper.rb
require 'support/factory_bot'


# (!!!Для Windows - тесты с использованием Factory Bot нужно запускать в классической командной строке, в повершелл тесты будут выполняться 2 раза: по полному адресу и относительному, что может привести к ошибкам в некоторых тестах)



puts '                                     Создание и применение фабрики'

# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Defining_factories

# /spec/factories - создадим каталог с фабриками

# /spec/factories/articles.rb - создадим файл в котором будем создавать фабрику для article:
FactoryBot.define do # определяем фабрики
  factory :article do # фабрика article. По умолчанию будет брать модель Article и устанавливать в нее свойсва:
    # Зададим свойства и их значения, тк наши тесты будут проверять их валидацию и без них выдадут ошибки валидации
    title { "Article title" } # содержание параметра не важно можно любое
    text { "Article text" }
  end
end
# Теперь наша фабрика может создать сущность Article с полями title и text

# Добавим метод в models/article.rb чтобы протестировать его с использованием созданной фабрики:
class Article < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true
  has_many :comments

  def subject # добавим метод экземпляра который будем тестировать (возвращает название статьи через ее метод)
    title
  end
end

# Добавим новый тест в /spec/models/article_spec.rb
require 'rails_helper'

describe Article do
  # ...какието describe/it

  describe "#subject" do
    it "returns the article title" do
      article = create(:article, title: 'Foo Bar') # создаем объект/сущность Article, но не с помощью AR, а при помощи фабрики
      # create   - статический метод factory_bot для создания сущности
      # :article - имя фабрики/модели

      expect(article.subject).to eq 'Foo Bar' # проверяем что метод subject возвращает указанное значение title сущности
    end
  end
end
# > rake spec



puts '                                   Фабрика для модели с belongs_to'

# В фабрику для модели с ассоциацией belongs_to нужно добавить ассоциацию с соответсвующей фабрикой, у модели которой есть ассоциация has_many, иначе вылезет ошибка (например "User must exist")

# Модель Post
class Post < ApplicationRecord
  belongs_to :user, optional: true, required: true
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
    # Вариант 1 (? тоже самое только сокращенный ?)
    user # колонка для создания юзера полученного от фабрики :user или ассоциации с фабрикой :user ??
    # Вариант 2 (? тоже самое только полный ?)
    association :user
  end
end

# Тест post_spec.rb
require 'rails_helper'
describe Post do
  # ...
  describe "#columns" do
    it "returns the post content" do
      user = create :user                                  # создаем юзера фабрикой :user
      post = create(:post, content: 'a' * 100, user: user) # привязываем пост к юзеру
      expect(post.content).to eq 'a' * 100
    end
  end
end
# > rspec



puts '                               Фабрика для модели с polymorphic ассоциацией'

# Такой же как прошлый (используем фабрики из него), только для полиморфно ассоциированного комментария(к постам и картинкам и одновременно 1 ту мэни к юзерам)

# Модель Comment
class Comment < ApplicationRecord
  belongs_to :user, optional: true, required: true
  belongs_to :commentable, polymorphic: true
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
      # :create   - метод(в тесте) после которого сработает after. Те после создания article в тесте
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
      expect(article.last_comment.body).to eq "Comment body 3" # проверка: проверяем значение поля боди последнего коммента(тк у нас их 3 то и в значении будет 3)
    end
  end
end
# > rake spec















#
