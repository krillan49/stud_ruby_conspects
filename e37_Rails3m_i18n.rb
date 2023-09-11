puts '                                       i18n(internationalization)'

# https://guides.rubyonrails.org/i18n.html
# http://rusrails.ru/i18n

# i18n == internationalization - i далее 18 букв и последняя n. Интернационализация существует в Rails, при помощи нее можно не беспокоиться о регистрах в представлениях, а так же переводах на другие языки

# Все наши строки переводов будут находиться в отдельных фаилах yml в директоии config/locales, а в представлениях будут заглушки обозначающие их и при рэндере страницы, строка будет вставлена в зависимости от выбранной пользователем локали

# Можно создавать перевод для сайта и вызывать константы во views. Например, для русского языка можно создать /config/locales/ru.yml

# Работа с i18n (internationalization):
# 1. Открыть файл /config/locales/en.yml (в нем есть небольшая кокументация по использованию)
# 2. Создадим в фаиле /config/locales/en.yml раздел, например contacts:
# 3. Вызовем в представлении, например /app/views/contacts/new.html.erb: <h2><%= t('contacts.contact_us') %></h2>

# Devise i18n:
# config/locales/devise.en.yml


# гем i18n-tasks там скрипты для проверки отсутсвия ключей, дублей, рассинхрона переменных и.т.д.
# если надо будет данные в базе переводить, то mobility


puts
puts '                                               Методы'

# Наиболее важными методами I18n API являются:
translate('some_catalog_name') # Ищет перевод текстов
t('some_catalog_name')         # псевдоним translate
localize('some_catalog_name')  # Локализует объекты даты и времени в форматы локали
l('some_catalog_name')         # псевдоним localize
I18n.t 'store.title'
I18n.l Time.now

# В Рэилс при правильном маршруте фаилов в приложении вместо например такого полного:
<%= t('home.index.title') %> # тут home - директория, а index - представление
# .. можно писать в виде сокращенно так:
<%= t('.title') %>


# Также имеются методы чтения и записи для следующих атрибутов:
load_path                 # Анонсировать ваши пользовательские файлы с переводом
locale                    # Получить и установить текущую локаль
default_locale            # Получить и установить локаль по умолчанию
available_locales         # Разрешенные локали, доступные приложению
enforce_available_locales # Принуждение к разрешенным локалям (true или false)
exception_handler         # Использовать иной exception_handler
backend                   # Использовать иной бэкенд


# Атрибуты для таблиц(вылезают в ошибках валидации формах итд), в yml будут иметь структуру:
'activerecord.attributes.model_name.col_name:' # где 1е 2 слова неизменяемы, 3е название модели(те в единственном числе) и 4е название столбца для которого собственно и делаем перевод

# Название модели(тк некоторые хэлперы могут ее использовать и выводить в представления гдето)
'models.model_name:'


puts
puts '                                       Переключение языков. Настройка'

# https://lokalise.com/blog/rails-i18n/    - пример

# https://www.youtube.com/watch?v=mwEHVNZ1VLM&list=TLGG8VQStWV1sZ4wOTA5MjAyMw   - видео из примера(Круковский)
# Не пройдено:
# 8-49 - локализация даты и времени
# 13-28 - перевод пагинации(переключалки страниц)
# 14-17 - перевод флэш сообщений


# 1. Настройка в фаиле config/application.rb:
module Blog2 # Blog2 - просто название проекта
  class Application < Rails::Application
    config.load_defaults 7.0 # Initialize configuration defaults for originally generated Rails version.

    # Выпишем все те локали(фаилы yml, обозначающие например языки), которые мы хотим поддерживать
    config.i18n.available_locales = %i[en ru] # маленькая i в i18n
    # Примечание: в yml нужно сделать переводы на все указанные языки, иначе если переключиться, а перевода нет, то в некоторых местах вместо языка по умолчанию будет название плэйсхолдера или тега(может ииза gem 'rails-i18n' ??).

    # Установим локаль по умолчанию, во избежание "сюрпризов"
    config.i18n.default_locale = :en # при изменении параметра тут тоже можно переключать
  end
end
# перезагрузить рэилс сервер


# 2. В Gemfile можно подключить гем для наиболее типичных переводо(например название месяцев, дней недели, валют, типичные ошибки валидации итд)
gem 'rails-i18n'
# > bundle install


# 3. Рекомендуется установить кодировку и отобразить текущий установленный языковой стандарт в лэйаут
# <head lang="<%= I18n.locale %>">
# <meta charset="utf-8">


# (ПОКАЧТО ТОЛЬКО ЗАПИСАНО А НЕ СДЕЛАНО, СДЕЛАТЬ ПОСЛЕ ПРОХОЖДЕНИЯ ПУНКТА ПРО ДРОПДАУН МЕНЮ)
# 4. Настройка маршрутов для переключения языков пользоавтелем
# Задача в том чтобы адрес мог содержать локаль localhost:3000/en/posts или localhost:3000/ru/posts или localhost:3000/posts
Rails.application.routes.draw do
  # оборачиваем все маршруты в
  scope "(:locale)", locale: /#{I18n.available_locales.join('|')}/ do
  # (:locale) - скобки значат что локаль(/en/) в маршруте не обязательна
  # locale: /#{I18n.available_locales.join('|')}/  - аргумет с регуляркой, который проверяет что язык исключительно из тех что мы прописали в кофиг( %i[en ru] )

    # все наши маршруты будут внутри данного

  end
end


# 5. Метод и фильтр переключения языка добавляются в application_controller, а остальные наследуют
class ApplicationController < ActionController::Base
  around_action :switch_locale #

  protected

  # Вариант 1 - одним методом
  def switch_locale(&action) # добавим метод установки языка
  # &action - обязательный парамер, это действие(экшен) контроллера, которое необходимо выполнить

    locale = params[:locale] || I18n.default_locale # локаль берем из юрл, что мы настроили в маршрутах "(:locale)", либо если ее нет то используем локаль по умолчанию заданную в конфиге
    I18n.with_locale locale, &action # 1й аргумент это переменная локали, 2й экшен контроллера
  end

  # Вариант 2 - с подметодом проверки локали
  def switch_locale(&action)
    locale = locale_from_url || I18n.default_locale
    I18n.with_locale locale, &action
  end
  def locale_from_url # метод проверки локали
    locale = params[:locale]
    return locale if I18n.available_locales.map(&:to_s).include?(locale) # приводим к строке, тк params[:locale] возвращает строку, а в available_locales символы
    # Те возвращаем только если запрашивая локаль описана в конфиге а иначе вернет nil
  end

  # Для обоих вариантов
  def default_url_options # переопределяем встроиный метод Рэилс
    { locale: I18n.locale } # по дефолту каждому URL, который сгенерин при помощи спец хэлперов, мы добавим текущую локаль
  end
end



# Потом для дополнения(старое)
puts
# Метод и фильтр переключения языка добавляются в application_controller, а остальные наследуют
class ApplicationController < ActionController::Base
  around_action :switch_locale # Почемуто с  у меня пустую страницу открывает, а с before_action все норм работает
  # Тут проблема в том, что надо сменить локаль, а потом вернуть исходную. Можно и c before_action сделать, но тогда в after_action надо установить другую, иначе новый запрос на тот же процесс получит локаль от последнего пользователя, а не дефолтную.
  # Скорее всего action в блок передается как-то неправильно

  before_action :switch_locale # фильтр установки языка

  protected

  def switch_locale # добавим метод установки языка
    # locale = current_user.try(:locale) || I18n.default_locale
    # I18n.with_locale(locale, &action)
    I18n.locale = 'ru' # жесткая установка(тут 'ru' это название фаила ru.yml ??)

    # или, если для каждого пользователя свой, то лучше сделать around_action в контроллере и использовать
    I18n.with_locale(/user_locale/) { action }
    # идея в то, что для каждого запроса локаль будет своя при таком подходе
  end
end

# настройки языка для пользователя можно либо в куки положить, либо в базу(создать отдельный столбец в users)



















#
