puts '                                            acts_as_tenant'

# https://github.com/ErwinM/acts_as_tenant

# acts_as_tenant - гем, позволяет реализовать мультитенантность (multi-tenancy) в Rails-приложении, когда данные разных клиентов (арендаторов, "тенантов") хранятся в одной базе, но изолированы друг от друга
# Каждая запись в базе данных принадлежит определённому тенанту (например, компании, пользователю, организации)
# Все SQL-запросы автоматически дополняются условием `WHERE tenant_id = X`, чтобы изолировать данные
# Тенант определяется на уровне запроса (например, из поддомена, JWT-токена или сессии)

# Работает через default_scope, поэтому влияет на все запросы - это удобно, но может привести к неожиданному поведению при сложных join'ах. Лучше всегда помнить, что он влияет на запросы по умолчанию

# acts_as_tenant стоит использовать, когда есть разделение данных по организациям, клиентам или кабинетам

# acts_as_tenant - это простое и эффективное решение для мультитенантности в Rails, когда все данные хранятся в одной БД. Он минимизирует риски смешивания данных и сокращает boilerplate-код


# Преимущества:
# Не нужно вручную добавлять where(tenant_id: ...)
# Безопасность: Невозможно случайно получить чужие данные
# Гибкость: Можно использовать разные стратегии (поддомены, токены, БД на тенанта).

# Ограничения:
# Не подходит для горизонтального масштабирования (если нужны отдельные БД для тенантов, см. apartment gem)
# Требует аккуратной миграции при добавлении в существующее приложение


# Альтернативы:
# 1. Apartment - изоляция через отдельные схемы PostgreSQL
# 2. Discard + scope - самописная фильтрация (менее надёжно).
# 3. Физическое разделение БД - Для максимальной изоляции (но сложнее в поддержке).



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



puts '                                          Использование'

# Тенант обычно устанавливается в ApplicationController:
class ApplicationController < ActionController::Base
  # Вариант 1:
  set_current_tenant_by_subdomain(:account, :subdomain)

  # Вариант 2 (вручную):
  before_action :set_tenant
  
  def set_tenant
    current_account = Account.find_by(id: session[:account_id])
    set_current_tenant(current_account)
  end
end


# Модель-тенант
class Account < ApplicationRecord
  has_many :dictionaryes
end


# Модель в которой применяется
class Dictionary < ApplicationRecord
  acts_as_tenant :account  # Указывает, что модель принадлежит тенанту
  # Автоматически добавляет default_scope на account_id, если текущий тенант (ActsAsTenant.current_tenant) установлен
  # Обеспечивает безопасность данных: пользователь видит только данные своего аккаунта
  # Добавляет валидации на account_id
end
# Теперь все запросы к моделям с acts_as_tenant автоматически фильтруются (дополняются условием):
Dictionary.all # в SQL будет:
<<-SQL SELECT * FROM dictionaries WHERE account_id = 123; SQL


# Без установленного тенанта — выдаст ошибку!
Dictionary.all #=> ActsAsTenant::Errors::NoTenantSet

# С установленным тенантом
current_account = Account.first
set_current_tenant(current_account)
Dictionary.create(name: "Test")     # account_id автоматически = current_account.id
Dictionary.all                      # Показывает только записи текущего тенанта

# ?? Альтернативная установка ??
ActsAsTenant.current_tenant = some_tenant_model_obj

# Отключение фильтрации, если нужно получить все записи (например, в админке):
ActsAsTenant.without_tenant do
  Dictionary.all  # Игнорирует фильтрацию
end



puts '                                               Пример'

# Далее в примере тенант - это Cabinet

# Наример есть несколько кабинетов (Cabinet), и каждый должен видеть только свои продукты (Product), штрихкоды (Barcode), словари (Dictionary)

# В модели:
class Product < ApplicationRecord
  acts_as_tenant :cabinet
end
# Это добавляет:
# 1. default_scope, тут привязку к конкретному кабинету
Product.all #=> SELECT * FROM products WHERE cabinet_id = current_tenant.id
# 2. Валидацию, что cabinet_id установлен.

# Помогает при создании записей:
# Если задан
ActsAsTenant.current_tenant = cabinet
# то при 
Product.create(name: "Foo") #— cabinet_id проставится автоматически.


# Как использовать?
ActsAsTenant.current_tenant = Cabinet.find(1)

Product.create(name: "Шапка") # Теперь Rails сам добавит cabinet_id = 1

# Можно так же задать временно:
ActsAsTenant.with_tenant(Cabinet.find(1)) do
  Product.create(name: "Футболка")
end

# Таблицы должны содержать cabinet_id (или другую колонку в зависимости от аргумента acts_as_tenant)



puts '                                       Пример: SaaS-приложение'

# Допустим, есть приложение, где:
# Каждая компария (Account) имеет своих пользователей (User) и словари (Dictionary)
# Данные изолированы по account_id


# Модели
class Account < ApplicationRecord
  has_many :users
  has_many :dictionaries
end

class User < ApplicationRecord
  acts_as_tenant :account
end

class Dictionary < ApplicationRecord
  acts_as_tenant :account
  enum :category_type, %i[category status provider status_value]
end


# Контроллер
class DictionariesController < ApplicationController
  before_action :set_tenant

  def index
    @dictionaries = Dictionary.all  # Только для текущего account_id
  end

  private
  
  def set_tenant
    set_current_tenant(current_user.account)  # Например, из Devise
  end
end



puts '                                        acts_as_tenant + enum'

# Если модель с acts_as_tenant и enum, всё работает в комплексе:
class Dictionary < ApplicationRecord
  acts_as_tenant :cabinet
  enum :category_type, %i[category status provider status_value]
end

ActsAsTenant.current_tenant = cabinet

Dictionary.create!(
  value: "Nike",
  category_type: :provider,
  author: current_seller
)
# Rails сам подставит cabinet_id, и сохранит category_type = 2, если :provider — третий в списке
