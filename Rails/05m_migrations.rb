puts '                                       Миграции(AR)'

# https://api.rubyonrails.org/classes/ActiveRecord/Migration.html

# rails g migration - генератор миграции, который создает миграцию без модели.

# Запуск миграции с правильным синтаксисом, с версиями гемов из гемфаила:
# > bundle exec rake db:migrate



puts '                                    change_column_null'

# Сделаем миграцию которая запретит значения NULL в полях таблиц questions и answers(валидация на уровне БД)

# > rails g migration add_missing_null_checks

# db/migrate/20231119083044_add_missing_null_checks.rb
class AddMissingNullChecks < ActiveRecord::Migration[7.0]
  def change
    change_column_null :questions, :title, false
    # change_column_null - метод для того чтобы запретить/разрешить NULL в колонке
    # :questions - название таблицы
    # :title     - название поля
    # false      - означает, что в данной колонке значения NULL быть не может
    change_column_null :questions, :body, false
    change_column_null :answers, :body, false
  end
end

# > rails db:migrate

# Теперь в схеме эти колонки получили опцию null: false
t.string "title", null: false

# При такой миграции никакие данные потеряны не будут



puts '                                      add_column, add_index'

# Пример добавления столбцов и индексов есть в Девайс

def change
  add_column :users, :username, :string
  # add_column - метод для создания столбца(одного отдельного, для другого нужно писать еще раз add_column ...)
  # :users    - имя таблицы в которую добавим новый столбец
  # :username - имя нового столбца
  # :string   - тип данных нового столбца
  # (4м аргументом можно поставить значение по умолчанию, пример - default: false)

  # По умолчанию можно будет вставить в этот столбец неуникальный username(те может быть 2+ одинаковых). Чтобы это исправить создадим на уровне БД уникальный индекс, который означает, что в этот столбец можно будет вставить только уникальные значения, если будем вставлять неуникальные, то ошибка будет уже на уровне БД.
  # Индекс - это когда для нашей таблицы создается доп таблица, с указателями для более быстрого выбора записей по ключу(полю). Для полей с индексами увеличивается время вставки, но уменьшается время выборки по определённому полю.
  add_index :users, :username, unique: true
  # Имя индексу создается автоматически
  # (Индексы можно добавить и в отдельной миграции, например назвать ее add_index)

  # Добавим еще колонку:
  add_column :users, :password_reset_token, :string
end



puts '                                           add_reference'

# Свяжем сущности User и Article как 1 - * уже после их создания, добавив поле user_id и индекс в таблицу articles

# Добавим столбец с user_id отдельной миграцией
# > rails g migration add_fk_article_to_user
# /db/migrate/20230804075512_add_fk_article_to_user.rb
class AddFkArticleToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :articles, :user # foreign key ??
    # В схеме миграйций в таблице articles появятся:
    # t.integer "user_id"
    # t.index ["user_id"], name: "index_articles_on_user_id"
  end
end
# > rake db:migrate

# /models/user.rb
class User < ApplicationRecord
  has_many :articles # добавим
end

# /models/article.rb:
class Article < ApplicationRecord
  belongs_to :user, optional: true, required: true # добавим
  # optional: true - если это не добавить то при использовании Rails 5.1 и выше создание новой статьи и тесты этого свойства выдадут ошибку "User must exist". Видимо изза того что в старых статьях созданных до связывания в колонке user_id NULL
  # required: true - если не добавить возникнут ошибки с rspec тестирыванием этой ассоциации
end

# Маршруты можно тоже поменять и вложить статьи в юзеров если надо














#
