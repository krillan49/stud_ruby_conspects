puts '                                          Rspec для Rails'

# Установка и настройка гемов

# 1. Gemfile для окружений test и development:
group :test, :development do
  gem 'rspec-rails'
  gem 'shoulda-matchers'     # добавляет матчеры для проверки моделей
end
# > bundle install

# (! Из комментов, не пользовался)Для рельсов 6.1 в Gemfile нужен gem 'rexml'
# stackoverflow.com/questions/65479863/rails-6-1-ruby-3-0-0-tests-error-as-they-cannot-load-rexml


# 2. Настройка Rspec для Rails:
# > rails g rspec:install  - этот генератор(среди прочих, добавился при установке gem 'rspec-rails') запускает гем и выполняет его установку в наше приложение(установит дополнительные каталоги и хэлперы). Создались:
  # .rspec                 - содержит опции/настройки(например для цветового вывода)
  # spec                   - Директория для rspec тестов и других фаилов
  # spec/spec_helper.rb
  # spec/rails_helper.rb

# (! У меня не возникла)(Проблема из комментов: когда прописал команду rails g rspec:install после стоит на месте, нужно прервать и написать так DISABLE_SPRING=true rails generate rspec:install)


# 3. Настроим Shoulda-matchers, добавив в spec_helper.rb или rails_helper.rb(я добавил в rails_helper.rb):
RSpec.configure do |config|
  # всякие конфигурации ...

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

end


# 4. Тк тестовая БД(если ее используем) по умолчанию не содержит миграций, нужно их произвести чтобы не было ошибок
# > rails db:migrate RAILS_ENV=test



puts '                              Тестирование моделей(Матчеры shoulda-matchers)'

# Создадим для тестирования моделей каталог /spec/models. В нем будем создавать фаилы для тестирования моделей

# Матчеры shoulda-matchers для проверки моделей(работает как для rspec так и для обычных юнит тестов):
# http://matchers.shoulda.io/docs/v3.1.3/
# https://github.com/thoughtbot/shoulda-matchers

# Модель, которую будем тестировать (/app/models/contact.rb):
class Contact < ApplicationRecord
  validates :email, presence: true
  validates :message, presence: true
end

# Создадим тест для модели: создать файл /spec/models/contact_spec.rb
require 'rails_helper' # подключаем фаил spec/rails_helper.rb
# Далее синтакс rspec
describe Contact do
  it { should validate_presence_of :email } # validate_presence_of - матчер проверяющий присутсвие email(тестируем валидацию)
  it { should validate_presence_of :message }
end
# > rake spec     # запускаем rspec через rake, но можно и обычным способом (нужны миграции тестовой БД)


# Использование других матчеров для тестирования моделей(длинны введенных данных и ассоциаций принадлежности):
# http://matchers.shoulda.io/docs/v3.1.3/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method       have_many
# https://matchers.shoulda.io/docs/v5.3.0/Shoulda/Matchers/ActiveModel.html#validate_length_of-instance_method   validate_length_of

# модель /app/models/article.rb которую будем тестировать
class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 140 } # Добавим валидацию длинны
  validates :text, presence: true, length: { maximum: 4000 }
  has_many :comments
end

# модель /app/models/comment.rb которую будем тестировать
class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 4000 } # Добавим валидацию длинны
  belongs_to :article
end

# Создадим тест /spec/models/article_spec.rb:
require 'rails_helper'
describe Article do
  # Проверим длинну
  describe "validations" do
    it { should validate_length_of(:title).is_at_most(140) } # is_at_most(140) - не больше чем 140
    it { should validate_length_of(:text).is_at_most(4000) }
  end

  # Проверим ассоциавции принадлежности при помощи матчера have_many
  describe "assotiations" do  # сущность Article должна иметь много комментов
    it { should have_many :comments } # have а не has ииза правил английского тк есть should
  end
end

# Создадим тест /spec/models/comment_spec.rb
require 'rails_helper'
describe Comment do
  describe "validations" do
    it { should validate_length_of(:body).is_at_most(4000) }
  end

  # Проверим ассоциавции принадлежности при помощи матчера belong_to
  describe "assotiations" do  # сущность Comment должа принадлежать статье
    it { should belong_to :article } # в матчере belong хотя в модели belongs
  end
end


# Другие матчеры валидации длинны:
should validate_length_of(:bio).is_at_least(15) # не менее чем
should validate_length_of(:favorite_superhero).is_equal_to(6) # равен значению
should validate_length_of(:password).is_at_least(5).is_at_most(30) # одновременно меньше и больше чем

# Матчер чтобы проверить существование объекта AR
expect(Foo.where(bar: 1, bax: 2)).to exist



puts '                                 Баг тестирования belong_to к Devise модели'

# По умолчанию, если User это модель Devise, возникает ошибка при тестировании ассоциации /spec/models/comment_spec.rb
require 'rails_helper'

describe Comment do
  it { should belong_to :user }
end

# > rake spec
# => Failure/Error: it { should belong_to :user }

# Для исправления в модели нужно добавить:
class Comment < ApplicationRecord
  belongs_to :user, optional: true, required: true
  # optional: true  - если это не добавить то при использовании Rails 5.1 и выше создание нового коммента и тесты этого свойства выдадут ошибку "User must exist"
  # required: true  - если не добавить возникнут ошибки с rspec тестирыванием этой ассоциации
end



puts '                                      Factory Bot. Настройка'

# Factory Bot - помогает при тестировании, чтобы не создавать в AR объекты для теста и тестовую БД, вместо этого создаётся фабрика, и она будет создавать нам объекты для теста. Это соотв принципу DRY тк не нужно создавать тестовую БД

# ?? Создается в БД просто данные после теста затираются ??

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
# support - специальная папка для rspec откуда он подтягивает нужную фигню
# и обязательно подключить этот файл(support/factory_bot.rb) в фаиле rails_helper.rb
require 'support/factory_bot'



puts '                                      Factory Bot. Создание фабрики'

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

# Напишем тест с использованием созданной фабрики:

# Добавим метод в models/article.rb
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
      article = create(:article, title: 'Foo Bar') # создаем объект/сущность Article но не с помощью AR, а при помощи фабрики
      # create   - метод factory_bot для создания сущности
      # :article - имя фабрики

      expect(article.subject).to eq 'Foo Bar' # проверяем что метод subject возвращает указанное значение title сущности
    end
  end
end
# > rake spec
# (!!!Для Windows - нужно запускать в классической командной строке, в повершелл тесты будут выполняться 2 раза: по полному адресу и относительному, что может привести к ошибкам в некоторых тестах)


puts
# Пример на blog2 (с синтаксисом как выше была ошибка "User must exist" хотя стояло optional: true, ииза того что юзер не создан, тоже самое будет у коммента, для commentable итд)

# Модель Post
class Post < ApplicationRecord
  belongs_to :user, optional: true, required: true
  has_many :comments, as: :commentable
  validates :content, presence: true, length: { in: 100..5000 }
end
# Модель User
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :posts
  # ...
end

# Фабрика users.rb
FactoryBot.define do
  factory :user do
    email { "user@mail.ru" } # либо sequence(:email) { |n| "user#{n}@mail.ru" }
    username { "username" }  # либо sequence(:username) { |n| "username#{n}" }
    password { "123456" }    # почемуто password, хотя колонка называется encrypted_password
  end
end
# Фабрика posts.rb
FactoryBot.define do
  factory :post do
    content { "Post content" }
    # Вариант 1 (? тоже самое только сокращенный ?)
    user # колонка для создания юзера полученного от фабрики :user ??
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
      user = create :user # создаем юзера фабрикой :user
      post = create(:post, content: 'a' * 100, user: user) # привязываем пост к юзеру
      expect(post.content).to eq 'a' * 100
    end
  end
end
# > rake spec


post
# Такой же как прошлый только для полиморфно ассоциированного комментария(к постам и картинкам и одновременно 1 ту мэни к юзерам)

# Модель Comment
class Comment < ApplicationRecord
  belongs_to :user, optional: true, required: true
  belongs_to :commentable, polymorphic: true
  validates :body, presence: true
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
      post = create(:post, content: 'a' * 100, user: user) # создаем пост тк ему тоже принадлежит как комментайбл
      comment = create(:comment, body: 'aaa', commentable: post, user: user) # тут добавляем пост в commentable
      expect(comment.body).to eq 'aaa'
    end
  end
end
# > rake spec


puts
# Пример посложнее:

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
      after :create do |article, evaluator| # after - метод срабатывающий после чего либо. :create - метод(в тесте) после которого сработает after. Те после создания article в тесте. (evaluator - не обязательно)
        create_list :comment, 3, article: article # создаём список из 3-х комментариев(:comment из фабрики комментариев ??)
        # article: article - указываем тк в модели у нас коммент принадлежит статье, параметр статья созданная в тесте
      end
      # Те после создания article создаём список из 3-х комментариев
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



puts '                        Acceptance Testing(Приёмочное тестирование). Gem Capybara'

# УЗНАТЬ:
# 1. Как копировать все данные в тестовую БД
# 2. Как использовать маршруты для show в тестах? (мб просто хэлперы не подключены в фаилы тестов)
# visit '/posts/1'               - такие работают
# visit post_path('1')           - такие нет ActionController::UrlGenerationError
# visit post_path(Post.all.last) - такие нет ActionController::UrlGenerationError


# Acceptance Testing - Проверка функциональности на соответствие требованиям. Отличие от юнит-тестов, что для этих тестов обычно существует план приёмочных работ(список требований и выполняются эти требования или нет). А юнит-тесты - проверка чтобы не сломалось. Обычно unit и acceptance используются вместе в проектах
# http://protesting.ru/testing/levels/acceptance.html


# Capybara - гем запускает движок браузера, посещает страницы, заполняет поля, потом тесты проверяют это
# Капибара работает с тестовой БД, по умолчанию с test.sqlite3

# https://www.rubydoc.info/github/teamcapybara/capybara/master          - Capybara
# https://github.com/teamcapybara/capybara
# https://github.com/teamcapybara/capybara#using-capybara-with-rspec    - Using Capybara with RSpec

# Gemfile
group :test do
  gem 'capybara'
end

# Для настройки Capybara согласно документации нужно добавить в файл rails_helper(rspec_helper для старых версий):
require 'capybara/rspec'
# хотя работает и без этого



puts '                                        Capybara синтаксис'

# https://gist.github.com/steveclarke/2353100      - матчеры для веба(проверять элементы штмл и ксс)

# unit:         describe   ->   it
# acceptance:   feature    ->   scenario

# 'feature -> scenario' - это фишка Capybara аналог 'describe -> it'.
# feature - особенность(имеется ввиду какаято функциональность)
# scenario - сценарий(способ использования функциональности)

# Пример: Для контактной формы существует 2 сценария:
# а. Убедиться, что контактная форма существует.
# б. Что мы можем эту форму заполнить и отправить

# 2 типа нэйминга тестов(для удобства):
# visitor_..._spec.rb - анонимный пользователь
# user_..._spec.rb - пользователь залогиненый в системе


# /spec/features - каталог для приемочных тестов

# Создадим файл теста создания контактов /spec/features/visitor_creates_contact_spec.rb:
require "rails_helper"
# Далее синтаксис как раньше, только вместо describe->it будет feature->scenario
feature "Contact creation" do
  scenario "allows acess to contacts page" do # будем проверять наличие доступа к странице
    visit new_contacts_path # get 'contacts/new' (можно прописать URL и вручную)
    # Капибара заходит на указанную страницу(указывать обязательно, даже если это корневая)

    expect(page).to have_content 'Contact us' # проверяем, что страница имеет какую-то строку(учитывает регистр)
    # page - переменная содержащая страницу(полностью сгенерированную вместе с layout)
  end

  # Вариант с i18n (тот же тест что и выше).
  scenario "allows acess to contacts page" do
    visit new_contacts_path
    expect(page).to have_content I18n.t('contacts.contact_us') # всегда нужно указывать полный путь каталогов, если сократить как в предсталениях, например t('.contact_us'), то выдаст ошибку
  end
end
# > rake spec



puts '                                     Capybara: fill_in и click_button'

#  Протестируем создание нового контакта:

# Откроем страницу /app/views/contacts/new.html.erb и откроем код формы, чтобы узнать id поля (будем использовать в тесте):
# <input name="contact[email]" id="contact_email" type="text">
# <textarea name="contact[message]" id="contact_message"></textarea>

# Наш файл с тестом features/visitor_creates_contact_spec.rb:
require "rails_helper"

feature "Contact creation" do
  scenario "allows a guest to create contact" do
    visit new_contacts_path
    fill_in :contact_email, with: 'foo@bar.ru'
    # fill_in            - метод для того чтобы Капибара заполнила поле
    # :contact_email     - значение id поля
    # with: 'foo@bar.ru' - то что будет записано в поле
    fill_in :contact_message, with: 'Foo Bar Baz'
    click_button 'Send message'
    # click_button   - метод Капибары дня нажатия на кнопку
    # 'Send message' - значение кнопки

    expect(page).to have_content 'Contacts create' # Проверяем страницу которая вернется после создания коммента(create.html.erb)
  end
end



puts '                               Capybara: тесты с регистрацией и логином'

# 1. Сделаем сначала тест для гостя, проверяющий, что он может зарегистрироваться на сайте(протестируем форму регистрации)

# /spec/features/visitor_creates_account_spec.rb
require "rails_helper"

feature "Account Creation" do
  scenario "allows guest to create account" do
    visit new_user_registration_path # хэлпер пути к виду регистрации из карты маршрутов devise
    fill_in :user_username, with: 'FooBar'
    fill_in :user_email, with: 'foo@bar.com'
    fill_in :user_password, with: '1234567'
    fill_in :user_password_confirmation, with: '1234567'
    click_button 'Sign up'

    expect(page).to have_content I18n.t('devise.registrations.signed_up')
  end
end
# > rake spec


# 2. Чтобы не зависеть от порядка исполнения тестов и не повоторяться в коде, вынесем часть кода, которая будет использоваться во многих тестах, в метод sign_up

# /spec/features/visitor_creates_account_spec.rb:
require "rails_helper"

feature "Account Creation" do
  scenario "allows guest to create account" do
    sign_up
    expect(page).to have_content I18n.t('devise.registrations.signed_up')
  end
end

def sign_up
  visit new_user_registration_path
  fill_in :user_username, with: 'FooBar'
  fill_in :user_email, with: 'foo@bar.com'
  fill_in :user_password, with: '1234567'
  fill_in :user_password_confirmation, with: '1234567'
  click_button 'Sign up'
end
# Далее вынесем код метода sign_up в отдельный файл хэлпера /spec/support/session_helper.rb

# Далее либо в rails_helper.rb требуем этот файл
require 'support/session_helper'
# Либо в файле rails_helper.rb раскомментируем этот закоментированный код:
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
# Так каждый раз вписывать наши новые вспомогательные файлы из support не надо будет. Они будут вписываться автоматически


# 3. Тест для просмотра формы и создания статьи и создание статьи залогиненым пользователем

# /spec/features/user_creates_article_spec.rb:
require "rails_helper"

feature "Article Creation" do
  # Нам надо использовать sign_up в разных тестах, и чтобы не повторяться, мы используем before hook:
  before(:each) do
    sign_up # регистрируем нового пользователя перед вызовом кажого сценария
  end

  scenario "allows user to visit new article page" do
    visit new_article_path
    expect(page).to have_content 'New article'
  end

  scenario "allows user to create new article" do
    create_article # наш хэлпер
    expect(page).to have_content I18n.t('articles.show.new_comment') # или что там в articles/show
  end
end

# хэлпер support/article_helper.rb
def create_article
  visit new_article_path
  fill_in :article_title, with: 'Test article'
  fill_in :article_text, with: 'Some text'
  click_button 'Save Article'
end

# > rake spec


# 4. Тест для посещения страницы редактирования статьи и собственно редактирование статьи юзером user_updates_article_spec.rb
require "rails_helper"

feature "Article Edition" do
  before(:each) do
    sign_up
    create_article
  end

  scenario "allows user to visit edit article page" do
    visit articles_path # get 'articles'
    click_link('Edit article') # нажимаем на ссылку по ее названию
    expect(page).to have_content I18n.t('articles.edit.header') # articles/edit.html.erb
  end

  scenario "allows user to update article" do
    visit articles_path
    click_link('Edit article')
    fill_in :article_title, with: 'Test article2' # редактируем статью
    fill_in :article_text, with: 'Some text2'
    click_button 'Save Article'
    expect(page).to have_content I18n.t('articles.show.new_comment') # articles/show.html.erb
  end
end


# 5. Тест для создания комментариев
require "rails_helper"

feature "Comment Creation" do
  before(:each) do
    sign_up
    create_article
  end

  scenario "allows user to create comment" do
    fill_in :comment_body, with: 'Test comment'
    click_button 'Create Comment'
    expect(page).to have_content 'Test comment' # проверяем по содержанию самого коммента
  end
end



puts '                                         Capybara + Factory Bot'

# На примере того что кнопки редактирования и удаления подкаста может увидить только зарегистрированный пользователь, нужно создать этого пользователя через фабрику и потом им зарегаться

# spec/factories/users.rb:
FactoryBot.define do
  factory :user do
    sequence(:email_address)  { |n| "#{n}@google.com" }
    password                  { "my password" }
  end
end

# spec/factories/podcasts.rb:
FactoryBot.define do
  factory :podcast do
    sequence(:title)  { |n| "My Podcast #{n}" }
    description       { "This is a description of my podcast." }
    user
  end
end

# spec/support/session_helper.rb:
def sign_in
  visit login_path
  fill_in "email_address", with: user.email_address
  fill_in "password",      with: user.password
  click_button "Sign in"
end

# spec/features/podcasts/show_spec.rb:
require 'rails_helper'

RSpec.feature "Podcasts#show", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:podcast) do
    FactoryBot.create(:podcast, title: Faker::Alphanumeric.alpha(number: 10),
                                description: Faker::Markdown.emphasis,
                                user: user)
  end

  before do
    sign_in # както использует переменную user из let
    visit podcast_path(podcast)
  end

  context 'user see' do
    scenario "podcast details" do
      expect(page).to have_content(podcast.title)
      expect(page).to have_content(podcast.description)
      expect(page).to have_content(podcast.created_at)
    end

    scenario "special notice cuz no photo" do
      expect(page).to have_selector("div.alert.alert-warning", text: "No Photo Available!")
      expect(page).to have_selector("div.alert.alert-warning", text: "No Audio Available!")
    end

    # Этот тест пройдет только зареганный юзер, для него и делаем юзера фабрикой
    scenario "manipulation buttons" do
      expect(page).to have_link("Редактировать Podcast", href: edit_podcast_path(podcast))
      expect(page).to have_button("Удалить Podcast")
    end
  end
end



puts '                                         database_cleaner(устарело?)'

# (!!! Нифига не работает как и подсказки из уроков)

# Если в предыдущем тесте написать before(:all) вместо before(:each) то появится ошибка в тесте visitor_creates_account_spec.rb, тк он запустился позже этого и там мы тоже использовали хэлпер sign_up, соотв имэил для регистрации был уже использован, а БД не была очищена

# database_cleaner - гем для rspec и capibara, который очищает БД перед каждым тестом
# https://github.com/teamcapybara/capybara#transactions-and-database-setup
# https://github.com/DatabaseCleaner/database_cleaner#rspec-example

# Добавить в Gemfile:
group :test do
  # ...
  gem 'database_cleaner'
end

# Создадим файл конфигурации database_cleaner в файле /spec/support/database_cleaner.rb:
RSpec.configure do |config| # хэлпер конфигурирует/настраивает rspec
  config.before(:suite) do # перед запуском всего устанавливаются опции клинера
    DatabaseCleaner.strategy = :transaction # стратегия транзакция(очищаем БД при помощи ролбека)
    DatabaseCleaner.clean_with(:truncation) # очистка БД способом truncate(альтернатива delete)
  end

  config.around(:each) do |example| # будем очищать для каждого теста
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

# Потом в rails_helper.rb требуем этот файл то есть пишем - require 'support/database_cleaner', либо раскомментируем автоматическое добавление



















#
