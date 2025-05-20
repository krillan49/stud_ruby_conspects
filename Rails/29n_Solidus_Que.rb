puts '                                              Solidus Que'

# Solidus Que - это комбинация фреймворка Solidus (e-commerce на Rails) и очереди задач Que, адаптированной как ActiveJob-адаптер

# Que — это фоновая очередь заданий для Ruby (альтернатива Sidekiq), использующая PostgreSQL как backend. Она надежная, быстрая и с минимальными внешними зависимостями - идеальный выбор, если ты не хочешь тянуть Redis

# Работает только с PostgreSQL

# Преимущества Que:
# 1. Использует PostgreSQL, не требует Redis
# 2. Перезапускает сбойные задачи
# 3. Хорошо масштабируется (поддерживает шардирование и worker-пулы)
# 4. Позволяет смотреть задачи прямо через SQL или веб-интерфейс
# 5. Простой и надежный
# 6. Хорошая интеграция с Rails и Solidus



puts '                                          Установка и настройка'

# 1. Установи гемы в Gemfile:
gem 'que'           # que         - сам адаптер очередей
gem 'que-rails'     # que-rails   - интеграция Que с Rails
gem 'solidus_que'   # solidus_que - адаптер Que для Solidus (опционально, если ты работаешь в Solidus-экосистеме и соотв используешь Solidus)
# $ bundle install

# 2. Сгенерируй миграции Que. Это создаст таблицу que_jobs в PostgreSQL, куда будут записываться задания:
# $ rails generate que:install
# $ rails db:migrate

# 3. Настрой ActiveJob
# В config/application.rb:
config.active_job.queue_adapter = :que



puts '                                           Запуск и другие команды'

# Посмотреть задания:
# $ bin/rails solid_queue:list

# Удалить старые:
# $ bin/rails solid_queue:prune


# Требует явного запуска worker'а

# Нужно запускать отдельный worker-процесс:
# $ bundle exec que ./config/environment.rb

# Можно добавить solid_queue в Procfile.dev:
web: bin/rails server
worker: bin/rails solid_queue:work

# Или добавить в Procfile для Heroku/Foreman:
worker: bundle exec que ./config/environment.rb




# Посмотреть задания:
# $ bin/rails solid_queue:list

# Удалить старые:
# $ bin/rails solid_queue:prune



puts '                                           Пример использования'

# Как работает solid_queue?
# Это новый встроенный фоновый адаптер в Rails, не требующий сторонних сервисов (всё на ActiveRecord)

# app/jobs/hard_worker_job.rb
class HardWorkerJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    puts "Sending email to #{user.email}"
    # your long-running logic here
  end
end

# Запуск джоба:
HardWorkerJob.perform_later(42)



puts '                                             Пример с Solidus'

# Если у тебя стоит solidus_que, то ты можешь работать с ActiveJob, и Solidus будет использовать Que под капотом для любых фоновых задач:

# пример из ecommerce-приложения
class SendOrderConfirmationJob < ApplicationJob
  queue_as :mailers

  def perform(order_id)
    order = Spree::Order.find(order_id)
    OrderMailer.confirmation(order).deliver_now
  end
end



puts '                                            Мониторинг и отладка'

# Ты можешь видеть и управлять заданиями напрямую из базы данных PostgreSQL:
SELECT * FROM que_jobs;

# Также есть UI-решения, например, que-web — простой веб-интерфейс:
# в Gemfile
gem 'que-web'
# И в routes.rb:
mount Que::Web, at: "/jobs"

  