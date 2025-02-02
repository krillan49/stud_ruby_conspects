puts '                            Acceptance Testing(Приёмочное тестирование)'

# http://protesting.ru/testing/levels/acceptance.html

# Acceptance Testing / Приёмочное тестирование - проверка функциональности на соответствие требованиям. Отличие от юнит-тестов, что для этих тестов обычно существует план приёмочных работ(список требований и выполняются эти требования или нет). А юнит-тесты - проверка чтобы не сломалось. Обычно unit и acceptance используются вместе в проектах



puts '                                            Capybara'

# УЗНАТЬ:
# 1. Как копировать все данные в тестовую БД
# 2. Как использовать маршруты для show в тестах? (мб просто хэлперы не подключены в фаилы тестов)
# visit '/posts/1'               - такие работают
# visit post_path('1')           - такие нет ActionController::UrlGenerationError
# visit post_path(Post.all.last) - такие нет ActionController::UrlGenerationError


# https://www.rubydoc.info/github/teamcapybara/capybara/master          - Capybara
# https://github.com/teamcapybara/capybara
# https://github.com/teamcapybara/capybara#using-capybara-with-rspec    - Using Capybara with RSpec

# Capybara - гем запускает движок браузера, посещает страницы, заполняет поля, потом тесты проверяют это

# Капибара работает с тестовой БД, по умолчанию с test.sqlite3


# Gemfile
group :test do
  gem 'capybara'
end

# Для настройки Capybara согласно документации нужно добавить в файл rails_helper(rspec_helper для старых версий):
require 'capybara/rspec'
# хотя работает и без этого



puts '                                         Capybara синтаксис'

# https://gist.github.com/steveclarke/2353100      - матчеры для веба(проверять элементы штмл и ксс)

# unit:         describe   ->   it
# acceptance:   feature    ->   scenario

# 'feature -> scenario' - это фишка Capybara аналог 'describe -> it'.
# feature  - особенность(имеется ввиду какаято функциональность)
# scenario - сценарий(способ использования функциональности)

# Пример: Для контактной формы существует 2 сценария:
# а. Убедиться, что контактная форма существует.
# б. Что мы можем эту форму заполнить и отправить

# Есть 2 типа нэйминга тестов для разных типов пользователей (для удобства):
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
# > rspec



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

# хэлпер support/article_helper.rb для теста
def create_article
  visit new_article_path
  fill_in :article_title, with: 'Test article'
  fill_in :article_text, with: 'Some text'
  click_button 'Save Article'
end

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
  fill_in "email_address", with: user.email_address # используем фбрику user через переменную из let
  fill_in "password",      with: user.password
  click_button "Sign in"
end

# spec/features/podcasts/show_spec.rb:
require 'rails_helper'

RSpec.feature "Podcasts#show", type: :feature do
  let(:user) { FactoryBot.create(:user) }   # используем фбрику user
  let(:podcast) do                          # используем фбрику podcast
    FactoryBot.create(:podcast, title: Faker::Alphanumeric.alpha(number: 10),
                                description: Faker::Markdown.emphasis,
                                user: user) # используем фбрику user
  end

  before do
    sign_in
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














#
