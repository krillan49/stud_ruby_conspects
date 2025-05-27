puts '                                           ActiveSupport'

# ActiveSupport - это один из гемов, поставляемых с Rails. Это набор модулей, которые добавляют полезные методы и паттерны в стандартную библиотеку Ruby, и используются повсеместно в Rails. Он делает Ruby удобнее и богаче в возможностях, предоставляя огромное количество методов и DSL


# ActiveSupport включает: 

# 1. расширения стандартных классов Ruby: String, Array, Hash, Numeric, Time, Date, и др:
"hello".titleize         #=> "Hello"
2.days.ago               #=> время два дня назад
[1, 2, 3].to_sentence    #=> "1, 2, and 3"
"user_name".camelize     #=> "UserName"

# 2. Утилиты для работы с временем и датами:
1.day
2.weeks.ago
5.minutes.from_now.

# 3. Метапрограммирование и обратные вызовы: concern, delegate, class_attribute, define_callbacks и др.

# 4. Поддержка интернационализации (I18n): хелперы и поддержка перевода.

# 5. Безопасное выполнение кода: try, presence, blank?, present?

# 6. Инструменты для работы с загрузкой и автозагрузкой файлов: autoload, Dependencies, Zeitwerk (с Rails 6+).

# 7. Поддержка уведомлений и подписчиков: ActiveSupport::Notifications для построения событийной архитектуры.

# 8. JSON, Inflector, Memoization, и другие.



puts '                                  Методы удобные для запросов'

# index_by - метод из ActiveSupport преобразует массив объектов в хеш, где ключом будет результат вызова блока, а значением будет сам объект. 

# Пример:
Dictionary.where(
  value: @provider_values.to_a, # тоесть SQL выбирает строки где value соответсвует одному из значений массива
  category_type: "provider",
  cabinet: cabinet,
  author: cabinet.seller
).index_by(&:value)

# index_by(&:value) - означает: «Построй хеш, где ключ — это dictionary.value, а значение — сам dictionary». 

# То есть, если Dictionary.where(...) вернёт:
[
  #<Dictionary id=1, value="Supplier A", ...>,
  #<Dictionary id=2, value="Supplier B", ...>
]

# А после index_by(&:value) получится:
{
  "Supplier A" => #<Dictionary id=1, value="Supplier A", ...>,
  "Supplier B" => #<Dictionary id=2, value="Supplier B", ...>
}

# Чтобы потом быстро находить нужного поставщика по value вместо поиска по массиву вручную, например:
@providers_by_value["Supplier A"]

# Если value не уникально, index_by оставит только последний объект с этим значением. Остальные с тем же ключом будут перезаписаны. Убедись, что value действительно уникально в данном контексте (cabinet, category_type, author



puts '                                     Использование вне Rails'

# ActiveSupport - один из гемов, поставляемых с Rails, который так же использовать и вне Rails, если подключить отдельно
gem 'activesupport'


# Пример полезного метода из ActiveSupport:
require 'active_support/all'

"my_column_name".humanize #=> "My column name"

5.minutes.from_now        #=> Время через 5 минут

"2025-05-23".to_date      #=> Fri, 23 May 2025