puts '                                    Тестирование моделей'

# План тестирования моделей в Ruby on Rails с использованием Minitest, который можно адаптировать под любую модель

# test/models/your_model_test.rb



puts '                         shoulda и shoulda-matchers (не используются)'

# Гемы shoulda и shoulda-matchers официально поддерживают только RSpec. Они не работают из коробки с Minitest, особенно последние версии (после разделения на shoulda-context и shoulda-matchers). На практике это значит shoulda-matchers — работает только с RSpec, а с Minitest нет.

# shoulda (классический) раньше поддерживал Minitest, но давно заброшен и больше не развивается
# shoulda-context и shoulda-matchers теперь разделены, и shoulda-context ещё может использоваться с Minitest, но только для DSL, а не для матчеров валидаций и ассоциаций


# Альтернатива для Minitest
# [ActiveSupport::TestCase] с обычными assert и assert_includes.

# Гемы-альтернативы для матчеров, например:
# minitest-matchers
# minitest-rails-shoulda – частично работает, но не всегда поддерживается.
# Или вручную писать просые проверки (лучший вариант)

# Пример простой проверки написанной вручную (Это надёжно, читаемо и не требует лишних зависимостей):
test "should validate presence of title" do
  post = Post.new(title: "", body: "test")
  assert_not post.valid?
  assert_includes post.errors[:title], "can't be blank"
end



puts '                                   Валидации (validations)'

# Протестировать, что модель валидируется правильно

test "is valid with valid attributes" do
  model = build(:your_model)
  assert model.valid?
end

test "is invalid without name" do
  model = build(:your_model, name: nil)
  assert_not model.valid?
  assert_includes model.errors[:name], "can't be blank"
end



puts '                                   Ассоциации (associations)'

# 1. Если используется shoulda-matchers:
should belong_to(:user)
should have_many(:comments)

# 2. Вручную, если не используется shoulda-matchers:
test "has many comments" do
  model = create(:your_model)
  assert_respond_to model, :comments
end



puts '                                Методы (instance и class methods)'

# Проверьте поведение кастомных методов:
test "#full_name returns combined first and last name" do
  user = build(:user, first_name: "John", last_name: "Doe")
  assert_equal "John Doe", user.full_name
end



puts '                                            Scope-ы'

test ".published returns only published records" do
  create(:post, published: true)
  create(:post, published: false)

  assert_equal 1, Post.published.count
end



puts '                                      Коллбэки (если есть)'

# Проверить, что коллбэк сработал:
test "sets default role on create" do
  user = create(:user)
  assert_equal "member", user.role
end



puts '                                    Обработка ошибок/edge cases'

# Проверить, как модель ведет себя в нештатных ситуациях:
test "raises error if required data is missing" do
  assert_raises(ActiveRecord::RecordInvalid) do
    create(:order, total: nil)
  end
end



puts '                                        Чистота базы данных'

# Проверить, что создается/удаляется правильно:
test "deletes associated comments when destroyed" do
  post = create(:post)
  create(:comment, post: post)

  assert_difference("Comment.count", -1) do
    post.destroy
  end
end



puts '                                            Еще примеры'

require "test_helper"
# Тест BarcodeTest проверяет ассоциации и валидации модели Barcode
class BarcodeTest < ActiveSupport::TestCase
  test "associations" do
    barcode = build(:barcode) # Создаётся объект Barcode, но не сохраняется в базу данных (используется build, а не create)
    assert_respond_to barcode, :purchases # стандартный матчер Minitest, проверяющий, что объект реализует указанный метод (в данном случае — геттер ассоциации). Проверяет, что у объекта barcode есть ассоциация has_many :purchases (включая ассоциации с опцией optional: true и скоупами)
    assert_respond_to barcode, :product
    assert_respond_to barcode, :category
    assert_respond_to barcode, :status_value
  end

  test "validates presence and uniqueness of sku" do
    # Проверка уникальности:
    create(:barcode, sku: "123")            # создаётся объект с sku: "123"
    duplicate = build(:barcode, sku: "123") # создаётся дубликат со значением sku: "123"
    assert_not duplicate.valid? # проверяет false, те объект некорректен (валидации не проходят)
    assert_includes duplicate.errors[:sku], "уже существует" # проверяет, что в ошибках валидации по полю :sku есть сообщение "уже существует" (локализованное сообщение для validates_uniqueness_of). duplicate.errors[:sku] возвращает массив сообщений об ошибках по полю sku

    # Проверка обязательности. Аналогично — assert_not и assert_includes проверяют, что валидация на presence срабатывает:
    barcode = build(:barcode, sku: nil)
    assert_not barcode.valid?  
    assert_includes barcode.errors[:sku], "не может быть пустым" 
  end
end
# Этот тест гарантирует, что:
# Все нужные ассоциации (has_many, belongs_to) корректно заданы и доступны
# Поле sku обязательно к заполнению и уникально
# Сообщения об ошибках приходят ожидаемые (на русском, как определено в локалях)


# Можно вручную создавать объекты, чтобы избежать сложных взаимодействий с фабриками
class PurchaseTest < ActiveSupport::TestCase
  test "validations" do
    # вручную создаём purchase без вызова assign_batch_number_data, который вызывает barcode.split и соотв ожидает строку, а не nil
    purchase = Purchase.new
    assert_not purchase.valid?
    assert_includes purchase.errors[:barcode], "не может быть пустым"
  end
end



puts '                               Данные необходимые для ИИ-генерации тестов'

# Чтобы сгенерировать полноценные тесты моделей на Minitest, нужно предоставить:

# 1. Обязательные:
# а) Код самих моделей. Пример: app/models/user.rb, app/models/post.rb. Нужно, чтобы понять валидации, ассоциации, методы, scope'ы и коллбэки.
# б) Схема базы данных. Пример: db/schema.rb или structure.sql. Нужно, чтобы видеть поля, типы данных, индексы, внешние ключи и связи.

# 2. Желательные (но не критичные):
# а) Фабрики (FactoryBot) или fixtures. Пример: test/factories/users.rb или test/fixtures/users.yml. Чтобы понимать, как создаются валидные объекты в тестах.
# б) Гемфайл (Gemfile). Чтобы учитывать используемые библиотеки: например, paranoia, acts_as_list, aasm, devise, annotate, friendly_id итд