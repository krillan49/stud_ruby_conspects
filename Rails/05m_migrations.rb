puts '                                       Миграции(AR)'

# rails g migration - генератор миграции, который создает миграцию без модели.



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
  # (4м аргументом можно поставить значение по умолчанию)

  # По умолчанию можно будет вставить в этот столбец неуникальный username(те может быть 2+ одинаковых). Чтобы это исправить создадим на уровне БД уникальный индекс, который означает, что в этот столбец можно будет вставить только уникальные значения, если будем вставлять неуникальные, то ошибка будет уже на уровне БД.
  # Индекс - это когда для нашей таблицы создается доп таблица, с указателями для более быстрого выбора записей по ключу(полю). Для полей с индексами увеличивается время вставки, но уменьшается время выборки по определённому полю.
  add_index :users, :username, unique: true
  # (Индексы можно добавить и в отдельной миграции, например назвать ее add_index)
end














#
