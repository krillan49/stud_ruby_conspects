puts '                                             PgHero'

# PgHero - гем для мониторинга и анализа производительности PostgreSQL БД. Он помогает быстро понять, что происходит в базе, без необходимости писать сложные SQL-запросы вручную. 

# Возможности:
# 1. Показывает медленные SQL-запросы (slow queries), которые тормозят систему
# 2. Находит неиспользуемые или дублирующиеся индексы
# 3. Проверка состояния базы - сколько соединений, нагрузка, свободное место
# 4. Визуализирует планы выполнения запросов (EXPLAIN)
# 5. История производительности — при настройке сбора статистики

# Преимущества:
# 1. Простой веб-интерфейс (можно интегрировать в Rails-приложение)
# 2. Не требует внешних сервисов — работает прямо с БД
# 3. Устанавливается как gem (gem 'pghero') или через Docker



puts '                                       Установка и настройка'

# 1. Gemfile:
gem "pghero"
# $ bundle install


# 2. routes.rb:

# Для локальной отладки
mount PgHero::Engine, at: "pghero"

# Обычно (? в продакшене ?) PgHero монтируют только в админской части или защищают через basic-auth/devise, так как он может показать чувствительную информацию (например, запросы с личными данными)
authenticate :user, ->(u) { u.admin? } do
  mount PgHero::Engine, at: "pghero"
end

# Если нужно быстро, то можно защитить basic-auth:
mount PgHero::Engine, at: "pghero", constraints: ->(req) {
  Rack::Auth::Basic.new(->(env) { [200, {}, []] }) do |username, password|
    username == "admin" && password == "secret"
  end.call(req.env)
}


# 3. Перейти в браузере по адресу:
# http://localhost:3000/pghero



puts '                                       Включение slow queries'

# PgHero использует представление PostgreSQL: pg_stat_statements


# 1. Включить расширение pg_stat_statements
# a) В config/database.yml, например:
'
development:
  adapter: postgresql
  # ...
  variables:
    shared_preload_libraries: "pg_stat_statements"
'
# b) Или активировать вручную в PostgreSQL:
'CREATE EXTENSION IF NOT EXISTS pg_stat_statements;'

# 2. Перезапустить PostgreSQL

# 3. Проверить в PgHero: открыть вкладку "Queries"



puts '                                  Настройка истории производительности'

# Можно Настроить историю производительности, чтобы видеть графики нагрузки:

# В config/schedule.rb (если используешь whenever или sidekiq-cron):
every 1.minute do
  rake "pghero:capture_query_stats"
end

# Или добавь задачу в cron:
# $ cd /path/to/app && bundle exec rake pghero:capture_query_stats



puts '                                               Индексация'

# На вкладке "Indexes" будет видно (Соответсвенно можно быстро отрефакторить):
# 1. неиспользуемые индексы
# 2. дубликаты
# 3. таблицы без PK



puts '                                        Примеры PgHero rake-задач'

# $ rake pghero:running_queries
# $ rake pghero:slow_queries
# $ rake pghero:space_stats
# $ rake pghero:reset_query_stats