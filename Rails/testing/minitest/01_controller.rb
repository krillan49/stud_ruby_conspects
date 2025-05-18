puts '                                    Тестирование контроллеров'

# Можно использовать fixtures, FactoryBot или Fabrication для подготовки данных

# Генерация теста:
# $ rails generate test_unit:controller Articles
#=>
# test/controllers/articles_controller_test.rb



puts '                                      happy path и edge cases'

# Стоит покрывать как happy path, так и edge cases:
# Happy path тесты показывают, что всё работает, когда всё хорошо (типичные, ожидаемые сценарии)
# Edge case тесты проверяют устойчивость — приложение не должно падать, даже если ввод плохой или ситуация редкая (пограничные или ошибочные ситуации)


# 1. Happy path (счастливый путь) - это нормальное, ожидаемое поведение системы, когда пользователь делает всё правильно, и всё работает как должно

# Примеры для контроллера:
# Успешный вход пользователя
# Получение страницы без ошибок (GET /dashboard при наличии авторизации)
# Успешное создание ресурса (POST /users с валидными данными)

# Пример теста:
test "should create user with valid data" do
  assert_difference "User.count", 1 do
    post users_path, params: { user: { email: "test@example.com", password: "123456" } }
  end
  assert_redirected_to dashboard_path
end


# 2. Edge case (крайний случай, пограничный) - это ситуация, где ввод или состояние граничны, неверны или необычны. Эти кейсы помогают проверить, как приложение ведёт себя в нештатных условиях

# Например:
# Переданы невалидные данные (пустой email, короткий пароль)
# Запрос выполнен без авторизации
# Попытка редактировать чужой ресурс
# Отсутствует обязательный параметр (params[:id] — nil)
# Объект не найден (ActiveRecord::RecordNotFound)

# Пример edge case-теста:
test "should not create user with invalid data" do
  post users_path, params: { user: { email: "", password: "123", password_confirmation: "456" } }
  assert_response :unprocessable_entity
  assert_select "div.alert", /Ошибка/
end



puts '                                      Структура тестов контроллера'

# 0. setup — создаём нужные объекты (через fixtures, фабрики или напрямую)

# Для каждого экшена:
# 1. Тесты успешных ответов на get, post, patch, delete (доступ к публичным экшенам, например, index, show) и проверка response. Можно ли открыть страницу (например, GET /articles). Возвращает ли экшен 200 OK (или другой ожидаемый статус)
# 2. Проверка редиректов. Если пользователь неавторизован или не имеет прав, происходит ли редирект (например, на sign_in_path или root_path). Если действие успешно выполнено (например, POST на create), идёт ли редирект на нужную страницу (например, show)
# 3. Проверка изменения состояния (создание, удаление и т. д.)
# 4. Авторизация, если используется (например, через ActionPolicy). Проверить, что закрытые экшены требуют авторизации (например, new, edit, destroy)
# 5. Проверка ошибок валидации (для экшенов типа create и update)


# Чтобы понять какие экшены защищены, можно посмотреть в `before_action :authenticate_user!`, в `ApplicationController` или в самом контроллере, ActionPolicy/Pundit/другую авторизацию


# Минимальным набором тестов для каждого контроллера это как минимум:
class ArticlesControllerTest < ActionDispatch::IntegrationTest # ArticlesControllerTest - проверяет, что контроллер ArticlesController работает правильно
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



puts '                                       Полезные утверждения'

# Полезные утверждения ActionDispatch::IntegrationTest в Rails: assert_difference, assert_redirected_to, assert_response


# assert_response - проверяет, что ответ контроллера имел ожидаемый HTTP статус код. Часто используемые значения:
# 200  :success               Успешный ответ
# 302  :redirect              Перенаправление
# 401  :unauthorized          Нет авторизации
# 403  :forbidden             Доступ запрещён
# 404  :not_found             Не найдено
# 422  :unprocessable_entity  Ошибка валидации формы
# 400  :bad_request           Некорректный запрос
test "should get index" do
  get articles_url
  assert_response :success # ожидаем, что страница откроется успешно (HTTP 200)
end


# assert_difference - проверки создания/удаления/изменения данных. Проверяет, что выражение (обычно количество записей в таблице) изменилось на ожидаемое число после выполнения блока
assert_difference "User.count", 1 do
  post users_path, params: { user: { email: "test@example.com", password: "123456" } }
end
# ожидаем, что User.count увеличится на 1 те пользователь будет создан

# assert_no_difference - проверки не создания/удаления/изменения данных. Проверяет, что выражение (обычно количество записей в таблице) не изменилось после выполнения блока
assert_no_difference("Article.count") do # проверяет что количество статей не изменилось
  post articles_url, params: { article: { title: "", body: "" } } # пытается создать статью с пустыми заголовком и текстом
end


# assert_redirected_to - подтверждения редиректов после действия. Проверяет, что ответ от контроллера был перенаправлением (HTTP 302) на указанный путь или URL

# Успешный POST редирект:
test "should create article and redirect to show" do
  post articles_url, params: { article: { title: "Test", body: "Content" } }
  assert_redirected_to article_path(Article.last) # ожидаем, что после запроса пользователь будет перенаправлён на /Article/:id
end

# Доступ запрещён, редирект:
test "should redirect new when not logged in" do
  get new_article_url
  assert_redirected_to sign_in_url
end



puts '                                         Пример (пункты 1-3)'

# Тесты, чтобы убедиться, что все основные действия (index, new, create, show, edit, update, destroy) работают корректно и не ломаются после изменений в коде.

require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  # setup - загружает одну статью из fixtures перед каждым тестом
  def setup
    @article = articles(:one)
  end

  # Каждый test - это отдельная проверка одного экшена (например, открытия страницы или создания статьи)

  test "should get index" do
    get articles_url         # открывает страницу со списком всех статей
    assert_response :success # проверяет, что ответ успешный (код 200)
  end

  test "should get new" do
    get new_article_url       # открывает форму для создания новой статьи
    assert_response :success  # проверяет, что страница доступна (код 200)
  end

  test "should create article" do
    assert_difference("Article.count") do # проверяет что количество статей увеличилось ?на 1?
      post articles_url, params: { article: { title: "Test", body: "Content" } } # пытается создать новую статью с заголовком и текстом
    end
    assert_redirected_to article_path(Article.last) # проверяет что происходит редирект на страницу новой статьи
  end

  test "should show article" do
    get article_url(@article) # открывает страницу конкретной статьи
    assert_response :success  # проверяет, что она доступна (код 200)
  end

  test "should get edit" do
    get edit_article_url(@article) # открывает форму редактирования существующей статьи
    assert_response :success       # проверяет, что она загружается (код 200)
  end

  test "should update article" do
    patch article_url(@article), params: { article: { title: "Updated" } } # изменяет заголовок статьи
    assert_redirected_to article_path(@article) # проверяет что редирект идёт обратно к статье
    @article.reload
    assert_equal "Updated", @article.title      # проверяет что заголовок действительно изменился
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do # проверяет что количество статей уменьшилось на 1
      delete article_url(@article)            # удаляет статью
    end
    assert_redirected_to articles_path        # проверяет что происходит редирект на список всех статей
  end
end



puts '                                 Проверка авторизации и ошибок валидации'

# Оба теста относятся к edge cases — проверкам необычных или запрещённых ситуаций


# Проверка авторизации (если используется ActionPolicy). Проверяет, что нельзя редактировать статьи без разрешения.
test "should not allow update by unauthorized user" do
  sign_in users(:unauthorized) # симулирует вход пользователя, у которого нет прав на редактирование статьи. (sign_in - если используется Devise)
  patch article_url(@article), params: { article: { title: "Hacked" } } # пытается изменить заголовок статьи
  assert_redirected_to root_path # проверяет что пользователь перенаправляется на главную страницу (root_path)
  assert_equal "Access denied", flash[:alert] # проверяет что отображается сообщение "Access denied"
end


# Проверка валидации. Проверяет, что валидация формы работает, и плохие данные не сохраняются.
test "should not create article with invalid params" do
  assert_no_difference("Article.count") do # проверяет что количество статей не изменилось
    post articles_url, params: { article: { title: "", body: "" } } # пытается создать статью с пустыми заголовком и текстом
  end
  assert_response :unprocessable_entity # проверяет что сервер вернул код 422 Unprocessable Entity, тоесть данные не прошли валидацию
end



puts '                               Данные необходимые для ИИ-генерации тестов'

# Чтобы грамотно написать тесты на доступ и редиректы для контроллеров в Minitest (Rails 8), одного кода контроллера недостаточно. Ещё понадобится:

# 1. config/routes.rb  (без него нельзя корректно вызывать get some_url в тестах)

# 2. Механизм аутентификации/авторизации: 
# a) Используется ли Devise, Authlogic, ActionPolicy, Pundit итд
# b) Как происходит логин в тестах (нужен ли sign_in users(:admin) или установка session[:user_id])
# c) Как контроллеры проверяют доступ: before_action :authenticate_user!, authorize!, policy_scope, ActionPolicy итд
# d) Нужно понимать, какие экшены защищены, а какие публичные.

# 3. Роли или уровни доступа, тк это влияет на то, ожидаем ли :success или :redirect
# a) Есть ли разные типы пользователей? (гость, обычный пользователь, админ и т.д.)
# b) Какие экшены доступны для каждой роли

# 4. Тестовые данные
# a) Используются ли fixtures, FactoryBot, Fabrication
# b) Есть ли тестовые пользователи, статьи, записи итд
# c) Для edit, show, destroy часто нужны записи в БД. Нужно знать, как они создаются в тестах

# 5. Поведение по умолчанию в ApplicationController
# Есть ли глобальные before_action, тк это влияет на все контроллеры, например:
before_action :authenticate_user!
rescue_from ActionPolicy::Unauthorized, with: :deny_access

# 6. Ожидаемые редиректы, чтобы сравнивать assert_redirected_to expected_path
# Куда должен редиректить: на sign_in_path, root_path, article_path, dashboard_path
# Устанавливается ли flash[:alert], notice



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