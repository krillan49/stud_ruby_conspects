puts '                                    Тестирование контроллеров'

# Используйте fixtures, FactoryBot или Fabrication для подготовки данных

# Используйте assert_difference, assert_redirected_to, assert_response

# Покрывайте как happy path, так и edge cases



puts '                                         1. Подготовка'

# Убедитесь, что в проекте подключен minitest-rails, Gemfile:
group :test do
  gem 'minitest-rails'
end

# $ bundle install
# $ rails generate minitest:install



puts '                                       2. Генерация теста'

# $ rails generate test_unit:controller Articles

# Создаст файл test/controllers/articles_controller_test.rb



puts '                                 3. Структура тестов контроллера'

# Для каждого экшена пишем:
# 1. setup — создаём нужные объекты (через fixtures, фабрики или напрямую)
# 2. тесты успешных ответов — get, post, patch, delete и проверка response
# 3. проверка редиректов
# 4. проверка изменения состояния (создание, удаление и т. д.)
# 5. авторизация, если используется (например, через ActionPolicy)



puts '                                           4. Пример'

require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one) # из fixtures
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get new" do
    get new_article_url
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: { article: { title: "Test", body: "Content" } }
    end
    assert_redirected_to article_path(Article.last)
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_url(@article)
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: { title: "Updated" } }
    assert_redirected_to article_path(@article)
    @article.reload
    assert_equal "Updated", @article.title
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end
    assert_redirected_to articles_path
  end
end



puts '                                     5. Проверка авторизации'

# Проверка авторизации (если используется ActionPolicy)

test "should not allow update by unauthorized user" do
  sign_in users(:unauthorized) # если используется Devise

  patch article_url(@article), params: { article: { title: "Hacked" } }
  assert_redirected_to root_path
  assert_equal "Access denied", flash[:alert]
end



puts '                                    6. Проверка ошибок валидации'

test "should not create article with invalid params" do
  assert_no_difference("Article.count") do
    post articles_url, params: { article: { title: "", body: "" } }
  end
  assert_response :unprocessable_entity
end



puts '                                      По задаче (?потом удалить?)'

# Задача "написать тесты для контроллеров — сделать простые проверки на доступ/редиректы" в контексте Rails и Minitest означает следующее:

# Написать интеграционные (или контроллерные) тесты, которые проверяют:
# 1. Доступ к экшенам
# Можно ли открыть страницу (например, GET /articles)
# Возвращает ли экшен 200 OK (или другой ожидаемый статус)

# 2. Редиректы
# Если пользователь неавторизован или не имеет прав, происходит ли редирект (например, на sign_in_path или root_path)
# Если действие успешно выполнено (например, POST на create), идёт ли редирект на нужную страницу (например, show)


# Примеры

# Доступ разрешён:
test "should get index" do
  get articles_url
  assert_response :success
end

# Доступ запрещён (редирект):
test "should redirect new when not logged in" do
  get new_article_url
  assert_redirected_to sign_in_url
end

# Успешный POST → редирект:
test "should create article and redirect to show" do
  post articles_url, params: { article: { title: "Test", body: "Content" } }
  assert_redirected_to article_path(Article.last)
end

# задача в итоге Пройтись по каждому контроллеру и:
# 1. Проверить доступ к публичным экшенам (например, index, show)
# 2. Проверить, что закрытые экшены требуют авторизации (например, new, edit, destroy)
# 3. Проверить, что при действиях всё редиректит туда, куда должно

# Как понять, какие экшены защищены?
# Посмотри в:
# before_action :authenticate_user! в ApplicationController или в самом контроллере
# ActionPolicy/Pundit/другую авторизацию

# Совет по структуре теста:
# Для каждого контроллера — как минимум:
class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should redirect new when not logged in" do
    get new_article_url
    assert_redirected_to sign_in_url
  end

  test "should create article and redirect" do
    # логинимся, если нужно
    post articles_url, params: { article: { title: "Hello", body: "World" } }
    assert_redirected_to article_path(Article.last)
  end
end



puts '                              Какие данные нужны для генерации тестов ИИ'

# Чтобы грамотно написать тесты на доступ и редиректы для контроллеров в Minitest (Rails 8), одного кода контроллера недостаточно. Ещё понадобится:

# 1. Настройки маршрутов (config/routes.rb)
# Без этого нельзя корректно вызывать get some_url в тестах.

# 2. Механизм аутентификации/авторизации. Используется ли Devise, Authlogic, ActionPolicy, Pundit и т.п.?
# Как происходит логин в тестах? (нужен ли sign_in users(:admin) или установка session[:user_id])
# Как контроллеры проверяют доступ: before_action :authenticate_user!, authorize!, policy_scope, ActionPolicy и т.д.
# Нужно понимать, какие экшены защищены, а какие публичные.

# 3. Роли или уровни доступа
# Есть ли разные типы пользователей? (гость, обычный пользователь, админ и т.д.)
# Какие экшены доступны для каждой роли?
# Это влияет на то, ожидаем ли :success или :redirect.

# 4. Тестовые данные
# Используются ли fixtures, FactoryBot, Fabrication
# Есть ли тестовые пользователи, статьи, записи и т.д.?
# Для edit, show, destroy часто нужны записи в БД. Нужно знать, как они создаются в тестах.

# 5. Поведение по умолчанию в ApplicationController
# Есть ли глобальные before_action, например:
before_action :authenticate_user!
rescue_from ActionPolicy::Unauthorized, with: :deny_access
# Это влияет на все контроллеры и определяет поведение по умолчанию.

# 6. Ожидаемые редиректы
# Куда должен редиректить: на sign_in_path, root_path, article_path, dashboard_path?
# Устанавливается ли flash[:alert], notice?
# Чтобы сравнивать assert_redirected_to expected_path.