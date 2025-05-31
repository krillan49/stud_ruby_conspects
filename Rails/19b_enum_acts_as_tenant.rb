puts '                                            acts_as_tenant'

# https://github.com/ErwinM/acts_as_tenant


# acts_as_tenant - это гем, механизм мультитенантности (multi-tenancy) в Rails-приложении, который помогает изолировать данные между "арендаторами" (тенантами), обычно — компаниями, организациями или пользователями

# Работает через default_scope, поэтому влияет на все запросы - это удобно, но может привести к неожиданному поведению при сложных join'ах. Лучше всегда помнить, что он влияет на запросы по умолчанию

# acts_as_tenant стоит использовать, когда есть разделение данных по организациям, клиентам или кабинетам

# Хорошо сочетается с multi-user системами


# Далее в примерах тенант - это Cabinet

# Например:
acts_as_tenant :cabinet 
# Автоматически добавляет default_scope на cabinet_id, если текущий тенант (ActsAsTenant.current_tenant) установлен
# Обеспечивает безопасность данных: пользователь видит только данные своего кабинета.
# Добавляет валидации на cabinet_id.

# Как работает:
ActsAsTenant.current_tenant = some_cabinet
# Тогда запрос:
Product.all
# будет выполнен как:
<<-SQL SELECT * FROM products WHERE cabinet_id = some_cabinet.id; SQL


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



puts '                                               enum'

# enum - перечисления (Enum) в Rails позволяет представить строковые или числовые поля как символические значения. Rails enum позволяет использовать символические названия для значений поля в базе, обычно строк или чисел.

# Формы:
enum status: { enabled: 0, disabled: 1 }             # числовой
enum :status, { sold: "Продано", return: "Возврат" } # строковый

# Предоставляет Читаемый интерфейс для базы с числовыми/строковыми значениями и Автоматические геттеры и сеттеры:
seller.enabled!     # установить статус
seller.enabled?     # проверить статус

# enum стоит использовать, когда в таблице есть поле status, role, state, kind, и оно:
# принимает ограниченное число значений;
# не нужно выносить в отдельную таблицу.


# 1. Числовой enum
class Seller < ApplicationRecord
  enum status: { enabled: 0, disabled: 1 }
end
# Если поле status в базе — integer, то:
seller = Seller.new
seller.status = :enabled
seller.enabled?                #=> true
seller.status                  #=> "enabled"
seller.status_before_type_cast #=> 0
<<-SQL SELECT * FROM sellers WHERE status = 0; SQL

# 2. Строковой enum
class Purchase < ApplicationRecord
  enum status: { sold: "Продано", return: "Возврат" }
end
# Если поле status — строка (string):
purchase = Purchase.new
purchase.status = :sold
purchase.status #=> "sold"
purchase.sold?  #=> true
<<-SQL SELECT * FROM purchases WHERE status = 'Продано'; SQL


# Что создаёт enum?
# Для enum status: { enabled: 0, disabled: 1 }, Rails добавляет:

# Сеттер/геттер:
seller.status = :enabled
seller.status  #=> "enabled"
# Предикаты:
seller.enabled? #=> true
# Скоупы:
Seller.enabled  #=> все enabled
# Переключатели:
seller.disabled! #=> статус будет :disabled


# Пример миграции для числового:
class AddStatusToSellers < ActiveRecord::Migration[7.0]
  def change
    add_column :sellers, :status, :integer, default: 0
  end
end

# Пример миграции для строчного:
add_column :purchases, :status, :string



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
