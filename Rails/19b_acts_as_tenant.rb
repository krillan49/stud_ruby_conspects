puts '                                            acts_as_tenant'

# https://github.com/ErwinM/acts_as_tenant

# acts_as_tenant - гем, позволяет реализовать мультитенантность (multi-tenancy) в Rails-приложении, когда данные разных клиентов (арендаторов, "тенантов") хранятся в одной базе, но изолированы друг от друга
# Каждая запись в БД принадлежит определённому тенанту (например, компании, пользователю, организации)
# Все SQL-запросы автоматически дополняются условием `WHERE tenant_id = X`, чтобы изолировать данные
# Тенант определяется на уровне запроса (айди берется, например, из поддомена, JWT-токена или сессии)

# Работает через default_scope, поэтому влияет на все запросы - это удобно, но может привести к неожиданному поведению при сложных join'ах. Лучше всегда помнить, что он влияет на запросы по умолчанию

# acts_as_tenant стоит использовать, когда есть разделение данных по организациям, клиентам или кабинетам

# acts_as_tenant - это простое и эффективное решение для мультитенантности в Rails, когда все данные хранятся в одной БД. Он минимизирует риски смешивания данных и сокращает boilerplate-код


# Преимущества:
# Не нужно вручную добавлять where(tenant_id: ...)
# Безопасность: Невозможно случайно получить чужие данные
# Гибкость: Можно использовать разные стратегии (поддомены, токены, БД на тенанта)

# Ограничения:
# Не подходит для горизонтального масштабирования (если нужны отдельные БД для тенантов лучше использовать `apartment gem`)
# Требует аккуратной миграции при добавлении в существующее приложение


# Альтернативные решения:
# 1. Apartment                - изоляция через отдельные схемы PostgreSQL
# 2. Discard + scope          - самописная фильтрация (менее надёжно)
# 3. Физическое разделение БД - Для максимальной изоляции (но сложнее в поддержке)



puts '                                        Установка и настройка'

# Gemfile:
gem 'acts_as_tenant'
# $ bundle install

# Обычно модель для тенанта это Account, Company или Tenant:
# $ rails g model Account name:string subdomain:string
# $ rails db:migrate

# Добавление tenant_id в модели, например, для Dictionary:
# $ rails g migration AddAccountIdToDictionaries account:references
# $ rails db:migrate



puts '                               ActsAsTenant.current_tenant (Основной метод)'

# ActsAsTenant.current_tenant - это ключевой метод гема `acts_as_tenant`, который позволяет получать текущий тенант (арендатора) в рамках запроса (геттер) и устанавливать тенант для всех последующих SQL-запросов (сеттер). Не стоит использовать сеттер в ассинхронных задачах, для этого есть более безопасный метод with_tenant

# Для хранения текущего тенанта гем использует Thread-local переменную (изолированную для каждого HTTP-запроса или фоновой задачи), чтобы изолировать данные между запросами разных пользователей. Это значит:
# а) Тенант не «протекает» между запросами разных пользователей
# б) В консоли Rails или тестах нужно устанавливать его вручную

# Не используйте ActsAsTenant.current_tenant в глобальных переменных или кеше, чтобы не нарушить изоляцию

# В многопоточных средах (например, Puma) каждый поток имеет свой current_tenant


# Получение текущего тенанта если тенант установлен (например, в контроллере через `set_current_tenant`)
current_tenant = ActsAsTenant.current_tenant  #=> #<Account id: 1, subdomain: "company1", ...>

# Установка и удаление тенанта вручную
account = Account.find(1)
ActsAsTenant.current_tenant = account  # Устанавливает тенанта для текущего потока
ActsAsTenant.current_tenant = nil      # Сброс тенантаПоследующие запросы будут без фильтрации


# Все модели с `acts_as_tenant` автоматически добавляют scope `where(tenant_id: X)` к SQL-запросам, например:
class Dictionary < ApplicationRecord
  acts_as_tenant :account
  # Автоматически добавляет default_scope на account_id (тут привязку к конкретному акаунту), если текущий тенант установлен
  # Обеспечивает безопасность данных: пользователь видит только данные своего аккаунта
  # Добавляет валидации на существование account_id

  belongs_to :account # Таблицы должны содержать account_id (или другую колонку в зависимости от аргумента acts_as_tenant) 
end

# Запрос с тенантом:
ActsAsTenant.current_tenant = Account.first
# Теперь запрос с установленным тенантом будет отфильтрован и выдаст только записи текущего тенанта:
Dictionary.all #=> SELECT * FROM dictionaries WHERE account_id = 1

# Если тенант задан то айди текущего тенанта (account_id) проставится автоматически при создании
Dictionary.create(name: "Foo")

# Если current_tenant не установлен, гем выбрасывает исключение:
ActsAsTenant.current_tenant = nil
Dictionary.all #=> ActsAsTenant::Errors::NoTenantSet


# Пример использования в контроллере (стандартный сценарий)
class ApplicationController < ActionController::Base
  before_action :set_tenant

  private

  def set_tenant
    account = Account.find_by(subdomain: request.subdomain) # Установка тенанта по поддомену
    ActsAsTenant.current_tenant = account                   # Альтернатива: set_current_tenant(account)
  end
end

# Пример использования в тестах (RSpec)
before do
  @account = Account.create!(subdomain: "test")
  ActsAsTenant.current_tenant = @account               # Или set_current_tenant(@account)
end
it "filters dictionaries by tenant" do
  dict = Dictionary.create!(name: "Test")
  expect(Dictionary.count).to eq(1)                    # Только для @account
end



puts '                           without_tenant (Для запросов без фильтрации)'

# without_tenant { ... }	- отключает фильтрацию на время работы блока

# Например если current_tenant не установлен, гем выбрасывает исключение
ActsAsTenant.current_tenant = nil
Dictionary.all #=> ActsAsTenant::Errors::NoTenantSet

# Можно отключить проверку
ActsAsTenant.without_tenant do
  Dictionary.all  # Игнорирует фильтрацию, тоесть покажет все записи
end



puts '                            with_tenant (Временная установка тенанта)'

# with_tenant(tenant) { ... }	- метод временной установки тенанта, действует на время работы принимаемого блока, лучше подходит для асинхронных задач. Если нужно кешировать тенанта (например, для фоновых задач), передавайте его явно через аргументы, а не полагайтесь на current_tenant


# Пример использования в фоновых задачах (Sidekiq/Active Job) с временной установкой тенанта. 
class UpdateDictionaryJob < ApplicationJob
  queue_as :default

  def perform(account_id)
    # Вариант 1: Опасно в многопоточной среде, может быть утечка между потоками
    tenant = ActsAsTenant.current_tenant  

    # Вариант 2: Правильный подход с примененем with_tenant и блоком
    ActsAsTenant.with_tenant(Account.find(account_id)) do
      Dictionary.update_all(active: true)
    end
  end
end



puts '                                      set_current_tenant'

# set_current_tenant(tenant) - метод выполняет ту же функцию, что и `ActsAsTenant.current_tenant = tenant` но он безопаснее, и интегрирован с фильтрами контроллеров. Это просто обёртка вокруг `current_tenant=` с дополнительной логикой, которая по умолчанию запрещает установку пустого значения (ActsAsTenant.current_tenant = nil):
def set_current_tenant(tenant, require_tenant: true)
  # require_tenant: true  - дополнительная опция, если передать false то будет работать как current_tenant=
  if tenant.nil? && require_tenant
    raise NoTenantSet, "Тенант не может быть nil!"
  end
  ActsAsTenant.current_tenant = tenant
end

# Дает одинаковый результат с ActsAsTenant.current_tenant=
set_current_tenant(Account.find(1))
Dictionary.all #=> SELECT * FROM dictionaries WHERE account_id = 1

# Но set_current_tenant по умолчанию запрещает nil, но можно разрешить nil через опцию:
set_current_tenant(nil)                           # Сразу ошибка ActsAsTenant::Errors::NoTenantSet
set_current_tenant(nil, require_tenant: false)    # OK
# При этом без set_current_tenant-обертки было бы
ActsAsTenant.current_tenant = nil  # присваивание сработало
Dictionary.all                     # но тут выбросит ошибку: NoTenantSet 


# Когда что использовать?

# ActsAsTenant.current_tenant =
# В тестах или консоли, если нужен прямой контроль
# При отладке, чтобы быстро сбросить тенанта (= nil)

# set_current_tenant
# В контроллерах, особенно с `set_current_tenant_through_filter` и фильтрами
# Когда важна безопасность (например, запрет nil по умолчанию)
# Для явной передачи опций (например, require_tenant: false)

# В тестах можно использовать и set_current_tenant:
describe "Dictionary" do
  before do 
    account = create(:account)
    set_current_tenant(account)
  end
  it { expect(Dictionary.all.to_sql).to include("WHERE account_id = 1") }
end



puts '                                    Применение в контроллере'

# set_current_tenant_through_filter - метод гема `acts_as_tenant` позволяет задать стратегию определения текущего тенанта через before-фильтр в контроллере. Удобно, когда тенант определяется динамически - по поддомену, JWT-токену, параметру запроса итд

# set_current_tenant_by_subdomain - альтернативный метод гема `acts_as_tenant`, позволяет сократить код, если тенант определяется только по поддомену


# Тенант обычно устанавливается в контроллере ApplicationController и/или подключенном в него консерне, чтобы применить ко всем наследникам:
class ApplicationController < ActionController::Base
  # Вариант 1 (только при определении по поддомену):
  set_current_tenant_by_subdomain(:account, :subdomain)
  # Это эквивалентно:
  def set_tenant
    set_current_tenant(Account.find_by(subdomain: request.subdomain))
  end

  # Вариант 2 (общий вариант с установкой вручную):
  set_current_tenant_through_filter  # Включает механизм
  before_action :set_tenant          # Запускает фильтр, который устанавливает тенант

  private

  # Фильтр в котором задаётся логика выбора тенанта
  def set_tenant
    # Вариант 2-1: Из сессии (если используется аутентификация)
    current_account = Account.find_by(id: session[:account_id])

    # Вариант 2-2: По поддомену
    current_account = Account.find_by(subdomain: request.subdomain)

    # Вариант 2-3: Через токен в API
    token = request.headers['Authorization']&.split(' ')&.last
    current_account = Account.find_by(api_key: token)

    # Устанавливаем текущий тенант
    set_current_tenant(current_account) if current_account
    # if current_account - стоит добавить такое условие, тк если set_tenant не найдёт тенант (например, current_account = nil), то все запросы к моделям с `acts_as_tenant` завершатся ошибкой
  end
end
# Гем запоминает текущий тенант в Thread-local переменной (изолировано для каждого запроса)
# Теперь все модели с `acts_as_tenant` автоматически добавляют условие `WHERE account_id = X` в SQL-запросы


# Модель-тенант
class Account < ApplicationRecord
  has_many :dictionaryes
end


# Модель в которой применяется тенант
class Dictionary < ApplicationRecord
  acts_as_tenant :account  # Указывает, что эта модель принадлежит тенанту
  # Автоматически добавляет default_scope на account_id (тут привязку к конкретному акаунту), если текущий тенант установлен
  # Обеспечивает безопасность данных: пользователь видит только данные своего аккаунта
  # Добавляет валидации на account_id

  belongs_to :account # Таблицы должны содержать account_id (или другую колонку в зависимости от аргумента acts_as_tenant)
end
# Теперь все запросы к моделям с acts_as_tenant автоматически фильтруются (дополняются условием):
Dictionary.all #=>
<<-SQL SELECT * FROM dictionaries WHERE account_id = 123; SQL


# Без установленного тенанта — выдаст ошибку!
Dictionary.all #=> ActsAsTenant::Errors::NoTenantSet

# С установленным тенантом
Dictionary.create(name: "Test")     # В поле account_id автоматически пропишется current_account.id
Dictionary.all                      # Показывает только записи текущего тенанта, тоесть account_id = current_account.id

# Можно отключить фильтрацию, если нужно получить все записи (например, в админке):
ActsAsTenant.without_tenant do
  Dictionary.all  # Игнорирует фильтрацию, тоесть покажет все записи
end

# Тестирование. В тестах нужно явно устанавливать тенант:
before do
  @account = Account.create!(subdomain: 'test')
  set_current_tenant(@account)
end



puts '                          Пример: мультитенантное приложение с поддоменами'

# routes.rb
Rails.application.routes.draw do
  constraints subdomain: /.*/ do
    resources :dictionaries
  end
end

# Контроллер
class DictionariesController < ApplicationController
  # Фильтр объявлен в ApplicationController

  def index
    @dictionaries = Dictionary.all # Запрос будет выполнен только для текущего поддомена
    # Запрос к company1.example.com/dictionaries покажет только словари для company1
  end
end
