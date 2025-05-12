puts '                                          Minitest'

# Cтандартный фреймворк в комплекте с Ruby on Rails - minitest. 

# Запустить тесты:
# $ rails test


# Rails создает test-каталог, как только вы создаете проект Rails с помощью bin/rails new application_name, в котором находятся подкаталоги: application_system_test_case.rb, controllers/, helpers/, mailers/, system/, fixtures/, integration/, models/
# * helpers, mailers и models - хранятся тесты для помощников представлений, почтовых программ и моделей соответственно.
# * controllers               - используется для тестов, связанных с контроллерами, маршрутами и представлениями, где будут моделироваться HTTP-запросы и делаться утверждения по результатам.
# * integration               - зарезервирован для тестов, охватывающих взаимодействие между контроллерами.
# * systemtest                - хранятся системные тесты, которые используются для полного тестирования приложения в браузере. Системные тесты позволяют тестировать приложение так, как его видят ваши пользователи, а также помогают тестировать JavaScript. Системные тесты наследуются от Capybara и выполняют внутрибраузерные тесты для приложения.
# * fixtures                  - Fixtures это способ создания макетов данных для использования в тестах, чтобы вне приходилось использовать «реальные» данные. Они хранятся в fixtures каталоге.
# * При первом создании задания jobs также будет создан каталог для ваших тестовых заданий.
# * test_helper.rb            - содержит конфигурацию по умолчанию для ваших тестов.
# * application_system_test_case.rb - конфигурацию по умолчанию для тестов вашей системы.



puts '                                        Синтаксис теста'

# bin/rails generate model команда помимо создания модели, создает тестовую заглушку в test каталоге:

# $ bin/rails generate model article title:string body:text
#=>
# create  app/models/article.rb
# create  test/models/article_test.rb

# Тестовая заглушка по умолчанию test/models/article_test.rb выглядит так:
require "test_helper" # test_helper.rb загружает конфигурацию по умолчанию для запуска тестов. Все методы, добавленные в этот файл, также доступны в тестах, когда этот файл включен

class ArticleTest < ActiveSupport::TestCase # это называется тестовым случаем, ArticleTest класс наследует от ActiveSupport::TestCase, соответсвенно имеет все методы из него. ActiveSupport::TestCase наследует от Minitest::Test

  # Rails добавляет метод `test`, который принимает имя теста и блок. Он генерирует стандартный Minitest::Unit тест с переданным именем с префиксом `test_`, что удобно:
  test "the truth" do # Имя метода генерируется путем замены пробелов на подчеркивания
    assert true # эта часть теста называется «утверждение»
  end
  # Это примерно то же самое, что:
  def test_the_truth
    assert true
  end
  # Можно использовать и такие обычные определения методов
end
# Любой метод, определенный в классе(унаследованном от Minitest::Test) с именем `test_чтото` (например test_password и test_valid_password) называется тестом и будет запущен автоматически при запуске тестового случая

# Утверждение - это строка кода, которая оценивает объект (или выражение) на предмет ожидаемых результатов. Например:
# * равно ли это значение тому значению?
# * этот объект равен нулю?
# * вызывает ли эта строка кода исключение?
# * пароль пользователя длиннее 5 символов?
# Каждый тест может содержать сколько угодно утверждений. Тест считается пройденным только в том случае, если все утверждения будут успешными



puts '                                     Проваленый тест и вывод тестов'

# В примере утверждается, что статья не будет сохранена без соответствия определенным критериям; следовательно, если статья будет успешно сохранена, тест провалится
require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "should not save article without title" do
    article = Article.new
    assert_not article.save
  end
end

# Результат запуска этого теста:
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

# В выходных данных F указывает на сбой теста. Раздел ниже Failure включает имя сбойного теста, за которым следует трассировка стека и сообщение, показывающее фактическое значение и ожидаемое значение из утверждения

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


# Чтобы этот тест прошел, для поля можно добавить проверку на уровне модели title. Теперь тест пройдет, так как статья в нем не была инициализирована с title, поэтому проверка модели предотвратит сохранение:
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

# Зеленая точка на экране означает, что тест пройден успешно



puts '                                       Сообщение об ошибках'

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

# E - обозначает тест с ошибкой. Зеленая точка над линией «Finished» обозначает прохождение теста

# Выполнение каждого метода теста останавливается, как только обнаруживается какая-либо ошибка или сбой утверждения и тестовый набор продолжается со следующим методом. 
# Все методы теста выполняются в случайном порядке. Опция `config.active_support.test_order` может использоваться для настройки порядка теста

# Если нужно, чтобы этот тест прошел, можно изменить его с добавлением assert_raises (чтобы теперь проверялось наличие ошибки)
test "should report error" do
  assert_raises(NameError) do
    some_undefined_variable
  end
end