puts '                                          Minitest'

# Minitest - встроенная в Ruby библиотека для тестирования. В Rails она уже настроена по умолчанию и не требует дополнительных гемов


# Сравнение с RSpec:

# Тест модели RSpec:
describe User do
  it "is invalid without email" do
    expect(User.new(email: nil)).to_not be_valid
  end
end

# Тест модкли Minitest:
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "invalid without email" do
    user = User.new(email: nil)
    assert_not user.valid?
  end
end



puts '                                   Подготовка среды Minitest'

# Если Minitest не установлен или удален


# 1. Gemfile
group :test do
  gem 'minitest'
  gem 'minitest-rails'
  gem 'minitest-reporters'
end
# $ bundle install
# $ rails generate minitest:install


# 2. Настройка формата вывода и тестовую среду

# test/test_helper.rb
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new


# 3. Если используются генераторы scaffold/controller, нужно переключить тест-фреймворк на Minitest:

# config/application.rb
config.generators do |g|
  g.test_framework :minitest, spec: true, fixture: true
end



puts '                                  Файловая структура в Rails'

# Rails создает test-каталог, как только cоздаетcя проект Rails с помощью `bin/rails new application_name`, в котором находятся:

# * helpers/                        - тесты для хэлперов
# * mailers/                        - тесты для почтовых программ
# * models/                         - тесты для моделей 
# * controllers/                    - используется для тестов, связанных с контроллерами, маршрутами и представлениями, где будут моделироваться HTTP-запросы и делаться утверждения по результатам.
# * components/                     - по смыслу
# * integration/                    - тесты охватывающие взаимодействие между контроллерами
# * system/                         - системные тесты, которые используются для полного тестирования приложения в браузере (UI). Системные тесты позволяют тестировать приложение так, как его видят ваши пользователи, а также помогают тестировать JavaScript. Системные тесты наследуются от Capybara и выполняют внутрибраузерные тесты для приложения.
# * fixtures/                       - fixtures/фикстуры (если не используется FactoryBot) это способ создания макетов данных для использования в тестах, чтобы не приходилось использовать «реальные» данные
# * При первом создании задания jobs также будет создан каталог для ваших тестовых заданий

# * test_helper.rb                  - содержит конфигурацию по умолчанию для запуска тестов. Все методы, добавленные в этот файл, также доступны в тестах, когда этот файл подключен. Используется для подключения FactoryBot, очистки базы и других настроек
# * application_system_test_case.rb - конфигурация по умолчанию для system тестов, нужно ее подключить в системные тесты


# Мелкие короткие тесты легче читаются и изолируются.

# Для UI/system тестов стоит включить selenium_chrome_headless, если нужен реальный браузер

# переписанные feature-тесты с RSpec на Minitest с использованием Capybara::Minitest::Assertions, которые чаще всего используются вместе с rails/test_helper и ApplicationSystemTestCase

# Если используется Devise::Test::IntegrationHelpers или какие-либо кастомные хелперы, их тоже стоит подключить в ApplicationSystemTestCase.



puts '                                     Настройка FactoryBot'

# Если с тестами используется FactoryBot вместо fixtures, то его нужно настроить.

# Добавить в test/test_helper.rb:
class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end

# Теперь можно применять:
user = create(:user)

build_stubbed # используется так же, как и в RSpec, с FactoryBot


# Обычно при переходе с RSpec на Minitest переписывать фабрики FactoryBot не нужно, нужно просто убедиться, что они правильно подключены в окружении тестов.

# Но может понадобиться небольшая настройка если раньше использовался только RSpec.configure для подключения FactoryBot:
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
# Тогда тебе нужно добавить в test_helper.rb или minitest_helper.rb:
include FactoryBot::Syntax::Methods



puts '                                        Синтаксис теста'

# bin/rails generate model - команда помимо создания модели, создает тестовую заглушку в test каталоге:
# $ bin/rails generate model article title:string body:text
#=>
# create  app/models/article.rb
# create  test/models/article_test.rb

# Тестовая заглушка по умолчанию test/models/article_test.rb выглядит так:
require "test_helper"
# Вместо describe, context, it (как в RSpec) - просто class и test:
class ArticleTest < ActiveSupport::TestCase # это называется тестовым случаем, ArticleTest класс наследует от ActiveSupport::TestCase, соответсвенно имеет все методы из него. ActiveSupport::TestCase наследует от Minitest::Test

  # test - метод, добавленный Rails, который принимает имя теста и блок. Он генерирует стандартный Minitest::Unit тест с переданным именем с префиксом `test_`:
  test "the truth" do # имя метода генерируется путем замены пробелов на подчеркивания
    assert true # проверка называется «утверждение» она оценивает объект (или выражение) на предмет ожидаемых результатов. Каждый тест может содержать сколько угодно утверждений. Тест считается пройденным только в том случае, если все утверждения будут успешными
  end
  # Это примерно то же самое, что:
  def test_the_truth
    assert true
  end
  # Можно использовать оба синтаксиса определения методов

  test "price must be positive" do
    article = Article.new(price: -10)
    assert_not article.valid?
  end
end
# Любой метод, определенный в классе(унаследованном от Minitest::Test) с именем `test_чтото` (например test_password и test_valid_password) называется тестом и будет запущен автоматически при запуске тестового случая



puts '                                          Вывод тестов'

# .     - тест пройден успешно
# F     - ошибка (failure): assert не прошёл
# E     - ошибка (error): исключение/краш
# S     - пропущенный тест (skip)

# 12 runs, 24 assertions, 0 failures, 0 errors, 0 skips:
# 12 runs          - всего было 12 тестов (test методов)
# 24 assertions    - всего было 24 проверок (assert, refute, и т.п.)
# 0 failures       - 0 тестов упали, потому что assert не прошёл
# 0 errors         - 0 тестов крашнулись (например, NoMethodError или nil.cabinet)
# 0 skips          - ни один тест не был помечен как skip

# Выполнение каждого метода теста останавливается, как только обнаруживается ошибка или сбой утверждения и тестовый набор продолжается со следующим методом

# Все методы теста выполняются в случайном порядке. Опция `config.active_support.test_order` может использоваться для настройки порядка теста



puts '                                     Проваленый тест (Failure)'

# Статья не должна быть сохранена без соответствия определенным критериям (валидации), тоесть если статья пройдет то нет валидаций
require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "should not save article without title" do
    article = Article.new
    assert_not article.save
  end
end

# $ bin/rails test test/models/article_test.rb
#=>
# Running 1 tests in a single process (parallelization threshold is 50)
# Run options: --seed 44656
# # Running:
# F
# Failure:
# ArticleTest#test_should_not_save_article_without_title [/path/to/blog/test/models/article_test.rb:4]:
# Expected true to be nil or false
# bin/rails test test/models/article_test.rb:4
# Finished in 0.023918s, 41.8090 runs/s, 41.8090 assertions/s.
# 1 runs, 1 assertions, 1 failures, 0 errors, 0 skips

# F указывает на не прохождение теста. Раздел ниже Failure включает имя сбойного теста, за которым следует трассировка стека и сообщение, показывающее фактическое значение и ожидаемое значение из утверждения


# Каждое утверждение допускает необязательный параметр дополнительного сообщения, которое будет в выводе если тест не прошел:
test "should not save article without title" do
  article = Article.new
  assert_not article.save, "Saved the article without a title"
end
# $ bin/rails test test/models/article_test.rb
#=>
# Failure:
# ArticleTest#test_should_not_save_article_without_title [/path/to/blog/test/models/article_test.rb:6]:
# Saved the article without a title


# Для поля добавим проверку на уровне модели title. Теперь тест пройдет, так как статья в нем не была инициализирована с title, поэтому проверка модели предотвратит сохранение:
class Article < ApplicationRecord
  validates :title, presence: true
end
# $ bin/rails test test/models/article_test.rb:6
#=>
# Running 1 tests in a single process (parallelization threshold is 50)
# Run options: --seed 31252
# # Running:
# .
# Finished in 0.027476s, 36.3952 runs/s, 36.3952 assertions/s.
# 1 runs, 1 assertions, 0 failures, 0 errors, 0 skips

# .  - Зеленая точка на экране означает, что тест пройден успешно



puts '                          Сообщение об ошибках (Error). Утверждение для наличия ошибки'

# Тест, содержащий ошибку:
test "should report error" do
  some_undefined_variable # some_undefined_variable is not defined elsewhere in the test case
  assert true
end

# $ bin/rails test test/models/article_test.rb
#=>
# Running 2 tests in a single process (parallelization threshold is 50)
# Run options: --seed 1808
# # Running:
# E
# Error:
# ArticleTest#test_should_report_error:
# NameError: undefined local variable or method 'some_undefined_variable' for #<ArticleTest:0x007fee3aa71798>
#     test/models/article_test.rb:11:in 'block in <class:ArticleTest>'
# bin/rails test test/models/article_test.rb:9
# .
# Finished in 0.040609s, 49.2500 runs/s, 24.6250 assertions/s.
# 2 runs, 1 assertions, 0 failures, 1 errors, 0 skips


# Чтобы этот тест прошел, можно изменить его с добавлением assert_raises (чтобы теперь проверялось наличие ошибки)
test "should report error" do
  assert_raises(NameError) do
    some_undefined_variable
  end
end



puts '                                   skip (Заглушка/пропущенный тест)'

# skip - помечает тест как пропущенный, тоесть выполняет в Minitest ту же роль, что и pending в RSpec 
require "test_helper"

class BarcodeTest < ActiveSupport::TestCase
  test "add some examples to (or delete) this test file" do
    skip "add some examples to (or delete) this test file"
  end
end



puts '                                            Примеры тестов'

# 1. Тест модели
# test/models/user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "email must be present" do
    user = User.new(email: nil)
    assert_not user.valid?
  end
end


# 2. Тест контроллера
# test/controllers/posts_controller_test.rb
require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get posts_url
    assert_response :success
  end
end


# 3. Тест системы (браузерный)
# test/system/login_test.rb
require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "user can log in" do
    user = create(:user)
    visit login_path

    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"

    assert_text "Logged in successfully"
  end
end
# $ rails test:system               - запуск только system-тестов.


# 4. Тест компонента (в Rails 7+)
# test/components/button_component_test.rb
require "test_helper"

class ButtonComponentTest < ViewComponent::TestCase
  test "renders text" do
    render_inline(ButtonComponent.new) { "Click me" }
    assert_text "Click me"
  end
end



puts '                                         Утверждения минитеста'

# https://docs.seattlerb.org/minitest/Minitest/Assertions.html      - полная инфа по утверждениям

# Утверждения - выполняют проверки, чтобы гарантировать, что все идет по плану

# С minitest можно добавлять собственные утверждения. Это делает, например Rails

# [msg] - далее это необязательное строковое сообщение, которое можно указать, чтобы сделать сообщения о неудачах теста более понятными.

assert(test, [msg])	                                      # проверяет, что выражение test вернет true
assert_not(test, [msg])	                                  # проверяет, что выражение test вернет false

assert_equal(expected, actual, [msg])	                    # проверяет равенство. expected == actual это true
assert_not_equal(expected, actual, [msg])	                # expected != actual это правда.

assert_same(expected, actual, [msg])	                    # expected.equal?(actual) это правда.
assert_not_same(expected, actual, [msg])	                # expected.equal?(actual) это ложно.

assert_nil(obj, [msg])	                                  # obj.nil? это true
assert_not_nil(obj, [msg])	                              # obj.nil? это ложно.

assert_empty(obj, [msg])	                                # obj это empty?.
assert_not_empty(obj, [msg])	                            # obj не empty?.

assert_match(regexp, string, [msg])	                      # строка соответствует регулярному выражению.
assert_no_match(regexp, string, [msg])	                  # строка не соответствует регулярному выражению.

assert_includes(collection, obj, [msg])	                  # obj находится в collection.
assert_not_includes(collection, obj, [msg])	              # obj не находится в collection.

assert_in_delta(expected, actual, [delta], [msg])	        # числа expected и actual находятся в пределах delta друг друга.
assert_not_in_delta(expected, actual, [delta], [msg])	    # числа expected и actual не находятся delta друг в друге.

assert_in_epsilon(expected, actual, [epsilon], [msg])	    # числа expected и actual имеют относительную погрешность менее epsilon.
assert_not_in_epsilon(expected, actual, [epsilon], [msg])	# числа expected и actual имеют относительную погрешность не менее epsilon.

assert_throws(symbol, [msg]) { block }	                  # указанный блок выдаст symbol
assert_raises(exception1, exception2, ...) { block }	    # блок вызовет одно из указанных исключений.

assert_instance_of(class, obj, [msg])	                    # obj это экземпляр class
assert_not_instance_of(class, obj, [msg])	                # obj это не экземпляр class

assert_kind_of(class, obj, [msg])	                        # obj является экземпляром class или происходит от него
assert_not_kind_of(class, obj, [msg])	                    # obj не является экземпляром class и не происходит от него

assert_respond_to(obj, symbol, [msg])	                    # obj реагирует на symbol
assert_not_respond_to(obj, symbol, [msg])	                # obj не реагирует на symbol

assert_operator(obj1, operator, [obj2], [msg])	          # obj1.operator(obj2) это правда.
assert_not_operator(obj1, operator, [obj2], [msg])	      # obj1.operator(obj2) это ложно.

assert_predicate(obj, predicate, [msg])	                  # obj.predicate это правда, например assert_predicate str, :empty?
assert_not_predicate(obj, predicate, [msg])	              # obj.predicate это ложно, например assert_not_predicate str, :empty?

assert_error_reported(class) { block }	                  # класс ошибки был сообщен, например assert_error_reported IOError { Rails.error.report(IOError.new("Oops")) }
assert_no_error_reported { block }	                      # не было сообщено ни об одной ошибке, напримерassert_no_error_reported { perform_service }

assert_difference	                                        # проверяет изменение счётчика
assert_text	                                              # проверяет текст на странице (system test)

flunk([msg])	                                            # гарантирует провал. Это полезно для явного обозначения теста, который еще не завершен.



puts '                                   Утверждения, специфичные для Rails'

# Rails добавляет в фреймворк несколько собственных пользовательских утверждений minitest

assert_difference(expressions, difference = 1, message = nil) {...}	
# Проверьте числовую разницу между возвращаемым значением выражения и результатом вычисления в полученном блоке.

assert_no_difference(expressions, message = nil, &block)
# числовой результат вычисления выражения не изменяется до и после вызова переданного блока.

assert_changes(expressions, message = nil, from:, to:, &block)
# результат вычисления выражения изменился после вызова переданного блока.

assert_no_changes(expressions, message = nil, &block)
# результат вычисления выражения не изменился после вызова переданного блока.

assert_nothing_raised { block }
# данный блок не вызовет никаких исключений.

assert_recognizes(expected_options, path, extras = {}, message = nil)
# маршрутизация указанного пути была обработана правильно и что проанализированные опции (указанные в хэше expected_options) соответствуют пути. По сути, он утверждает, что Rails распознает маршрут, заданный expected_options.

assert_generates(expected_path, options, defaults = {}, extras = {}, message = nil)	
# предоставленные параметры могут быть использованы для генерации предоставленного пути. Это обратный параметр assert_recognizes. Дополнительный параметр используется для указания запросу имен и значений дополнительных параметров запроса, которые будут в строке запроса. Параметр message позволяет указать пользовательское сообщение об ошибке для сбоев утверждения.

assert_routing(expected_path, options, defaults = {}, extras = {}, message = nil)	
# path и options соответствует обоим способам; другими словами, он проверяет, что path генерирует options, а затем, что options генерирует path. Это по сути объединяет assert_recognizes и assert_generates в один шаг. Хэш extras позволяет указать параметры, которые обычно предоставляются в качестве строки запроса для действия. Параметр message позволяет указать пользовательское сообщение об ошибке, которое будет отображаться в случае сбоя.

assert_response(type, message = nil)	
# ответ приходит с определенным кодом статуса. Вы можете указать - :success, чтобы указать 200-299, :redirect для 300-399, :missing для 404 или :error для 500-599. Также можно передать явный номер статуса или его символический эквивалент

assert_redirected_to(options = {}, message = nil)	
# ответ является перенаправлением на URL, соответствующий заданным параметрам. Также можно передавать именованные маршруты, такие как assert_redirected_to root_path и объекты Active Record, такие как assert_redirected_to @article

assert_queries_count(count = nil, include_schema: false, &block)	
# &block генерирует int ряд SQL-запросов

assert_no_queries(include_schema: false, &block)	
# &block не генерирует SQL-запросы

assert_queries_match(pattern, count: nil, include_schema: false, &block)	
# &block генерирует SQL-запросы, соответствующие шаблону

assert_no_queries_match(pattern, &block)	
# &block не генерирует SQL-запросов, соответствующих шаблону

assert_permit(context, record, :action) # проверяет, что разрешено.
assert_permit({user: @seller}, @record, :create?)

assert_forbid(context, record, :action) # проверяет, что запрещено.
assert_forbid({user: @manager}, @record, :create?)



puts '                                       Утверждения в тестовых случаях'

# Все основные утверждения, такие как assert_equal определенные в Minitest::Assertions также доступны в классах, которые мы используем в наших собственных тестовых случаях. Rails предоставляет следующие классы для наследования:
ActiveSupport::TestCase
ActionMailer::TestCase
ActionView::TestCase
ActiveJob::TestCase
ActionDispatch::Integration::Session
ActionDispatch::SystemTestCase
Rails::Generators::TestCase
# Каждый из этих классов включает Minitest::Assertions, что позволяет использовать все основные утверждения в тестах

# Контроллеры и запросы
# Используй ActionDispatch::IntegrationTest или ActionController::TestCase

# Фичи / Системные тесты
# Используй ApplicationSystemTestCase (Capybara тоже можно подключить)



puts '                                       Варианты запуска тестов в Rails'


# $ bin/rails test                                     - запустить все тесты сразу
# $ rails test                                         - запустить все тесты сразу

# $ bin/rails test:models                              - запуск только тестов моделей
# $ rails test:system                                  - запуск только system-тестов

# $ bin/rails test test/controllers                    - запустить каталог тестов, указав путь к каталогу

# $ bin/rails test test/models/article_test.rb         - запустить один конкретный тестовый файл

# Запустить определенный метод теста из тестового случая, указав флаг -n или --name и имя метода теста:
# $ bin/rails test test/models/article_test.rb -n test_the_truth

# Запустить тест на определенной линии, указав ее номер:
# $ bin/rails test test/models/article_test.rb:6

# Запустить ряд тестов, указав диапазон линии:
# $ bin/rails test test/models/article_test.rb:6-20


# Тестовый раннер также предоставляет множество других функций, его документация:
# $ bin/rails test -h
