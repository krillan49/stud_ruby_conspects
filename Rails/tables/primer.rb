puts '                                     Система таблиц в кабинете'

# Эта система предоставляет функциональность для отображения и управления таблицами, например таблицей продуктов в кабинете пользователя. Она состоит из нескольких взаимосвязанных классов, которые обеспечивают:

# 1. Запрос и фильтрацию данных о сущностях, например продуктах
# 2. Настройку отображения таблицы
# 3. Сортировку и пагинацию
# 4. Редактирование данных прямо в таблице

# Эта система предоставляет гибкий и мощный инструмент для работы с табличными данными, с поддержкой сортировки, пагинации и inline-редактирования



puts '                                      Взаимодействие компонентов'

# 1. Пользователь запрашивает страницу с таблицей (например, продуктов) с параметрами (пагинация, сортировка)
# 2. Создается экземпляр, например ProductListTable с этими параметрами
# 3. Таблица создает Query для получения данных
# 4. Query использует Context для применения пагинации и сортировки
# 5. Данные возвращаются в таблицу, которая использует Meta и Column для форматирования отображения
# 6. Если колонка редактируемая, используется Editor для настройки поведения редактирования


# Запрос от пользователя с параметрами (params берется из params который передается в контроллер из запроса)
params = { page: 2, per_page: 50, order: "title_desc" }

# Кусок контроллера (Создание таблицы)
class Cabinets::ProductsController < ApplicationController
  # ...
  def show
    @cabinet ||= ::Cabinet.find(params[:cabinet_id])
    @table = Cabinets::ProductListTable.new(params: params, cabinet_id: @cabinet.id)
  end
  # ...
end

# Далее, например в show.html.slim рендерим через объект компонента, который принимает объект таблицы
render DatatableComponent.new(table: @table)

# Класс компонента, который возвращает свойства app/components/datatable_component.rb

# вью находится в той же директории что и компонент app/components/datatable_component.html.erb

# Использование таблицы
items = @table.items # Загруженные и отформатированные данные из Query:
#<=>
query = Cabinets::ProductListTable::Query.new(123)
products = query.with_context(context) # context содержит параметры пагинации и сортировки

# Получение информации о колонках
table.meta.columns.each do |column|
  puts "#{column.name}: sortable=#{column.sortable?}, editable=#{column.editable?}"
end



puts '                           Основной класс для работы с таблицей продуктов'

# Cabinets::ProductListTable - основной класс для работы с таблицей продуктов, наследуется от Table

# 1. Таблица создает Query (который использует Context для применения пагинации и сортировки) для получения данных
# 2. Данные возвращаются в таблицу, которая использует Meta и Column для форматирования отображения
# 3. Если колонка редактируемая, используется Editor для настройки поведения редактирования

module Cabinets
  class ProductListTable < Table
    # Метаданные (через DSL). Определяет колонки таблицы и их свойства
    meta do |m|
      #                                1. Базовые настройки таблицы:
      m.entity_name :product # Устанавливает имя сущности для: Локализации заголовков колонок (будет искать переводы по пути entities.product.*) и использования в других частях системы для идентификации типа данных
      m.sorting true # Активирует возможность сортировки для всей таблицы. Если false - сортировка будет отключена, даже если отдельные колонки помечены как sortable

      #                                2. Определения колонок:
      # а) Простые колонки (без дополнительных параметров)
      m.column :sku
      m.column :nm_id
      m.column :big_photo_url, sortable: false, format: :image # б) Колонка с изображением
      m.column :vendor_code
      m.column :brand
      m.column :category_name
      m.column :size
      m.column :color
      m.column :title
      # в) Редактируемые колонки. Общий синтаксис: m.column :field_name, editor: { options }
      m.column :user_title, editor: { field: :title, type: :string }
      m.column :user_category_name, editor: { field: :user_category_name, type: :string }
      m.column :user_color, editor: { field: :color, type: :string }
      m.column :user_size, editor: { type: :string }
      m.column :status_value, editor: { field: :status_value_id, type: :dict, dictionary: :status_value }
      m.column :date_of_last_sale, editor: { type: :string }, format: :date_format
      m.column :remainder, editor: { field: :remainder, type: :string }
      m.column :category, editor: { field: :category_id, type: :dict, dictionary: :category }
      m.column :status, editor:   { field: :status_id, type: :dict, dictionary: :status }
      m.column :ff_cost_price, editor: { field: :ff_cost_price, type: :money }
      # Параметры колонок:
      # sortable - можно ли сортировать по этой колонке
      # format   - формат отображения (:image, :date_format)
      # editor   - настройки редактирования (тип поля, словарь для выбора и т.д.)
    end

    # Инициализация таблицы с параметрами и ID кабинета
    def initialize(params:, cabinet_id:)
      super params
      @cabinet_id = cabinet_id
      @editor_url = "cell"
    end

    # Возвращает элементы таблицы с применением пагинации и сортировки
    def items
      Query.new(@cabinet_id).with_context(context) 
      # context - экземпляр Context с параметрами запроса, геттер определенный в Table
    end

    # Форматирует URL изображения в HTML-тег img
    def image(product, column)
      url = product[column.name]
      "<img src='#{url}' class='w5 h5' style='max-height: 60px'>".html_safe if url.present?
    end

    # Форматирует дату в строку
    def date_format(product, column)
      product.send(column.name).try(:strftime, '%d-%m-%Y')
    end
  end
end


# Общая структура блока meta (Этот DSL предоставляет гибкий способ настройки таблицы без необходимости изменять HTML или JavaScript код.):
meta do |m|
  #                             1. Базовые настройки таблицы

  m.entity_name :product # Устанавливает имя сущности для:
  # Локализации заголовков колонок (будет искать переводы по пути entities.product.*)
  # Использования в других частях системы для идентификации типа данных

  m.sorting true # Активирует возможность сортировки для всей таблицы. Если false - сортировка будет отключена, даже если отдельные колонки помечены как sortable
  

  #                            2. Определения колонок

  # m.column :column_name, options - шаблон

  # а) Базовые колонки, отображающие данные как есть (без дополнительных параметров) По умолчанию:
  # sortable: true - можно сортировать
  # Нет специального форматирования
  # Не редактируемые
  m.column :sku
  m.column :nm_id
  m.column :vendor_code
  m.column :brand
  m.column :category_name
  m.column :size
  m.column :color
  m.column :title

  # б) Колонка с изображением
  m.column :big_photo_url, sortable: false, format: :image
  # sortable: false - отключает сортировку для этой колонки
  # format: :image - специальное форматирование:
  # Значение будет обработано методом image в классе таблицы
  # Преобразует URL в HTML-тег <img>
  # :image - обрабатывается методом image

  # в) Редактируемые колонки Общий синтаксис: m.column :field_name, editor: { options }

  # Простое текстовое поле:
  m.column :user_title, editor: { field: :title, type: :string }
  # field: :title - указывает какое поле модели будет изменяться
  # type: :string - текстовый ввод

  # Выбор из словаря:
  m.column :status_value, editor: { 
    field: :status_value_id, 
    type: :dict, 
    dictionary: :status_value 
  }
  # type: :dict               - выбор из предопределённых значений (словаря)
  # dictionary: :status_value - имя словаря с вариантами выбора

  # Денежное поле:
  m.column :ff_cost_price, editor: { field: :ff_cost_price, type: :money }
  # type: :money - специальное поле для денежных значений
  # Включает валидацию и форматирование

  # Поле даты:
  m.column :date_of_last_sale, editor: { type: :string }, format: :date_format
  # Редактируется как строка
  # Отображается с форматированием через метод date_format
  # :date_format - обрабатывается методом date_format

end

# Особые параметры редактора:
# field      - если отличается от имени колонки
# type       - тип поля ввода:
# :string    - текст
# :dict      - выбор из списка
# :money     - денежная сумма
# dictionary - имя справочника для типа :dict


# Полный список параметров колонки
# Параметр	Тип	        Описание	                                          Пример
# sortable	Boolean	    Возможность сортировки по колонке	                  sortable: false
# format	  Symbol	    Метод форматирования значения	                      format: :image
# editor	  Hash	      Настройки редактирования (см. ниже)	                editor: { type: :string }
# caption	  String	    Заголовок колонки (переопределяет автоматический)	  caption: "SKU код"

# Параметры editor:
# Ключ	      Значение	Описание
# type	      Symbol	  Тип поля ввода (:string, :dict, :money)
# field	      Symbol	  Поле модели для сохранения (если отличается от имени колонки)
# dictionary	Symbol	  Имя справочника для type: :dict


# Как это работает в системе

# 1. Отображение таблицы. Для каждой колонки определяется:
# Заголовок (через локализацию или параметр caption)
# CSS-классы (включая классы сортировки)
# Формат значения

# 2. Редактирование:
# Редактируемые ячейки получают специальные data-атрибуты
# На фронте подключается Stimulus-контроллер editable-cell
# Параметры редактора передаются как JSON

# 3. Сортировка:
# Для sortable-колонок добавляется обработчик клика
# Генерируется URL с параметрами сортировки
# Обновляется через Turbo Frame





# Детальный разбор колонки status_value:
m.column :status_value, editor: { 
  field: :status_value_id, 
  type: :dict, 
  dictionary: :status_value 
}

field: :status_value_id # Указывает какое поле в модели будет изменяться при редактировании
# Когда пользователь редактирует значение в этой колонке, система будет обновлять поле `status_value_id` у записи. Сама колонка отображается как `status_value`, но редактируется через `status_value_id`

type: :dict # Тип редактора - словарь (выпадающий список с фиксированными значениями)
# В интерфейсе появится select (выпадающий список)
# Пользователь сможет выбрать только из предопределённых значений

dictionary: :status_value # Имя справочника, откуда брать варианты для выпадающего списка
# Система ищет словарь с именем `status_value` в специально определённых местах. Точный источник зависит от реализации в вашем проекте, но обычно это::
# a) Модель Dictionary::StatusValue или аналогичная:
class Dictionary::StatusValue < ApplicationRecord
  # имеет поля :id, :name, :code и т.д.
end
# b) YAML-конфиг с предопределёнными значениями, например config/dictionaries/status_values.yml
status_value:
  active: "Активный"
  inactive: "Неактивный"
# c) Сервис, возвращающий список вариантов. Сервисный объект:
class Dictionaries::StatusValuesService
  def self.options
    { 1 => "Active", 2 => "Inactive", 3 => "Pending" }
  end
end

# Как работает в интерфейсе? 
# 1. Отображение:
# Таблица показывает человеко-читаемое значение (например "Активный")
# Но в форме редактирования будет выпадающий список с вариантами
# 2. Редактирование:
# При клике на ячейку появится <select> с вариантами из словаря
# При сохранении в БД запишется ID выбранного значения (в поле status_value_id)
# 3. Преобразование данных. Система автоматически преобразует:
# При отображении: ID → Текст (например 1 → "Active")
# При сохранении: Текст → ID (например "Active" → 1)

# Таблица products:
# id | status_value_id
# -------------------
# 1  | 2
# 2  | 1

# Словарь status_value:
# id | name
# ---------
# 1  | Active
# 2  | Inactive

# В интерфейсе таблица покажет:
# | status_value |
# |--------------|
# | Inactive     |
# | Active       |

# При редактировании пользователь увидит выпадающий список с options:
<<-HTML
<option value="1">Active</option>
<option value="2">Inactive</option>
HTML


# Как работает связь между колонкой таблицы status_value и моделью Dictionary в вашем проекте
class Dictionary < ApplicationRecord
  acts_as_tenant :cabinet # Каждая запись Dictionary привязана к конкретному кабинету (мультиарендность)

  belongs_to :cabinet                   # принадлежит одному кабинету
  belongs_to :author, polymorphic: true # Полиморфная связь: автором записи может быть как Seller, так и Manager

  # category_type определяет тип словаря: категория, статус, поставщик итд
  enum :category_type, %i[category status provider status_value]

  # Проверки: должны присутствовать значения value и category_type
  validates :value, :category_type, presence: true
end
# Каждая запись имеет:
# category_type (тип словаря, один из: category, status, provider, status_value)
# value - собственно значение

# Механизм работы. Когда в колонке указано dictionary: :status_value, система:
# 1. Получает данные для выпадающего списка:
Dictionary.where(category_type: :status_value).where(cabinet_id: current_cabinet.id).pluck(:id, :value)
# Результат будет примерно таким:
[[1, "Active"], [2, "Inactive"], [3, "Pending"]]
# 2. Преобразует в options для select. На фронтенд передаётся в формате:
<<-HTML
<select name="status_value_id">
  <option value="1">Active</option>
  <option value="2">Inactive</option>
  <option value="3">Pending</option>
</select>
HTML
# 3. Связь с отображаемым значением:
# В таблице отображается value ("Active")
# В БД сохраняется id (1) в поле status_value_id


# Связь между Barcode.status_value и настройкой таблицы ProductListTable:
# status_value хранится не в Product, а в связанной модели Barcode

# Каждый продукт (Product) имеет несколько штрихкодов (Barcode), и каждый штрихкод имеет свой status_value
# Product
# └── has_many :barcodes
#     └── Barcode belongs_to :status_value (Dictionary с dictionary_type: :status_value)

# В ProductListTable отображаются данные, агрегированные из Barcode
# Колонка status_value фактически показывает значение из связанного Barcode
m.column :status_value, editor: { 
  field: :status_value_id, 
  type: :dict, 
  dictionary: :status_value 
}
# 1. Источник данных:
# Берется из barcodes.status_value_id (через JOIN в запросе ProductListTable::Query)
# Связанная запись ищется в Dictionary.where(dictionary_type: :status_value)
# 2. Механизм выбора значений. При редактировании система:
# а) Находит все записи в Dictionary с dictionary_type: :status_value
# б) Создает выпадающий список с этими вариантами
# в) При сохранении обновляет barcodes.status_value_id
# 3. Отображение значения:
# Через JOIN в запросе получает dictionaries.value как status_value

# Пример данных:

# Dictionary
# id | value       | dictionary_type
# --------------------------------
# 1  | "В продаже" | status_value
# 2  | "Продан"    | status_value

# Barcode
# id | status_value_id | product_id
# -------------------------------
# 1  | 1               | 123
# 2  | 2               | 123

# Как это отображается в интерфейсе
# 1. В таблице продуктов будет показано значение статуса для каждого штрихкода
# 2. При редактировании - выпадающий список с вариантами из Dictionary

# Чтобы убедиться, что это работает именно так. Посмотрите SQL-запрос в ProductListTable::Query:
@scope = Barcode.select("#{fields}, p.big_photo_url")
.from('barcodes
  LEFT JOIN products AS p ON (barcodes.product_id = p.id)
  LEFT JOIN product_categories AS cat ON (cat.id = p.category_id)
  LEFT JOIN barcode_withdrawals AS bw ON (barcodes.withdrawal_id = bw.id)
  LEFT JOIN barcode_categories AS bcat ON (barcodes.category_id = bcat.id)
  LEFT JOIN product_statuses AS pstat ON (p.status_id = pstat.id)')
.where("p.cabinet_id = ?", @cabinet_id)



puts '                                   Базовый класс для всех таблиц'

# Table - базовый класс для всех таблиц в системе

class Table
  attr_reader :context, :meta, :editor_url
  # context    - экземпляр Context с параметрами запроса
  # meta       - экземпляр Meta с метаданными таблицы
  # editor_url - URL для редактирования ячеек

  # Инициализация с параметрами запроса
  def initialize(params) # params переланный из super, а туда из контроллера с параметрами запроса
    @context = Context.from_params(params)
    @meta = Meta.new
    @editor_url = nil
    init_meta(@meta) if respond_to? :init_meta
  end

  # DSL для определения метаданных таблицы
  def self.meta(&block)
    define_method(:init_meta, &block)
  end

  # Абстрактный метод, должен быть переопределен в дочерних классах
  def items
    []
  end
end



puts '                                    Класс для построения SQL-запроса'

# Cabinets::ProductListTable::Query - класс для построения SQL-запроса для получения списка продуктов с возможностью сортировки

# Query создается классом таблицы, например Cabinets::ProductListTable

module Cabinets
  class ProductListTable::Query
    # хэш, сопоставляющий символьные имена полей с реальными SQL-выражениями
    ORDERABLES = {
      id: "barcodes.id",
      nm_id: "p.nm_id",
      sku: "barcodes.sku",
      size: "barcodes.size",
      user_title: "barcodes.title",
      user_color: "barcodes.color",
      title: "p.title",
      user_size: "barcodes.user_size",
      brand: "p.brand",
      vendor_code: "p.vendor_code",
      color: "p.color",
      category_name: "cat.name",
      user_category_name: "barcodes.user_category_name",
      withdrawn: "bw.withdrawn",
      date_of_last_sale: "barcodes.date_of_last_sale",
      remainder: "barcodes.remainder",
      category: "bcat.value",
      status: "pstat.value",
      ff_cost_price: "barcodes.ff_cost_price"
    }

    # Инициализирует запрос для конкретного кабинета
    def initialize(cabinet_id)
      @cabinet_id = cabinet_id
    end

    # Возвращает базовый ActiveRecord scope с JOIN'ами для всех связанных таблиц
    def scope
      return @scope if defined? @scope

      fields = ORDERABLES.map{|k, v| "#{v} AS #{k}"}.join(", ")
      @scope = Barcode.select("#{fields}, p.big_photo_url")
        .from('barcodes
          LEFT JOIN products AS p ON (barcodes.product_id = p.id)
          LEFT JOIN product_categories AS cat ON (cat.id = p.category_id)
          LEFT JOIN barcode_withdrawals AS bw ON (barcodes.withdrawal_id = bw.id)
          LEFT JOIN barcode_categories AS bcat ON (barcodes.category_id = bcat.id)
          LEFT JOIN product_statuses AS pstat ON (p.status_id = pstat.id)')
        .where("p.cabinet_id = ?", @cabinet_id)
    end

    # Применяет пагинацию и сортировку из контекста
    def with_context(context)
      scope.page(context.page).per(context.per_page).order(order_field(context.order_field) => context.order_direction)
    end

    # Возвращает SQL-выражение для сортировки по указанному полю 
    def order_field(field)
      case field
      when *ORDERABLES.keys then ORDERABLES[field]
      else "p.id"
      end
    end
  end
end



puts '                                    Параметры запроса для таблицы'

# Context - хранит и обрабатывает параметры запроса для таблицы (пагинация, сортировка, фильтры)

class Context
  DEFAULT_PER_PAGE = 20

  attr_reader :page, :per_page, :filters, :order, :order_field, :order_direction
  # page            - текущая страница
  # per_page        - количество элементов на странице
  # filters         - примененные фильтры
  # order_field     - поле для сортировки
  # order_direction - направление сортировки (:asc или :desc)

  # Создает контекст из параметров запроса полученных из класса таблицы из контроллера
  def self.from_params(params)
    page = (params["page"] || 1).to_i
    per_page = (params["per_page"] || DEFAULT_PER_PAGE).to_i
    order = params["order"]
    filters = params["filters"] || {}

    Context.new(page:, per_page:, order:, filters:)
  end

  def initialize(page: 1, order: nil, filters: {}, per_page: DEFAULT_PER_PAGE)
    @page = page
    @filters = filters
    @per_page = per_page
    set_order(order)
  end

  # Преобразует контекст обратно в параметры запроса
  def to_params(addition = {})
    params = {}
    params[:page] = page unless page == 0
    params[:per_page] = per_page unless per_page == DEFAULT_PER_PAGE
    params[:order] = order unless order.blank?
    params[:filters] = filters unless filters == {}
    params.merge!(addition)
  end

  # Парсит параметр сортировки
  def set_order(order)
    @order = ""
    @order_field = ""
    @order_direction = :asc

    match = /([\w]+)_(asc|desc)/.match(order)
    if match
      @order = order
      @order_field = match[1].to_sym
      @order_direction = match[2].to_sym
    end
  end

  # Возвращает хэш для сортировки { поле => направление }
  def order_hash
    { order_field => order_direction }
  end
end



puts '                              Метаданные таблицы (колонки, настройки)'

# Meta - хранит метаданные таблицы (колонки, настройки)

class Meta
  attr_reader :columns, :entity_name, :path_for_i18n, :sorting
  attr_accessor :destroy
  # columns     - массив колонок (Column)
  # entity_name - имя сущности для локализации
  # sorting     - включена ли сортировка

  def initialize
    @columns = []
  end

  # Добавляет колонку в таблицу
  def column(...)
    @columns << Column.new(...)
  end

  # Устанавливает/возвращает имя сущности
  def entity_name(value = nil)
    @entity_name = value if value.present?
    @entity_name
  end

  # Путь для локализации
  def path_for_i18n(value = nil)
    @path_for_i18n = value if value.present?
    @path_for_i18n
  end

  # Включатель сортировки таблицы
  def sorting(value = nil)
    @sorting = value if value.present?
    @sorting
  end

  def destroy(value = nil)
    @destroy = value if value.present?
    @destroy
  end
end



puts '                                  Класс отдельной колонки таблицы'

# Column - описывает отдельную колонку таблицы.

class Column
  DEFAULT_OPTIONS = {
    caption: "",
    format: nil,
    classname: "",
    sortable: true
  }

  attr_reader :name, :format, :editor
  # name   - имя колонки
  # format - формат отображения
  # editor - настройки редактора (Editor)

  def initialize(name, options = {})
    @name = name
    @options = DEFAULT_OPTIONS.merge(options)
    @format = @options[:format]
    @editor = Editor.new(@name, @options[:editor]) if @options[:editor].present?

    @format_type = :simple if @format.blank?
    @format_type = :callable if @format.respond_to?(:call)
    @format_type = :symbolic if @format.is_a? Symbol
  end

  # Возвращает CSS-классы для колонки
  def classname(context)
    cns = []
    cns << @options[:classname] if @options[:classname].present?
    cns << "sortable" if @options[:sortable]

    if @options[:sortable] && @name == context.order_field
      cns << "order-#{context.order_direction}" if context.order_direction.in?([ :asc, :desc ])
    end
    cns.join(" ")
  end

  # Возвращает заголовок колонки (с учетом локализации)
  def caption(entity_name = nil, path_for_i18n = nil)
    return "" if @options.key?(:caption) and !@options[:caption]
    return @options[:caption] if @options[:caption].present?
    return I18n.t(@name, default: @name.to_s, scope: [ :entities, entity_name ]) if entity_name.present? && path_for_i18n.nil?
    return I18n.t("#{path_for_i18n}") unless path_for_i18n.nil?
    @name.to_s
  end

  # Можно ли редактировать колонку
  def editable?
    @options[:editor].present?
  end

  # def editor_type
  #   @options[:editor_type]
  # end

  # def editor_field
  #   @options[:editor_field] || @name
  # end

  # Методы проверки формата: simple_format?, callable_format?, symbolic_format?
  [ :simple, :callable, :symbolic ].each do |f|
    define_method "#{f}_format?" do
      @format_type == f
    end
  end

  # Методы проверки свойств: sortable?
  [ :sortable ].each do |f|
    define_method "#{f}?" do
      @options[f]
    end
  end

  def item_value
    item.public_send(@name) if item.respond_to?(@name)
  end
end



puts '                                Параметры редактирования для колонки'

# Editor - описывает параметры редактирования для колонки

# Типы редакторов:
# :string - текстовое поле
# :dict   - выбор из словаря
# :money  - поле для денежных значений

class Editor
  DEFAULT_OPTIONS = {
    type: :string,
    field: nil
  }

  def initialize(name, options)
    @name = name
    @options = DEFAULT_OPTIONS.merge(options)
  end

  # Возвращает поле для редактирования
  def field
    @options[:field]
  end

  # Возвращает тип редактора
  def type
    @options[:type]
  end

  # Сериализует настройки в JSON
  def to_json
    data = @options.except(:field)
    data[:column] = @options[:field] || @name
    data.to_json
  end
end



puts '                                            Рендер таблицы'

# Эта часть системы отвечает за визуализацию таблицы продуктов и взаимодействие с пользователем. Она включает:

# 1. Шаблон для отображения страницы (show.html.slim)
# 2. Компонент таблицы (DatatableComponent)
# 3. Связанные элементы интерфейса (кнопки, загрузка данных)


# 1. show.html.slim - главный шаблон страницы "Справочник артикулов", рендерим объект компонента, который принимает объект таблицы
render DatatableComponent.new(table: @table)
# Так же show.html.slim содержит:
# "Выгрузить в Excel" - ссылка на export_xlsx_cabinet_products_path
# "Загрузить данные" - ссылка на upload_xlsx_cabinet_products_path с remote: true
# "Обновить" (в partial _reload_button) - обновляет данные таблицы
# :reload_button - Turbo Frame изолирует кнопку обновления
# :products_datatable - Turbo Frame содержит основную таблицу данных


# 2. app/components/datatable_component.rb - (? управляющий ?) компонент для отображения интерактивной таблицы с сортировкой, пагинацией и редактированием
class DatatableComponent < ViewComponent::Base
  attr_reader :table, :meta, :context
  # table   - экземпляр таблицы (например, ProductListTable)
  # meta    - метаданные таблицы (из table.meta)
  # context - контекст запроса (из table.context)
  # items   - элементы для отображения (из table.items)

  # Инициализирует компонент с объектом таблицы
  def initialize(table:)
    @table = table
    @meta = table.meta
    @context = table.context
    @items = table.items
  end

  # Генерирует URL для сортировки по колонке
  def sorting_url(column, context)
    order = determine_order(column, context)
    table_params = context.to_params(order: "#{column.name}_#{order}")
    url_for(params.clone.permit!.merge(table_params))
  end

  # Возвращает форматированное значение ячейки
  def cell_value(item, column)
    return item[column.name] if column.simple_format?

    return column.format.call(item, column) if column.callable_format?

    table.public_send(column.format, item, column) if column.symbolic_format?
  end

  private

  # Определяет направление сортировки
  def determine_order(column, context)
    column.name == context.order_field && context.order_direction == :asc ? :desc : :asc
  end
end


# app/components/datatable_component.html.erb шаблон находится в той же директории что и компонент
<<-HTML
<div class='datatable p-3'>
  <!-- Фильтры (если есть) -->
  <table>
    <thead>...</thead>
    <tbody>...</tbody>
  </table>
  <%= paginate @items %>
</div>
HTML

# Особенности:
# Поддержка сортировки (атрибуты data-controller=frame-link)
# Редактируемые ячейки (атрибуты data-controller='editable-cell')
# Пагинация (если @items поддерживает total_pages)
# Кнопка удаления (если @meta.destroy true)


# Взаимодействие компонентов

# 1. Пользователь загружает страницу /cabinet/products
# 2. Контроллер создает ProductListTable и передает его в шаблон
# 3. Шаблон show.html.slim рендерит:
#   а) кнопки управления
#   б) DatatableComponent с переданной таблицей
# 4. DatatableComponent:
#   а) Строит HTML-таблицу на основе метаданных
#   б) Применяет форматирование к значениям
#   с) Добавляет интерактивность (сортировка, редактирование)
# 5. При действиях пользователя (сортировка, пагинация):
#   а) Turbo Frame обновляет только часть таблицы
#   б) Для редактирования используются Stimulus-контроллеры


# Особенности работы

# 1. Сортировка:
# При клике на заголовок колонки генерируется URL с параметром order
# Направление сортировки меняется на противоположное при повторном клике
# Используется frame-link контроллер для Turbo Frame навигации

# 2. Редактирование:
# Редактируемые ячейки помечаются классом editable
# Используется Stimulus-контроллер editable-cell
# Параметры редактора передаются как JSON в data-атрибуте

# 3. Пагинация:
# Автоматически отображается, если коллекция поддерживает total_pages
# Использует стандартный хелпер paginate

# 4. Turbo Frames:
# Изолируют части интерфейса для независимого обновления
# products_datatable обновляется при сортировке/пагинации
# reload_button может обновляться отдельно


# Примеры использования

# 1. Кастомизация таблицы
# В контроллере
@table = Cabinets::ProductListTable.new(
  params: params,
  cabinet_id: @cabinet.id
)
# В шаблоне
render DatatableComponent.new(table: @table) do
  render "custom_filters"
end

# 2. Добавление новой колонки
# В классе таблицы
meta do |m|
  # ...
  m.column :new_field, caption: "Новое поле", sortable: true
  # ...
end

# 3. Включение функции удаления
# В классе таблицы
meta do |m|
  # ...
  m.destroy [:admin_product_path, :id]
end