puts '                                          Миграции(AR)'

# (!! Сопоставить с инфой про миграции из basic_MCV_generate)

# https://api.rubyonrails.org/classes/ActiveRecord/Migration.html

# миграции - это классы, которые меняют чтото в базе данных

# Миграции это временные файлы для одноразового запуска, чтобы данные не терять локально. Где-то на проектах их могут удалять например после 30 дней. Если в отпуск на месяц ушел, то уже не догонишь, из схемы будешь восстанавливаться

# Если базе создать какую-нибудь таблицу, например в SQL редакторе или отредактировать столбец в существующей, а потом сделать "rake db:migrate" или "rails app:update" то изменения должны записаться в схему и обновится там structure.sql, schema.db итд.
# У кого-то стронний скрипт вместо миграций ходит в базу и создаёт там таблички независимо от rails приложения, если запустить db:migrate, то таблички появятся в схеме.

# Начиная с Rails 6 появился "db:prepare", который при отсутcвии БД сделает "db:setup" а если база есть то "db:migrate". Это есть в файле "bin/setup"
# В Rails 8 это добавлено еще в docker-entrypoint

# А у kamal в Dockerfile есть строчка ENTRYPOINT ["/rails/bin/docker-entrypoint"]  которая как раз в последствии вызовет "./bin/rails db:prepare" при первой сборке контейнера, которая вызывается командой "kamal setup"
# Если есть миграции которых нет в схеме, он сначала обновит схему а потом создаст бд, вроде db:setup так работает

# Миграции важны, только на проде. Чтобы прод подстраивался постоянно и данные не терялись поэтому там миграция вперед, назад


# sqlite хранит всё в одиночном файле формата .sqlite



puts '                                            Команды'

# rails g migration - генератор миграции, который создает миграцию без модели.

# db:migrate - запуск миграции с правильным синтаксисом, с версиями гемов из гемфаила:
# > bundle exec rake db:migrate

# db:reset - удаляет базу данных, создаёт новую базу данных, затем выполнит все миграции, которые находятся в вашем проекте(в данной ветке). Если есть файлы seeds (например, `db/seeds.rb`), то исполнит их:
# $ rails db:reset



# Если изменить уже существующие применённые миграции и запустить `rails db:migrate` фаил schema.rb не изменится. Rails не пересматривает и повторно не применяет уже выполненные миграции, даже если их вручную отредактировать. В БД в таблице schema_migrations уже отмечено, что они были применены. Поэтому `rails db:migrate` считает, что всё в порядке и не обновляет schema.rb.
# Очень плохо редактировать применённые миграции в production-проектах. Лучше создать новые миграции с нужными изменениями, чтобы сохранить миграционную историю.

# Правильные способы переприменить измененные уже применённые миграции:

# 1. Полный сброс базы данных, это удалит все данные, использовать только в development или test окружении
# $ rails db:drop             - удалит базу
# $ rails db:create           - создаст БД заново
# $ rails db:migrate          - применит все миграции с нуля (в том числе с изменениями) и обновит schema.rb
# Если схема не обновляется и миграции не проходят, иногда помогает удалить файл schema.rb вручную, чтобы убедиться, что он будет пересоздан

# 2. Откат и повторное применение одной миграции
# Например, если ты изменена миграция `20240603123456_create_status_dictionaries.rb`:
# $ rails db:migrate:down VERSION=20240603123456       - вариант 1
# $ rails db:rollback STEP=1                           - вариант 2 (тоже но короче и не надо указвать дату)
# $ rails db:migrate

# 3. Использовать structure.sql вместо schema.rb. Если используется PostgreSQL и нужно, чтобы schema-файл точно отражал текущее состояние БД, даже при ручных изменениях можно настроить Rails на использование structure.sql.
# config/application.rb
config.active_record.schema_format = :sql
# $ rails db:structure:dump



puts '                                 Ассоциации при создании таблицы'

# references - алиас к belongs_to, создает столбец name_id являющийся foreign_key к id поля в другой таблице
t.references :article, null: false, foreign_key: true # Создает столбец article_id являющийся foreign_key к id поля той статьи к которой относится коммент в таблице articles.

# belongs_to - алиас к references, создает столбец name_id являющийся foreign_key к id поля в другой таблице
t.belongs_to :article, null: false, foreign_key: true  # в таблице укажет так если генерировали при помощи belongs_to

# МБ belongs_to лучше использовать для связи 1 - * (сущности разных моделей), а references для таблиц одной сущности при нормализации (1 - 1) ??



puts '                         Удаление старых и добавление новых внешних ключей'

# Миграция работает в паре с предыдущей миграцией (CreateSeparateDictionariesTables), где:
# Создавались новые таблицы category_dictionaries, status_dictionaries и другие вместо одной таблицы dictionaries с scoped association
# Данные из dictionaries распределяются по этим таблицам

# Эта миграция обновляет связи, чтобы они указывали на новые таблицы

# db/migrate/20250530120100_update_foreign_keys_to_new_dictionaries.rb
class UpdateForeignKeysToNewDictionaries < ActiveRecord::Migration[8.0]
  def change
    # 1. Удаление старых foreign keys
    remove_foreign_key :barcodes, column: :category_id if foreign_key_exists?(:barcodes, column: :category_id)
    remove_foreign_key :barcodes, column: :status_value_id if foreign_key_exists?(:barcodes, column: :status_value_id)
    remove_foreign_key :products, column: :status_id if foreign_key_exists?(:products, column: :status_id)
    remove_foreign_key :purchases, column: :provider_id if foreign_key_exists?(:purchases, column: :provider_id)
    # remove_foreign_key - удаляет существующие ограничения внешнего ключа, которые связывали:
    #   barcodes.category_id → dictionaries.id
    #   barcodes.status_value_id → dictionaries.id
    #   products.status_id → dictionaries.id
    #   purchases.provider_id → dictionaries.id
    # foreign_key_exists? - проверяет что внешний ключ существует. Тут делает миграцию идемпотентной (безопасной для повторного запуска)

    # 2. Создание новых foreign keys
    add_foreign_key :barcodes, :category_dictionaries, column: :category_id
    add_foreign_key :barcodes, :status_value_dictionaries, column: :status_value_id
    add_foreign_key :products, :status_dictionaries, column: :status_id
    add_foreign_key :purchases, :provider_dictionaries, column: :provider_id
    # add_foreign_key - создает новые ограничения, перенаправляя связи:
    #   barcodes.category_id → category_dictionaries.id
    #   barcodes.status_value_id → status_value_dictionaries.id
    #   products.status_id → status_dictionaries.id
    #   purchases.provider_id → provider_dictionaries.id
  end
end



puts '                                          drop_table'

# drop_table - метод для удаления таблицы, принимает имя таблицы

class DropDictionariesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :dictionaries
  end
end



puts '                                       change_column_null'

# change_column_null - метод, который вызывается в методе change, в классе миграции, он назначает/снимает ограничение NOT NULL в заданную переданным в него параметром колонку/поле таблицы (валидация на уровне БД). Применяется к одному полю одной таблицы, для другого поля нужно вызвать метод еще раз. При выполнении миграции с применением этого метода никакие данные потеряны не будут

# Сделаем миграцию которая запретит значения NULL в полях таблиц questions и answers

# > rails g migration add_missing_null_checks

# db/migrate/20231119083044_add_missing_null_checks.rb
class AddMissingNullChecks < ActiveRecord::Migration[7.0]
  def change
    change_column_null :questions, :title, false
    # :questions - название таблицы
    # :title     - название поля
    # false      - означает, что в данной колонке значения NULL быть не может, тоесть применено ограничение NOT NULL
    change_column_null :questions, :body, false
    change_column_null :answers, :body, false
  end
end

# > rails db:migrate

# Теперь в схеме эти колонки получили опцию null: false
t.string "title", null: false



puts '                                      add_column, add_index'

# add_column - метод, который вызывается в методе change, в классе миграции, для создания нового столбца в существующую таблицу. Через один вызов метода можно добавить только однин новый столбец, для другого нужно вызывать метод еще раз

# add_index - метод, который вызывается в методе change, в классе миграции, для создания индекса (?? с ограничениями ??). Индексы можно добавить и в отдельной миграции, например назвать ее add_index или в одной миграции со столбцом или при создании таблицы.
# Индекс - это когда для нашей таблицы создается доп таблица, с указателями для более быстрого выбора записей по ключу(полю). Для полей с индексами увеличивается время вставки, но уменьшается время выборки по определённому полю.

# (Пример добавления столбцов и индексов есть в разделе Девайс)

# > rails g migration add_username_and_token

# /db/migrate/20190129063426_add_username_and_token.rb
class AddUsernameAndToken < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :score, :integer, default: 0, null: false
    # :users    - имя таблицы в которую добавим новый столбец
    # :score    - имя нового столбца
    # :integer  - тип данных нового столбца
    # default   - Значение по умолчанию для столбца
    # null      - Логическое значение, указывающее, может ли столбец содержать null значения
    # limit     - Количество символов, если тип столбца — string, в противном случае количество байтов, используемых для хранения
    # precision - Точность для numeric и decimal столбцов
    # scale     - Масштаб для numeric и decimal столбцов

    add_column :users, :password_reset_token, :string # добавим еще колонку


    add_index :users, :username, unique: true
    # :users        - имя таблицы
    # :username    - имя столбца на который будет поставлен индекс
    # unique: true - доп опция с ограничением UNIQUE для данного столбца
    # Имя индексу создается автоматически

    # Индекс сразу по 2м полям:
    add_index :question_tags, [:question_id, :tag_id], unique: true
  end
end
# > rake db:migrate


# Чтобы автоматически сгенерилась миграция с кодом можно написать в генераии например
# > rails g migration add_username_to_users username:string
# Тогда создаст миграцию сразу с полем
add_column :users, :username, :string


# Пример индекса по множеству полей value, cabinet_id, category_type в таблице dictionaries:
# $ bin/rails generate migration AddIndexToDictionariesOnValueCabinetAndCategory
class AddIndexToDictionariesOnValueCabinetAndCategory < ActiveRecord::Migration[7.1]
  def change
    add_index :dictionaries, [:value, :cabinet_id, :category_type], name: "index_dictionaries_on_value_cabinet_and_category"
  end
end
# $ bin/rails db:migrate
# Такой индекс ускорит запросы вида:
Dictionary.find_by(value:, cabinet_id:, category_type:)



puts '                                         add_reference'

# add_reference - метод, который вызывается в методе change, в классе миграции, чтобы добавить столбец, который ссылается на первичный ключ ID какой-то другой связанной таблице, можно создать поле вторичного ключа под именем сущьность_id и связывает его с первичным ключем указанной в параметрах таблицы. Удобно чтобы создавать связи для уже созданных таблиц, обеспечивает большую гибкость при добавлении ограничений для связанных таблиц.

# add_reference это просто add_column + add_index в одном (пример ниже тоже сделает тоже самое что и следующий)
add_column :products, :user_id, :integer, default: 0, null: false
add_index :products, :user_id

# add_reference удобен, если нужно сделать это с помощью одного оператора схемы.
add_reference :products, :user, null: false, foreign_key: true
# type        - Тип данных для нового добавляемого столбца
# index       - Логическое значение, указывающее, нужно ли добавлять индекс. По умолчанию true.
# null        - Логическое значение, указывающее, может ли столбец содержать null значения. По умолчанию true.
# polymorphic - Если установлено значение, добавляется true дополнительный столбец с именем_type
# foreign_key - Ограничение внешнего ключа со связанной таблицей. По умолчанию false.


# Свяжем сущности User 1 - * Article, добавив поле user_id и индекс в таблицу articles

# > rails g migration add_fk_article_to_user

# /db/migrate/20230804075512_add_fk_article_to_user.rb
class AddFkArticleToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :articles, :user
    # :articles - таблица в которой будет создано поле вторичного ключа user_id
    # :user     - таблица на первичный ключ (id) которой будет ссылаться user_id
  end
end
# > rake db:migrate

# В схеме миграйций в таблице articles появятся:
t.integer "user_id"
t.index ["user_id"], name: "index_articles_on_user_id"


# Можно сразу прописать связь в генераторе, что не писать ее руками в миграции
# $ rails g migration AddUserToQuestion user:references
add_reference :questions, :user, index: true, foregin_key: true



puts '                                 Методы up, down и change_column_default'

# Создадим новые миграции чтобы добавить user_id с foreign_key в таблицы questions и answers
# > rails g migration add_user_id_to_questions user:belongs_to
# > rails g migration add_user_id_to_answers user:belongs_to
# user:belongs_to - параметр создающий новое поле user_id с foreign_key к id в таблице users
# Создались миграции:
class AddUserIdToQuestions < ActiveRecord::Migration[7.0]
  def change
    # add_user_id_to_questions - изза такого правильного названия с именами таблиц, автоматически заполнилось:
    add_reference :questions, :user, null: false, foreign_key: true, default: User.first.id
    # Но если прямо так запустить миграцию, то опция null: false вызовет ошибку и миграция не пройдет изза того, что значение поля user_id не может быть пустым, но у уже ранее созданных записей оно пустое, а в прдакшене удалить существующие записи - не очень тема, потому, чтобы миграция прошла нужно будет обойти это при помощи временного значения по умолчанию:
    # default: User.first.id - поставит в старые записи в колонку user_id вместо NULL дефолтное значение с айди этого юзера (мб придумать специального юзера для этого, например с именем "Аноним")
  end
end


# Теперь удалим временное значения User.first.id из полей user_id при помощи еще одной миграции
# > rails g migration remove_default_user_id_from_questions_answers
class RemoveDefaultUserIdFromQuestionsAnswers < ActiveRecord::Migration[6.1]
  # В миграции заменим метод change на методы up и down:

  def up # этот метод вызывается при применении миграции  > rails db:migrate
    change_column_default :questions, :user_id, from: User.first.id, to: nil
    # from: User.first.id, to: nil - не обязательно(но не лишне) писать это при использовании методов up и down
    change_column_default :answers, :user_id, from: User.first.id, to: nil
    # Тоесть когда мы применим данную миграцию, мы заменим значения User.first.id в user_id в таблицах на пустое
  end

  def down # этот метод вызывается при откате миграции  > rails db:rollback
    change_column_default :questions, :user_id, from: nil, to: User.first.id
    # from: nil, to: User.first.id - не обязательно(но не лишне) писать это при использовании методов up и down
    change_column_default :answers, :user_id, from: nil, to: User.first.id
    # Тоесть когда мы откатим данную миграцию, мы обратно заполним значением User.first.id пустые значения user_id в таблицах
  end

  # Все тоже самое можно было бы сделать и используя метод change, но тогда писать from: User.first.id, to: nil обязательно иначе будет неоткатываемо
end



puts '                     Изменения таблиц с кодом переноса данных прямо в миграции'

# Старая таблица из схемы, которую нужно разбить по полю `category_type`, оно `enum` и на основе категорий таблица содежит в себе какбы подраблицы "обособленные" по значению этого поля 
create_table "dictionaries", force: :cascade do |t|
  t.bigint "cabinet_id", null: false
  t.string "value", null: false
  t.integer "category_type", null: false
  t.string "author_type", null: false
  t.bigint "author_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["author_type", "author_id"], name: "index_dictionaries_on_author"
  t.index ["cabinet_id"], name: "index_dictionaries_on_cabinet_id"
  t.index ["value", "cabinet_id", "category_type"], name: "index_dictionaries_on_value_cabinet_and_category"
end

# Создание новых таблиц (миграции)
class SplitDictionaryTables < ActiveRecord::Migration[8.0]
  def change
    # 1. Создаем новые отдельные таблицы для каждого типа значений из поля `category_type` старой таблицы
    create_table :category_dictionaries do |t|
      t.bigint :cabinet_id, null: false
      t.string :value, null: false
      t.string :author_type, null: false
      t.bigint :author_id, null: false
      t.timestamps
      t.index ["cabinet_id"], name: "index_category_dictionaries_on_cabinet_id"
      t.index ["author_type", "author_id"], name: "index_category_dictionaries_on_author"
    end

    create_table :status_dictionaries do |t|
      # аналогичная структура
    end

    create_table :provider_dictionaries do |t|
      # аналогичная структура
    end

    create_table :status_value_dictionaries do |t|
      # аналогичная структура
    end

    # 2. Перенос данных из dictionaries в новые таблицы
    Dictionary.where(category_type: :category).find_each do |dict|
      CategoryDictionary.create!(dict.attributes.except('id', 'category_type'))
    end
    # Повторить для других типов...

    # 3. Обновляем внешние ключи в связанных таблицах
    change_table :barcodes do |t|
      t.rename :category_id, :category_dictionary_id
      t.rename :status_value_id, :status_value_dictionary_id
    end

    change_table :products do |t|
      t.rename :status_id, :status_dictionary_id
    end

    # 4. Удаляем старую таблицу (после проверки данных)
    drop_table :dictionaries
  end
end



puts '                           Правильный синтаксис для связей в миграции'

# Вариант 1 (отдельными полями):
def change
  create_table :category_dictionaries do |t|
    t.bigint :cabinet_id, null: false
    t.string :value, null: false
    t.string :author_type, null: false
    t.bigint :author_id, null: false

    t.timestamps
  end
end


# Вариант 2 (связями и внешними ключами):
def change
  create_table :category_dictionaries do |t|
    t.references :cabinet, null: false, foreign_key: true # автоматически создает индекс
    t.string :value, null: false
    t.references :author, polymorphic: true, null: false

    t.timestamps
  end
end
# Современный синтаксис: 
# Использование t.references вместо ручного указания bigint
# Автоматическое добавление _id к именам полей
# Явное указание foreign_key: true для связей


# Для полиморфных связей предпочтительно:
t.references :author, polymorphic: true, null: false
# вместо
t.string :author_type
t.bigint :author_id


# Foreign keys лучше добавлять сразу:
t.references :cabinet, null: false, foreign_key: true
# вместо
t.bigint :cabinet_id
add_foreign_key :category_dictionaries, :cabinets



puts '                           Правильный синтаксис для индексов в миграции'

# Каким синтаксисом лучше и корректнее пользоваться при создании индексов в миграциях из тех 2х вариантов:

# Оба варианта корректны, но есть важные различия в удобстве и возможностях:


# Вариант 1 (внутри блока создания таблицы):
def change
  create_table :category_dictionaries do |t|
    t.references :cabinet, null: false, foreign_key: true
    t.references :author, polymorphic: true, null: false
    t.timestamps
    t.index ["cabinet_id"], name: "index_category_dictionaries_on_cabinet_id"
    t.index ["author_type", "author_id"], name: "index_category_dictionaries_on_author"
  end
end

# Лучше подходит для простых индексов на одно поле:
create_table :users do |t|
  t.string :email, null: false
  t.index [:email], unique: true  # Коротко и понятно
end
# Лучше, если важно явно контролировать имена индексов (?? почему это ??)


# Вариант 2 (вне блока создания таблицы) - Оптимальный выбор:
def change
  create_table :category_dictionaries do |t|
    t.references :cabinet, null: false, foreign_key: true
    t.references :author, polymorphic: true, null: false
    t.timestamps
  end
  # (на самом деле не нужно) Индекс для колонки с foreign_key: true создается автоматически
  add_index :category_dictionaries, [:cabinet_id], unique: true
  # (на самом деле не нужно) Индексы [:author_type, :author_id] создаются автоматически для полиморфных связей в современных версиях Rails. начиная с Rails 5.1, метод t.references :author, polymorphic: true по умолчанию добавляет составной индекс на поля author_type и author_id
  add_index :category_dictionaries, [:author_type, :author_id], name: "idx_category_dicts_on_author"
end

# Лучшая читаемость:
# Основная структура таблицы отделена от индексов
# Сложные индексы (вроде уникальных) явно видны в конце

# Автоматические имена индексов:
# Rails сам сгенерирует корректные имена (например, index_category_dictionaries_on_author_type_and_author_id)
# Можно переопределить через `name: "custom_name"` если нужно

# Гибкость:
# Для составных индексов с опциями (unique: true, where:) синтаксис вне блока чище


# Для уникальных индексов добавьте unique: true:
add_index :category_dictionaries, [:value, :cabinet_id], unique: true