puts '                                          Rspec для Rails'

# Установка и настройка гемов

# 1. Добавить в Gemfile нашего Rails-приложения:
group :test, :development do # добавим гемы только для 2х типов окружения(test, development)
  gem 'rspec-rails'
  gem 'shoulda-matchers'   # добавляет матчеры для проверки моделей(работает как для rspec так и для обычных юнит тестов)   http://matchers.shoulda.io/docs/v3.1.3/    https://github.com/thoughtbot/shoulda-matchers
  gem 'capybara'
end
# > bundle install

# (! Из комментов, не пользовался)Для рельсов 6.1 в Gemfile нужен gem 'rexml'
# stackoverflow.com/questions/65479863/rails-6-1-ruby-3-0-0-tests-error-as-they-cannot-load-rexml

# 2. Настройка Rspec для Rails:
# > rails g rspec:install   # (этот генератор, среди прочих, добавился при установке gem 'rspec-rails') запускает гем и выполняет его установку в наше приложение(установит дополнительные каталоги и хэлперы)
  # Создались:
  # .rspec                 - содержит опции/настройки(например для цветового вывода)
  # spec                   - Директория для rspec тестов и других фаилов
  # spec/spec_helper.rb
  # spec/rails_helper.rb
#      (У меня не возникла)(Проблема из комментов: когда прописал команду rails g rspec:install после стоит на месте, нужно прервать и написать так DISABLE_SPRING=true rails generate rspec:install)

# 3. Настроим Shoulda-matchers, добавив в spec/rails_helper.rb(добавил в rails_helper.rb):
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# 4. Тк тестовая БД(если ее используем) по умолчанию не содержит миграций, нужно их произвести чтобы не было ошибок
# > rails db:migrate RAILS_ENV=test


puts
puts '                                      Rspec Тестирование моделей'

# Создадим для тестирования моделей каталог /spec/models. В нем будем создавать фаилы для тестирования моделей
# матчеры для проверки моделей(работает как для rspec так и для обычных юнит тестов) http://matchers.shoulda.io/docs/v3.1.3/    https://github.com/thoughtbot/shoulda-matchers

# Модель, которую будем тестировать (/app/models/contact.rb):
class Contact < ApplicationRecord
  validates :email, presence: true
  validates :message, presence: true
end

# Создадим тест для модели: создать файл /spec/models/contact_spec.rb
require 'rails_helper' # подключаем фаил spec/rails_helper.rb
# Далее синтакс rspec(но тут почемуто без названий тестов)
describe Contact do
  it { should validate_presence_of :email } # должно проверять присутсвие email(тестируем валидацию)
  # validate_presence_of - матчер
  it { should validate_presence_of :message }
end

# > rake spec     # запускаем rspec через rake, но можно и обычным способом
# (! Возникает ошибка тк по умолчанию тестовая БД не содержит миграций) перенесем в нее миграции при помощи команды:
# > rails db:migrate RAILS_ENV=test


# Используем матчер have_many http://matchers.shoulda.io/docs/v3.1.3/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method

# Создадим тест /spec/models/article_spec.rb:
require 'rails_helper'
describe Article do # сущность Article должа иметь много комментов
  it { should have_many :comments } # have а не has ииза правил английского тк есть should
end

# Создадим тест /spec/models/comment_spec.rb
require 'rails_helper'
describe Comment do
  it { should belong_to :article } # в матчере belong хотя в модели belongs
end


puts
puts '                                    Rspec Вложенный describe'

# Вложенный describe - повышает читаемость кода тестов

# модель article.rb которую будем тестировать
class Article < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true
  has_many :comments
end

# /spec/models/article_spec.rb:
require 'rails_helper'

describe Article do
  # разбиваем на логически обоснованные разделы
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :text }
  end

  describe "assotiations" do
    it { should have_many :comments }
  end
end

# Нэйминг(желательный) после describe - помогает прогам считать какое коллич кода покрыто тестами
# НЕ методы:                     describe "something" do
# instance методы:               describe "#method_name" do
# class методы (self.method):    describe ".method_name" do


puts
# Еще примеры тестов из ДЗ46(на валидацию макс длинны полей при помощи матчера validate_length_of)
# https://matchers.shoulda.io/docs/v5.3.0/Shoulda/Matchers/ActiveModel.html#validate_length_of-instance_method

# Добавим валидацию длинны в модели /app/models/article.rb и /app/models/comment.rb
class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 140 }
  validates :text, presence: true, length: { maximum: 4000 }
  # ...
end
class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 4000 }
  # ...
end

# В /spec/models/article_spec.rb и /spec/models/comment_spec.rb добавим
describe Article do
  # ... предыдущие тесты ...
  describe "validations" do
    # ... предыдущие тесты валидации ...
    it { should validate_length_of(:title).is_at_most(140) } # is_at_most(140) - не больше чем 140
    it { should validate_length_of(:text).is_at_most(4000) }
  end
end
describe Comment do
  # ... предыдущие тесты ...
  describe "validations" do
    it { should validate_length_of(:body).is_at_most(4000) }
  end
end


puts
puts '                                             Factory Bot'

# Factory Bot - помогает при тестировании, чтобы не создавать в AR объекты для теста и тестовую БД, вместо этого создаётся фабрика, и она будет создавать нам объекты для теста. Это соотв принципу DRY тк не нужно создавать тестовую БД
# Раньше был другой гем gem Factory Girl(устарел)
# https://github.com/thoughtbot/factory_bot/blob/v4.9.0/UPGRADE_FROM_FACTORY_GIRL.md
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md


# Установка для Рэилс(Для Рэилс и без него разные подгемы и разная настройка):
# Добавить в Gemfile:
group :development, :test do
  # ... предыдущие гемы
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


puts
# Создание фабрики:
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Defining_factories

# Создадим каталог с фабриками - /spec/factories

# создадим файл в котором будем создавать фабрику для article /spec/factories/articles.rb:
FactoryBot.define do # определяем фабрику
  factory :article do # фабрика article. По умолчанию будет брать модель Article и устанавливать в нее свойсва:
    # Зададим свойства и их значения, тк наши тесты будут проверять их валидацию и без них выдадут ошибки валидации
    title { "Article title" } # содержание параметра не важно можно любое
    text { "Article text" }
  end
end
# Теперь наша фабрика может создатЬ сущность Article с полями title и text


puts
# Напишем тест с использованием созданной фабрики:

# Добавим метод в /app/models/article.rb
class Article < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true
  has_many :comments

  def subject # добавим метод который будем тестировать (возвращает название статьи ??)(Не забываем что это метод экземпляра)
    title
  end
end

# Добавим новый тест в /spec/models/article_spec.rb
require 'rails_helper'

describe Article do
  # ...какието describe/it

  describe "#subject" do
    it "returns the article title" do
      # arrange + act
      article = create(:article, title: 'Foo Bar') # создаем объект/сущность Article но не с помощью AR, а при помощи фабрики
      # create - метод factory_bot для создания сущности
      # :article - имя фабрики ??

      # assert
      expect(article.subject).to eq 'Foo Bar' # проверяем что метод subject возвращает указанное значение title сущности
    end
  end
end
# > rake spec
# (!!!Для Windows - нужно запускать в классической командной строке, в повершелл тесты будут выполняться 2 раза: по полному адресу и относительному, что может привести к ошибкам в некоторых тестах)


puts
# Пример посложнее:

# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Sequences    # Sequences (последовательности):
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md    # create_list (через поиск по странице):

# Добавим метод в модель /app/models/article.rb
class Article < ApplicationRecord
  # ... пред код ....

  # Создадим метод last_comment и протестируем его:
  def last_comment # метод возврата последнего комментария(помним что это метод экземпляра а экземпляр это сущность статьи)
    comments.last # последний комментарий из колекции комментов этой статьи, тк comments, тоже похоже метод экземпляра, возвращающий массив комментариев
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
        create_list :comment, 3, article: article # создаём список из 3-х сущностей комментариев(:comment из фабрики комментариев ??)
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


puts
puts '                        Приёмочное тестирование(Acceptance Testing). Gem Capybara'

# Проверка функциональности на соответствие требованиям. Отличие от юнит-тестов, что для этих тестов обычно существует план приёмочных работ(список требований и выполняются эти требования или нет). Юнит-тесты - проверка чтобы не сломалось.
# http://protesting.ru/testing/levels/acceptance.html

# Обычно unit и acceptance используются вместе в проектах

# unit:         describe   ->   it
# acceptance:   feature    ->   scenario

# feature -> scenario - это фишка Capybara аналог, describe it.
# feature - особенность(имеется ввиду какаято функциональность)
# scenario - сценарий(способ использования функциональности)
#   Пример: Для контактной формы существует 2 сценария:
#     а. Убедиться, что контактная форма существует.
#     б. Что мы можем эту форму заполнить и отправить

# https://www.rubydoc.info/github/teamcapybara/capybara/master    #Capybara
# https://github.com/teamcapybara/capybara
group :test do # уже поставлено ранее
  gem 'capybara'
end

# https://github.com/teamcapybara/capybara#using-capybara-with-rspec    # Using Capybara with RSpec

# Для настройки Capybara согласно документации нужно добавить в файл rails_helper(rspec_helper для старых версий) строчку, хотя работает и без этой строки.
require 'capybara/rspec'

# Как работает гем Капибара - запускает движок браузера, посещает страницы, заполняет поля, потом тесты проверяют это

# 2 типа тестов(просто удобный нэйминг):
# visitor_..._spec.rb - анонимный пользователь
# user_..._spec.rb - пользователь залогиненый в системе


puts
# Проведём тестирование контактной формы контактов.

# Создадим каталог /spec/features и создадим файл /spec/features/visitor_creates_contact_spec.rb:
require "rails_helper"
# Далее синтаксис как раньше только вместо describe->it будет feature->scenario
feature "Contact creation" do
  scenario "allows acess to contacts page" do # будем проверять наличие доступа к странице
    visit new_contacts_path # get 'contacts/new' (можно прописать URL и вручную)
    # Капибара заходит на указанную страницу

    expect(page).to have_content 'Contact us' # проверяем что страница имеет какуюто строку(учитывает регистр)
    # page - переменная содержащая страницу(полностью сгенерированную вместе с layout)
  end
end
# > rake spec   (!!!Для Windows - нужно запускать в классической командной строке, в повершелл будет ошибка)


puts
puts '                                            Rspec + i18n'

# Работа с i18n (internationalization):

# 1. Открыть файл /config/locales/en.yml (в нем есть небольшая кокументация по использованию)
# 2. Создадим в фаиле /config/locales/en.yml раздел contacts:
# 3. Вызовем в представлении /app/views/contacts/new.html.erb: <h2><%= t('contacts.contact_us') %></h2>


puts
# Применение i18n в Capybara: Исправим последний тест с учётом i18n файл /spec/features/visitor_creates_contact_spec.rb:
require "rails_helper"

feature "Contact creation" do
  scenario "allows acess to contacts page" do
    visit new_contacts_path

    expect(page).to have_content I18n.t('contacts.contact_us')
  end
end
# > rake spec
# Теперь мы точно обращаемся к правильной строке вместо того чтоб смотреть что в ней там написано с каким регистом итд


# Добавим создание самого контакта:
# Откроем страницу /app/views/contacts/new.html.erb и откроем код формы, чтобы узнать id поля (будем использовать в тесте):
# <input name="contact[email]" id="contact_email" type="text">
# <textarea name="contact[message]" id="contact_message"></textarea>

# Наш файл с тестом features/visitor_creates_contact_spec.rb:
require "rails_helper"

feature "Contact creation" do
  scenario "allows acess to contacts page" do
    visit new_contacts_path
    expect(page).to have_content I18n.t('contacts.contact_us')
  end

  scenario "allows a guest to create contact" do
    visit new_contacts_path
    fill_in :contact_email, with: 'foo@bar.ru' # fill_in - метод для того чтобы Капибара заполнила поле; :contact_email - значение id поля; with: 'foo@bar.ru' - то что будет записано в поле
    fill_in :contact_message, with: 'Foo Bar Baz'
    click_button 'Send message' # click_button - Капибара нажмет на кнопку с именем 'Send message'

    expect(page).to have_content 'Contacts create' # Проверяем страницу которая вернется после создания коммента(create.html.erb)
  end
end


puts
# Следующий тест: протестировать функциональность приложения залогинившись под пользователем

# 1. Сделаем сначала тест для гостя, что он может зарегистрироваться на сайте, т.е. протестируем форму регистрации.

# Создадим файл /spec/features/visitor_creates_account_spec.rb
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
    # devise.registrations.signed_up  i18n взято из config/locales/devise.en.yml (заодно пример структуры)
  end
end
# > rake spec
# Всё это работает с базой данных test.sqlite3


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
# Далее вынесем код метода sign_up в файл в каталоге /spec/support/session_helper.rb

# Далее либо в rails_helper.rb требуем этот файл
require 'support/session_helper'

# Либо в файле rails_helper.rb раскомментируем этот закоментированный код:
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
# Так каждый раз вписывать наши новые вспомогательные файлы из support не надо будет. Они будут вписываться автоматически


puts
# RSpec: before, after hooks
# https://relishapp.com/rspec/rspec-core/v/3-8/docs/hooks/before-and-after-hooks

# Нам надо использовать sign_up в разных тестах, и чтобы не повторяться и не писать один и тот же код, мы используем before, after hooks:
before(:each) do # Исполняется перед каждым тестом в feature или describe
end
before(:all) do # Исполняется перед всеми(1 раз перед всеми) тестами в feature или describe
end


# 3. Тест для просмотра формы и создания статьи и создание статьи залогиненым пользователем /spec/features/user_creates_article_spec.rb:
require "rails_helper"

feature "Article Creation" do
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


puts
# Тест для посещения страныцы редактирования статьи и собственно редактирование статьи юзером user_updates_article_spec.rb
require "rails_helper"

feature "Article Creation" do
  before(:each) do
    sign_up
    create_article # создаем статью(хэлпер выше)
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


puts
# тест для создания комментариев
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


puts
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
