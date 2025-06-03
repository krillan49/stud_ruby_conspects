puts '                                          optional: true'

# optional: true - без этой опции Rails будет валидировать наличие категории при сохранении товара (вызовет ошибку, если category_id пуст). С опцией товар может быть без категории

# product_category.rb
class ProductCategory < ApplicationRecord
  has_many :products  # Категория может включать несколько продуктов
end

# product.rb
class Product < ApplicationRecord
  belongs_to :product_category, optional: true # Категория продукта
end
# optional: true   - товар может существовать без категории (внешний ключ category_id может быть NULL)

# С этой опцией товар может быть без категории:
Product.create(name: "Безымянный товар", category_id: nil)  # OK


# Если нужно разрешить nil только в некоторых случаях:
class Product < ApplicationRecord
  belongs_to :product_category
  validates :product_category, presence: true, unless: :draft?

  def draft?
    status == "draft"
  end
end



puts '                                     Ассоциация с переименованием'

# Есть связь 1 ко многим с переименованием хелпера связи для одной из моделей

# product_category.rb
class ProductCategory < ApplicationRecord
  has_many :products  # Категория может включать несколько продуктов
end

# product.rb
class Product < ApplicationRecord
  belongs_to :category, class_name: "ProductCategory" # Категория продукта
end

# belongs_to :category          - устанавливает принадлежность товара к category  и создает одноименные хелперы
# class_name: "ProductCategory" - явно указывает, что связь устанавливается с моделью ProductCategory, иначе Rails искал бы модель Category при использовании product.category

product = Product.find(1)
product.category                  #=> Возвращает связанную категорию (ProductCategory или nil)
product.category = some_category  # Установить категорию

# Пример SQL-запроса:
<<-SQL SELECT * FROM product_categories WHERE id = [product.category_id]; SQL

# Схема базы данных:
# product_categories: id, name, created_at, updated_at
# products: id, category_id, name, price, ..., created_at, updated_at

# Внешний ключ называется category_id, а не product_category_id
# По соглашению Rails, когда объявляется связь, внешний ключ называется по имени связи (тут category_id), независимо от имени связанной таблицы и модели. Это часть "магии" Convention over Configuration

# Явное указание: Если нужно использовать другое имя для ключа, но с измененным хэлпером (например, product_category_id), это можно было бы указать явно:
belongs_to :category, class_name: "ProductCategory", foreign_key: "product_category_id"


# Примеры использования
category = ProductCategory.create!(name: "Электроника")           # Создаём категорию

product = category.products.create!(name: "Ноутбук", price: 1000)           # Добавляем в неё товар, вариант1
product = Product.create!(name: "Смартфон", price: 500, category: category) # Добавляем в неё товар, вариант1

ProductCategory.find_by(name: "Электроника").products # Все товары категории "Электроника"
Product.find_by(name: "Ноутбук").category             # Категория товара "Ноутбук"



puts '                             scoped association / фильтр для ассоциации'

# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#method-i-belongs_to

# scoped association - ассоциация со scope(условием) через лямбду (?? только тут через лямбду или вообще ??). Это частный случай ассоциации с class_name и scope. Подход с scope — корректный и idiomatic для Rails. 

# Тут и далее рассмотрен случай, когда одна таблица играет роль нескольких сущностей (Dictionary)
belongs_to :category, -> { where(dictionary_type: :category) }, class_name: "Dictionary"
# -> { where(...) } - это scope-блок, добавляющий условие к SQL-запросу при загрузке ассоциации

# Можно как дополнительный параметр передать в связь ламбду с условиев из АктивРекордс, чтобы при использовании хелпера ассоциации возвращались не все связанные сущности, а только те что соответсвуют условию. Это позволяет разграничить разные типы записей в одной таблице и использовать одну таблицу для нескольких связей к разным типам строк как будто это разные таблицы

# Но если нужна более строгая типизация - лучше разделить таблицы

# ??? Чем-то похоже на `acts_as_tenant` но в ручную ???


# dictionary.rb
class Dictionary < ApplicationRecord
  # category_type содерщит цифровые соответсвия типам: категория, статус, поставщик итд
  enum :category_type, %i[category status provider status_value]
end

# Модель Barcode использует одну и ту же таблицу dictionaries для хранения разных справочников. Чтобы различать их, используется поле dictionary_type, и фильтры (where) в ассоциациях, чтобы явно указать, какой тип словаря связан с тем или иным атрибутом
# Тоесть в таблице Barcode есть и ключ category_id и status_value_id которые на самом деле оба из колонки id таблицы dictionaries

# barcode.rb
class Barcode < ApplicationRecord
  # Связи belongs_to с моделью Dictionary. Они используют ограничение по условию (scope) и настройку имени класса:

  # Связь с одним типом Dictionary - категорией:
  belongs_to :category, -> { where(dictionary_type: :category) }, class_name: "Dictionary", optional: true 
  # -> { where(dictionary_type: :category) } - фильтрует, чтоб при загрузке этой ассоциации из таблицы dictionaries должны использоваться только те записи, у которых в колонке dictionary_type = 'category'. Это позволяет разграничить разные типы записей в одной таблице dictionaries
  # class_name: "Dictionary" - явно указывает, что эта ассоциация ссылается на модель Dictionary, несмотря на то, что имя ассоциации `category` не совпадает с именем модели (удобно для таких случаев)

  # Связь с другим типом Dictionary - статусом значения:
  belongs_to :status_value, -> { where(dictionary_type: :status_value) }, class_name: "Dictionary", optional: true
  # -> { where(dictionary_type: :status_value) } - фильтрует словари по типу status_value, чтобы использовать только те, которые представляют значения статусов (например, "новый", "продан", "возврат" итд)
end

# Dictionary entry:
Dictionary.create(value: "Одежда", dictionary_type: :category)
Dictionary.create(value: "В продаже", dictionary_type: :status_value)

# Barcode создаем со связью и для category и для status_value, как будто это разные таблицы, хотя это одна таблица:
Barcode.create(sku: "123", category: some_category_dict, status_value: some_status_value_dict)


# SQL-запросы, которые Rails генерирует при обращении к этим ассоциациям в модели Barcode:

# Ассоциация с category
barcode.category # например если barcode.category_id == 42 то SQL-запрос:
<<-SQL SELECT * FROM dictionaries WHERE id = 42 AND dictionary_type = 'category' LIMIT 1; SQL

# Ассоциация со status_value
barcode.status_value # наприамер если barcode.status_value_id == 5 то SQL-запрос:
<<-SQL SELECT * FROM dictionaries WHERE id = 5 AND dictionary_type = 'status_value' LIMIT 1; SQL

# Пример загрузки через includes (для оптимизации)
Barcode.includes(:category, :status_value).find(1)
# Rails выполнит один запрос к barcodes и два отдельных запроса к dictionaries, например:
<<-SQL SELECT * FROM barcodes WHERE id = 1; SQL
<<-SQL SELECT * FROM dictionaries WHERE id IN (категории_ID) AND dictionary_type = 'category'; SQL
<<-SQL SELECT * FROM dictionaries WHERE id IN (статусы_ID) AND dictionary_type = 'status_value'; SQL
# "категории_ID" и "статусы_ID" — это заменители, чтобы показать, что в реальности там будут реальные ID из barcode.category_id и barcode.status_value_id


Barcode.includes(:category, :status_value).find(1)
# includes создает отдельные запросы для каждой ассоциации (это "eager loading")
# Каждый запрос включает соответствующий scope-фильтр из ассоциации
# Если бы использовался joins, запросы объединились бы через INNER JOIN
# Основной запрос для поиска штрих-кода
<<-SQL SELECT * FROM barcodes WHERE id = 1 LIMIT 1; SQL
# Например у штрих-кода с ID=1 есть: category_id = 5 и status_value_id = 8 тогда:
# Запрос для загрузки связанных категорий (только тех dictionary, у которых dictionary_type = 'category'). Использует условие WHERE "dictionaries"."dictionary_type" = 'category' из scope в ассоциации
<<-SQL SELECT * FROM dictionaries WHERE dictionary_type = 'category' AND id IN (5); SQL
# Запрос для загрузки связанных статусов (только тех, у которых dictionary_type = 'status_value')
<<-SQL SELECT * FROM dictionaries WHERE dictionary_type = 'status_value' AND id IN (8); SQL





# ??? (потом проверить эту нифу на обязательность условия, тк не очень понятно) ???

-> { where(dictionary_type: :category) } # Обязательно ли прописывать подобное условие? (lambda) - обязательно, если в одной таблице (тут dictionaries) хранятся разные логические сущности (категории, статусы и т.д.)

# Всегда (особенно, если используется enum) стоит добавлять явное условие -> { where(...) }, когда:
# одна таблица содержит записи разных типов (dictionary_type);
# ты хочешь, чтобы ассоциация была строгой;
# имя ассоциации не совпадает с моделью (например, :category → Dictionary);

# Это частое недоразумение, особенно при использовании enum и однотабличных справочников

# Rails не понимает по умолчанию, что ассоциация `:category` должна использовать `dictionary_type: :category`
# Rails не "угадывает" условие `where(dictionary_type: :category)` из имени ассоциации `:category`, даже если: имя ассоциации совпадает с типом `:category`, в таблице Dictionary есть поле dictionary_type с типом enum и ассоциация указывает правильный class_name.
# Rails ассоциации по belongs_to (или has_many) не анализируют семантику названия (например, category) и не применяют логики enum (dictionary_type) без явного указания scope

belongs_to :category, -> { where(dictionary_type: :category) }, class_name: "Dictionary" # С условием гарантируется, что связанная запись будет именно категорией (а не статусом/поставщиком)


belongs_to :category, class_name: "Dictionary" # Без условия Rails будет искать любую запись в dictionaries с подходящим id, даже если это статус или поставщик. Это приведет к логическим ошибкам.

# Допустим, в dictionaries есть:
# { id: 1, category_type: :category, value: "Одежда" }
# { id: 2, category_type: :status_value, value: "Новый" }

barcode = Barcode.new(category_id: 2)  # Указываем ID строки у которой в колонке category_type статус вместо категории
# Без scope:
barcode.category  # Загрузит запись с id=2 (хотя это статус!) → логическая ошибка
# Со scope:
barcode.category  # Вернет nil, так как запись с id=2 не является категорией

# И в таблице dictionaries:
# id  name           dictionary_type
# 1   "Электроника"  "category"
# 2   "Продано"      "status_value"

Barcode.find(1).category.name  # Rails выполнит запрос только по ID (без фильтра dictionary_type):
<<-SQL SELECT * FROM dictionaries WHERE id = ? LIMIT 1 SQL

# В результате 
# можешь получить не ту запись (например, status_value вместо category)
# в сложных joins / eager_load ты подтянешь ненужные словари, а не только категории;
# ни ActiveRecord, ни база не гарантируют правильность данных