puts '                         Запросы вставки и обновления париями вместо одиночных'

# https://www.postgresql.org/docs/current/sql-merge.html

# Имеет смысл вставлять записи батчами, что значительно улучшит производительность по сравнению с вставкой по одной записи. Использование в сочетании с массивами позволяет значительно ускорить процесс.

# Рельсы уже предоставляют из коробки методы insert_all и upsert_all для этого.

# Если нужно обновлять существующие записи или выполнять более сложные операции вставки/обновления (с условием?), можно использовать SQL-оператор MERGE (или эквивалентный ON CONFLICT для PostgreSQL), который позволяет вставлять или обновлять записи в одном запросе



puts '                                      insert_all и upsert_all'

# https://api.rubyonrails.org/classes/ActiveRecord/Relation.html#method-i-insert_all

# insert_all и upsert_all - методы, которые добавлены в добавленный в ActiveRecord 6.0. Это стандартные и эффективные способы для массовой вставки и оновления записей в Rails, и они подходят для большинства сценариев.

# Поддерживаемые СУБД только: PostgreSQL, SQLite, MySQL 8+ (Старые версии MySQL и другие базы не поддерживают). При этом в PostgreSQL наиболее мощная и полная поддержка этих фич.

# Оба метода не запускают валидации или callbacks

# Метод       Вставка  Обновление при конфликте  Использует callbacks/валидации
# create        да                нет                         да
# insert_all    да                нет                         нет
# upsert_all    да                да                          нет



puts '                                             insert_all'

# insert_all - метод позволяет вставить (только вставить, а не обновить) много записей за один SQL-запрос, минуя обычные валидации, callbacks и другие хуки. Очень быстрый способ загрузить много данных (например, из Excel или API)

# insert_all принимает массив хэшей, где каждый хэш это запись для вставки
# Все хэши должны содержать одинаковые ключи
Purchase.insert_all([
  { quantity: 10, purchase_date: Date.today },
  { quantity: 20, purchase_date: Date.today + 1 }
])
# Это создаст две записи в таблице purchases одним SQL-запросом, без вызова `Purchase.create`

# Особенности:
# а) Не создает Ruby-объекты, а напрямую пишет в базу
# б) Использует нативный SQL (в PostgreSQL — INSERT INTO ... VALUES ...)
# в) Нет логики "обновить, если уже существует". Только попытка вставки
# г) Если одна из записей конфликтует с уникальным индексом - вся операция может упасть с ошибкой (в отличие от upsert_all, который умеет обрабатывать конфликты)
# е) Не вызывает валидации, before_create, after_create, итд

# Нужно вручную задавать поля created_at и updated_at, если они нужны:
now = Time.current
Purchase.insert_all([
  { quantity: 5, created_at: now, updated_at: now },
  { quantity: 10, created_at: now, updated_at: now }
])

# Когда не стоит использовать insert_all:
# Когда нужны валидации, транзакции по каждой записи, колбэки или бизнес-логика (after_create, before_save, итд)
# Когда записи содержат ассоциации, вложенные модели или файлы (ActiveStorage, has_many, итд)


# SQL-запросы, которые ActiveRecord генерирует при использовании insert_all в PostgreSQL:
Purchase.insert_all([
  { barcode_id: 1, quantity: 10, created_at: Time.current, updated_at: Time.current },
  { barcode_id: 2, quantity: 20, created_at: Time.current, updated_at: Time.current }
])
# SQL, который сгенерирует Rails (PostgreSQL) это один простой INSERT INTO ... VALUES ... без обработки конфликтов (будет ошибка, если нарушен уникальный индекс):
<<-SQL
INSERT INTO "purchases" ("barcode_id", "quantity", "created_at", "updated_at")
VALUES
  (1, 10, '2025-05-21 12:00:00', '2025-05-21 12:00:00'),
  (2, 20, '2025-05-21 12:00:00', '2025-05-21 12:00:00')
SQL



puts '                                           upsert_all'

# upsert_all - метод позволяет вставлять или обновлять сразу много записей отправляя один SQL-запрос, а не по одной (.update в цикле), используя механизм PostgreSQL ON CONFLICT, что в десятки и сотни раз быстрее при большом объеме данных. Работает так же как и insert_all, но с логикой: "если есть конфликт по уникальному ключу то обнови":
# а) Если записи не существуют (по уникальному ключу) - они будут вставлены
# б) Если записи уже существуют                       - они будут обновлены

# Синтаксис:
Model.upsert_all(array_of_hashes, unique_by: :index_or_column, update_only: [:fields])
# array_of_hashes - список данных, массив хэшей как в insert_all
# unique_by:      - указывает, по какому индексу/ключу определять конфликт. Принимает символ, например :id или имя уникального индекса, например :index_users_on_email
# update_only:    - список колонок, которые разрешено обновлять при конфликте (опционально)

# Особенности:
# Нужен уникальный индекс по полю, указанному в unique_by
# Если не указать unique_by:, ActiveRecord попытается сам найти уникальный индекс (может не сработать, если их несколько)
# При upsert_all Rails не обновляет created_at, а только updated_at (и только если его явно передавать)

# Пример
Purchase.upsert_all([
  { id: 1, quantity: 10, updated_at: Time.current },
  { id: 2, quantity: 20, updated_at: Time.current }
], unique_by: :id)
# Если записи с ID 1 и 2 уже существуют - они будут обновлены. Если нет - будут созданы


# SQL-запросы, которые ActiveRecord генерирует при использовании upsert_all в PostgreSQL:
Purchase.upsert_all([
  { barcode_id: 1, quantity: 15, updated_at: Time.current },
  { barcode_id: 2, quantity: 25, updated_at: Time.current }
], unique_by: :index_purchases_on_barcode_id) # допустим, есть уникальный индекс index_purchases_on_barcode_id.
# SQL, который сгенерирует Rails (PostgreSQL) будет использовать ON CONFLICT ... DO UPDATE. Обновляются только поля, указанные в хэшах:
<<-SQL
INSERT INTO "purchases" ("barcode_id", "quantity", "updated_at")
VALUES
  (1, 15, '2025-05-21 12:00:00'),
  (2, 25, '2025-05-21 12:00:00')
ON CONFLICT ON CONSTRAINT index_purchases_on_barcode_id
DO UPDATE SET
  "quantity" = EXCLUDED."quantity",
  "updated_at" = EXCLUDED."updated_at"
SQL
# EXCLUDED                                - псевдоним вставляемых значений (PostgreSQL синтаксис)
# EXCLUDED.quantity и EXCLUDED.updated_at - значения, которые мы пытались вставить
# Остальные поля (например, created_at) не обновятся, если не указаны в хэшах


# SQL-запрос, который ActiveRecord сгенерирует для upsert_all, если используется составной уникальный индекс. Например есть таблица purchases, и в ней составной уникальный индекс:
add_index :purchases, [:barcode_id, :purchase_date], unique: true, name: "index_purchases_on_barcode_and_date"
# Запрос:
Purchase.upsert_all(
  [
    { barcode_id: 1, purchase_date: Date.new(2025, 5, 21), quantity: 10, updated_at: Time.current },
    { barcode_id: 2, purchase_date: Date.new(2025, 5, 21), quantity: 20, updated_at: Time.current }
  ],
  unique_by: :index_purchases_on_barcode_and_date
) # :unique_by - это имя уникального индекса, а не просто массив колонок
# SQL (PostgreSQL):
<<-SQL
INSERT INTO "purchases" ("barcode_id", "purchase_date", "quantity", "updated_at")
VALUES
  (1, '2025-05-21', 10, '2025-05-21 12:00:00'),
  (2, '2025-05-21', 20, '2025-05-21 12:00:00')
ON CONFLICT ON CONSTRAINT index_purchases_on_barcode_and_date
DO UPDATE SET
  "quantity" = EXCLUDED."quantity",
  "updated_at" = EXCLUDED."updated_at"
SQL
# ON CONFLICT ON CONSTRAINT index_purchases_on_barcode_and_date - говорит PostgreSQL: если при вставке нарушается этот уникальный индекс - выполняй DO UPDATE

# Если вместо имени индекса написать массив колонок (как unique_by: %i[barcode_id purchase_date]), то ActiveRecord тоже сгенерирует валидный SQL, но:
# Он найдет подходящий индекс сам (если сможет)
# Если нет уникального индекса по этим полям — будет исключение:
# ArgumentError: Could not infer a unique index for :barcode_id and :purchase_date
# Поэтому надежнее указывать unique_by: :index_name