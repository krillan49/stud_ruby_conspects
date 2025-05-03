puts '                                             Sidekiq'

# https://github.com/sidekiq/sidekiq
# https://github.com/sidekiq/sidekiq/wiki/Getting-Started

# sidekiq - позволяет создавать задачи в фоновом режиме как для Рэилс(через ActiveJob - есть раздел в описании сайдкика), так и без него. (есть как бесплатная так и энтерпрайз версии)


# 1. Установка:

# Gemfile:
gem 'sidekiq', '~> 7'
# > bundle i

# Для работы sidekiq необходим Redis который sidekiq использует для храниения информации о задачах.

# https://redis.io/download/   -  На *nix-системах просто устанавливаем с офф сайта

# Но на виндоус redis новых версий больше не поддерживается, так что нужно использовать альтернативное решение Memurai, которое полностью повторяет API Редиса
# https://www.memurai.com/get-memurai - бесплатно скачать можно только Developer Edition, тоесть в продакшн нормально поддерживать не получится и нужно рестартить каждые 10 дней (имеется ввиду сервер рестарт ??), полноценная версия платная
# https://docs.memurai.com/en/installation.html  -  как установить

# После того как мы установили redis/memurai, Сайдкик по умолчанию к нему подключится
# localhost:6379  - порт локалхоста по которому будет работать Редис по умолчанию
# https://github.com/sidekiq/sidekiq/wiki/Using-Redis   - описание как подключтиться по другому порту и еще всякое


# 2. Настройка:

# Создадим конфигурацию для Сайдкика config/sidekiq.yml (код там)

# Далее нужно явно сказать Рэилс, какой адаптер будет использоваться ActiveJob-ом
# https://github.com/sidekiq/sidekiq/wiki/Active-Job - копируем отсюда строку и помещаем в config/application.rb:
class Application < Rails::Application
  # ...
  config.active_job.queue_adapter = :sidekiq
end


# 3. Запуск:

# Запускать sidekiq нужно в отдельном окне командной строки в директории проекта, тк sidekiq запускает как бы свой сервер и идет свой отладочный вывод
# > bundle exec sidekiq -q default

# Так же если нужно можно запускать sidekiq одновременно с сервером Рэилс (соответсвенно и вывод будет и для Рэилс и для Сайдкик в одной консоли) - для этого добавим строку с воркером в Procfile.dev (в нем располагаются инструкции запуска через bin/dev):
# worker: bundle exec sidekiq -q default



puts '                                Sidekiq для отправки письма сброса пароля'

# Письма можно отправлять в бэкграунде, в фоновом режиме, например при помощи метода deliver_later, как мы делали в контроллере PasswordResetsController (malers).

# Проверим будет ли приходить письмо с настройками сброса пароля (mailers) в фоновом режиме:
PasswordResetMailer.with(user: @user).reset_email.deliver_later
# Когда в password_resets_controller.rb используем метод deliver_later и если есть адаптер для выполнения задач в фоновом режиме, тогда эта задача будет передана адаптеру и задача будет выполнена в бэкграунде

# Когда сервер Рэилс отправляет письмо, отладочный вывод Сайдкика показывает, что использует ActionMailer, задачу с ее айди, адаптер, мэйлер, метод мэйлера и метод задачи и параметры:
# INFO: Performing ActionMailer::MailDeliveryJob (Job ID: 3d08abae-0c6f-4635-8239-f979ca856b2e) from Sidekiq(default) enqueued at 2024-02-04T12:57:51Z with arguments: "PasswordResetMailer", "reset_email", "deliver_now", {:params=>{:user=>#<GlobalID:0x000002a28cffa7e0 @uri=#<URI::GID gid://ask-it/User/7>>}, :args=>[]}

# А в консоли Рэилс будет:
# [ActiveJob] Enqueued ActionMailer::MailDeliveryJob (Job ID: 3d08abae-0c6f-4635-8239-f979ca856b2e) to Sidekiq(default) with arguments: "PasswordResetMailer", "reset_email", "deliver_now", {:params=>{:user=>#<GlobalID:0x000001dd77e2d4b0 @uri=#<URI::GID gid://ask-it/User/7>>}, :args=>[]}

# Это говорит о том что сервер поставил в очередь задачу на выполнение и эта задача будет выполняться в фоновом режиме



puts '                             sidekiq/web интерфейс для отслеживания задач'

# В routes.rb настроим маршрут для интерфейса отслеживания задач в нашем приложении, так же ограничим его только для администратора при помощи констрейнта

# (Весь код далее из routes.rb)

require 'sidekiq/web' # подключаем сайдкик-веб

# Для того чтобы ограничить интерфейс только для администратора, добавим констрэйт(класс ограничения)
class AdminConstraint
  def matches?(request) # обязательно должен быть этот метод
    # request - это тот запрос, который был отправлен на маршрут (тут '/sidekiq'), он перенаправляется сюда на проверку(тк тело запроса содержит данные о сессии и куки), чтобы мы поняли от кого пришел запрос
    user_id = request.session[:user_id] || request.cookie_jar.encrypted[:user_id] # возьмем user_id либо из сессии, либо из зашифрованного куки, если пользователь поставил галочку запомнить его
    # request.session[:user_id]              - находим в теле запрса данные сессии и в них айди пользователя
    # request.cookie_jar.encrypted[:user_id] - находим в теле запрса зашифрованный куки, но просто обратиться к нему не получится, поэтому нужно дополнительно применить метод cookie_jar
    # cookie_jar - берется из модуля (?)АктивДиспатч, этот модуль доступен в маршрутах потому дешифровка куки будет автоматической
    User.find_by(id: user_id)&.admin_role? # ищем пользователя по айди и проверяем админ ли это
    # Либо пускаем этого пользователя по этому маршруту либо нет, в зависимости от того что вернет метод.
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
  # mount  - метод монтирует маршрут на основе параметров
  # Sidekiq::Web => '/sidekiq'  - выбираем адрес по которому в приложении будет доступен Sidekiq::Web, тоесть мы подключаем интерфейс Сайдкика по данному адресу на нашем сайте.
  # constraints: AdminConstraint.new - опция для обращения к проверке констрэйтом, чтобы разрешить этот маршрут только админу

  # ...
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    # ...
    namespace :admin, constraints: AdminConstraint.new do
      # constraints: AdminConstraint.new - можно использовать тот же ограничитель, чтоб дополнительно ограничить пространсво имен маршрутов админа
      resources :users, only: %i[index create edit update destroy]
    end
    # ...
  end
end

# Далее открываем приложение по адресу 'http://localhost:3000/sidekiq' и видем подробную статистику по задачам и действиями с ними со всякими менюшками и графиками












#
