puts '                                         Миграции(AR)'

# (!! Сопоставить с инфой про миграции из basic_MCV_generate)

# https://api.rubyonrails.org/classes/ActiveRecord/Migration.html

# миграции - это классы, которые меняют чтото в базе данных

# Миграции это временные файлы для одноразового запуска, чтобы данные не терять локально. Где-то на проектах их могут удалять например после 30 дней. Если в отпуск на месяц ушел, то уже не догонишь, из схемы будешь восстанавливаться

# Если базе создать какую-нибудь таблицу, например в SQL редакторе или отредактировать столбец в существующей, а потом сделать "rake db:migrate" или "rails app:update" то изменения должны записаться в схему и обновится там structure.sql, schema.db итд.
# Укого-то стронний скрипт вместо миграций ходит в базу и создаёт там таблички независимо от rails приложения, если запустить db:migrate, то таблички появятся в схеме.

# Начиная с Rails 6 появился "db:prepare", который при отсутcвии БД сделает "db:setup" а если база есть то "db:migrate". Это есть в файле "bin/setup"
# В Rails 8 это добавлено еще в docker-entrypoint

# А у kamal в Dockerfile есть строчка ENTRYPOINT ["/rails/bin/docker-entrypoint"]  которая как раз в последствии вызовет "./bin/rails db:prepare" при первой сборке контейнера, которая вызывается командой "kamal setup"
# Если есть миграции которых нет в схеме, он сначала обновит схему а потом создаст бд, вроде db:setup так работает

# Миграции важны, только на проде. Чтобы прод подстраивался постоянно и данные не терялись поэтому там миграция вперед, назад


# sqlite хранит всё в одиночном файле формата .sqlite

# rails g migration - генератор миграции, который создает миграцию без модели.

# Запуск миграции с правильным синтаксисом, с версиями гемов из гемфаила:
# > bundle exec rake db:migrate

# Удаляет базу данных, создаёт новую базу данных, затем выполнит все миграции, которые находятся в вашем проекте(в данной ветке). Если есть файлы seeds (например, `db/seeds.rb`), то исполнит их:
# $ rails db:reset



puts '                                 Ассоциации при создании таблицы'

# references - алиас к belongs_to, создает столбец name_id являющийся foreign_key к id поля в другой таблице
t.references :article, null: false, foreign_key: true # Создает столбец article_id являющийся foreign_key к id поля той статьи к которой относится коммент в таблице articles.

# belongs_to - алиас к references, создает столбец name_id являющийся foreign_key к id поля в другой таблице
t.belongs_to :article, null: false, foreign_key: true  # в таблице укажет так если генерировали при помощи belongs_to

# МБ belongs_to лучше использовать для связи 1 - * (сущности разных моделей), а references для таблиц одной сущности при нормализации (1 - 1) ??



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














#
