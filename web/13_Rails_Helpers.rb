puts '                                  Helpers(вспомогательные функции)'

# http://rusrails.ru/action-view-overview
# https://guides.rubyonrails.org/form_helpers.html

# Отличие хэлпера от вспомогательной функции - то что он работает и в представлении

# Хэлперы бывают встроенные в Рэилс изначально, но можно писать и собственные

# app/helpers/application_helper.rb - главный хэлпер, в котором обычно пишут свои глобальные хэлперы использующиеся на разных страницах относящимся к разным моделям и контроллерам
module ApplicationHelper
end

# Для каждого нового контроллера можно создать отдельный хелпер в каталоге /app/helpers/
module ArticlesHelper # хэлпер(является модулем) для контроллера Articles /app/helpers/articles_helper.rb
  # тут можно писать методы
end
# Один хелпер создаётся для одного контроллера, но все хелперы доступны всем контроллерам.


# ?? Методы хэлперлов не действуют внутри контроллеров ??

# Хелпер - работает между контроллером и представлением. Чтобы не вставлять код в представление:
# 1. Нет смысла дублировать один и тот же код во многих представлениях(на один контроллер может быть несколько представлений, например у нас 5 представлений для контроллера Articles), проще записать его в методе в хэлпере вызывать хэлпер в представление
# 2. Логику в представлениях писать непринято, лучше выносить в хелперы. Представления предназначены для того, чтобы отображать данные. Нехорошо размазывать логику по всему приложению, лучше держать в одном месте(например в контроллерах).
# 3. Много кода в представлении будет мешать фронтэндерам
# 4. Код в представлениях трудно тестировать


puts
puts '                          Назначение вспомогательных методов контроллера хэлперами'

# Создание хэлпера из вспомогательной функции контроллера
class ApplicationController < ActionController::Base
  # экшены коетроллера

  private # ограничим, но можно было бы и вынести эти хэлперы в отдельный concern

  def some
  end
  def some2
  end

  helper_method :some, :some2 # сделаем данные вспомогательные методы хэлперами, тоесть они будут доступны в представлениях
end


puts
puts '                                      Встроенные хэлперы тэгов'

# tag - позволяет прописывать теги, их значение и другие параметры на Руби
tag.div v, class: "alert", role: 'alert', id: 'some'
# div - метод создаст в представлении тег div
# v  - значение/содержание тега


# form_with - встроенный хэлпер для создания формы в виде


# link_to - позволяет вставлять ссылки и задавать им параметры(работает совместно с js-фаилом turbolinks)
link_to "Sign In", new_user_session_path

# Турбо
link_to 'Sign Out', destroy_user_session_path, data: { 'turbo-method': :delete, 'turbo-confirm': 'Выйти? Вы уверены?' }

# ссылка(тут на путь '#') с блоком внутри тега которой содержит несколько объектов и они будут обрамлены тегом ссылки, тут тег div, так же содержит дата-атрибуты для бутстрап
link_to '#', class: 'nav-link px-2 dropdown-toggle', data: {"bs-toggle": 'dropdown'} do
  tag.div '', class: "flag #{I18n.locale}-flag mt-1"
  t I18n.locale
end


# collection_select - хэлпер селектора
f.collection_select :tag_ids, tags, :id, :title, {}, multiple: true
# <!-- collection_select - хэлпер селектора, который может принимать коллекцию сущностей и подставлять ее свойства -->
# <!-- :tag_ids - название поля -->
# <!-- tags - коллекция всех тегов которую сюда передаем из questions/new.html.erb или questions/edit.html.erb -->
# <!-- :id - метод(модели) который нужно применять к сущности из коллекции tags для значений элементов(передаются на сервер) селектора  -->
# <!-- :title - метод(модели) который нужно применять к сущности из коллекции tags при отображении лэйблов(названий тегов) на странице в пунктах селектора -->
# <!-- {} - пустые опции  -->
# <!-- multiple: true - ставит атрибут multiple в селектор (выбор множества вариантов через контрл) -->


puts
puts '                         Встроенные routes хэлперы(для URL). Именнованные маршруты'

# Их можно посмотреть в routes или открыв несуществующий URL или по адресу http://localhost:3000/rails/info.
# Их можно использовать с хелпером link_to, чтобы строить теги <a> для навигации внутри приложения.

# Окончание хэлпера может быть _path или _url, например course_path, semesters_url – это routes helpers
resourses_path  #  '/resourses'                   -   тоесть относительный маршрут
resourses_url   #  'localhost:5000/resourses'     -   тоесть полный маршрут


root_path # для ссылок на главную(get '/' root в маршруте), может содержать параметры, например для локалей

url_for(locale: locale) # ??

# Если название контроллера не в множественном числе(без s на конце), то хэлпер для URL index будет называться не name_path а:
name_index_path
# при этом хэлпер для show будет называться стандартно

# хэлпер с заданием формата для контроллера
admin_users_path(format: :zip)

# хэлпер URL содержащий в адресе айдишник данного (nen тега) GET '/questions?tag_ids=1'
questions_path(tag_ids: tag)

# редирект на страницу с которой переходили на ошибку или корневую
redirect_to(request.referer || root_path)

<%= link_to t('global.button.delete'), polymorphic_path([comment.commentable, comment]),
  class: 'btn btn-danger btn-sm', data: {method: :delete, confirm: t('global.dialog.you_sure')} %>
# polymorphic_path([comment.commentable, comment] - хэлпер Рэилс для URL полиморфических ассоциаций, строит путь исходя из того что переданно в 1м элементе массива, тут comment.commentable тоесть комментируемая сущность, вопрос или ответ, а далее сущность коммента. Те путь будет либо '/questions/:qoestion_id/comments/:id' либо '/answers/:answer_id/comments/:id'


puts
puts '                  Встроенные хэлперы разрешающие/запрещающие использование тегов пользователю'

# (Можно например оставить себе доступ, через условные операторы проверив содержание какого-то поля, на содержание какого-то текста-пароля, при обнаружении которого будет обрабатываться с html_safe. Можно обернуть все это в мутный хэлпер, например sanitise чтобы было незаметно)

# Данные хэлперы используются в представлениях(примеры в Askit questions/show.html.erb)

# По умолчанию любые теги введенные в поле пользователем при отображении не активны и выводятся просто как символы текста, например если ввести из поля сущьности(тут body) '<b>hhh<b>' то это так и выведется вместо 'hhh' жирным шрифтом
@question.body

# html_safe - (AR ??) обрабатывает любые html-теги, что опасно, тк пользователь может ввести, например тег script с вредоносным js-скриптом, например украдет пароли пользователей тк будет записывать ввод или просто вызывать всплывающие окна
@question.body.html_safe

# sanitize - хэлпер разрешающий обработку только безопасных тегов и позволяет пользователю делать базовое форматирование своего текста
# https://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html
# https://github.com/flavorjones/loofah/blob/main/lib/loofah/html5/safelist.rb    - теги(какие допускаются какие еще чето)
sanitize @question.body

# strip_tags - хэлпер удаляет символы тегов, не обрабатывает их отавляя только текст из их тел
strip_tags @question.body



puts
puts '                                      Встроенные хэлперы разные'

# truncate - если есть длинная строка, то при отображении урезается до указанного размера(можно применить например для всех статей на главной транице чтоб выводить только части статей, чтоб не занимать много места, пример на questions/index.html.erb):
truncate(@foo, length: 20)
# length: 20 - указываем до скольки символов обрезаем отображаемый текст
truncate strip_tags(question.body), length: 150, omission: '... (continued)'
# strip_tags(question.body)  -  применяем к результату другого метода
# omission: '... (continued)'  -  указываем то что будет в конце обрезанной строки(входит в length: 150)

# dom_id - позволяет удобно генерировать id для тегов, например якоря для ссылок-якорей(пример и реализация на questions/show.html.erb и в CRUD-фаиле)
dom_id(answer)

# debug, тут выведет список параметров, чтобы их отслеживать
debug(params)

# Преобразует введенный(например в поле) текст(@foo) в html, например заменяет "\n" на <br>
simple_format(@foo)

# autolinks - автоматическая подсветка ссылок ??

# send_data - стандартный метод Рэилс, который пересылает фаилы пользователю
send_data compressed_filestream.read, filename: 'users.zip'
# compressed_filestream.read - параметр метода send_data - фаил архива который передаем с методом read(читать)
# filename: 'users.zip' - имя передаваемого фаила архива


puts
puts '                            Кастомный хэлпер для вывода названия страницы во вкладке'

# На примере AskIt

# Можно на вкладке сайта в браузере, через тег head->title добалять не только статическое название сайта, но и динамически добавлять туда название активной страницы.

# Напишем хэлпер, оператор будет помещен в layout -> head -> title и будет принимать название конкретной страницы и добавлять его к названию сайта во вкладке браузера
# Хэлпер создадим глобальным в главном хэлпере app/helpers/application_helper.rb
module ApplicationHelper

  def full_title(page_title = "") # page_title = ""  - параметр с названием конкретной страницы
    if page_title.present? # теперь если название страницы существует(значение переменной установлено, тут не равно "") ...
      "#{page_title} | AskIt" # ... то вернем данную строку с названием страницы и сайта ...
    else # ... а иначе просто название сайта
      "AskIt"
    end
    # теперь та строка которая возвращается и будет подставлена туда куда мы интегрируем хэлпер(тут в тайтл)
  end

end

# Тоесть мы подставляем например <% provide :page_title, 'Questions' %> в questions/index.html.erb, когда эта страница рендерится в главный yield, то в лэйаут в yield(:page_title) передается значение 'Questions', а оно как параметр передается в хэлпер и возвращается нужное название


puts
puts '                     Кастомные хэлперы для динамического меню, переданного через yield'

# Есть подходы проще например https://github.com/comfy/active_link_to но они не дают такого контроля

# На примере AskIt

# По умолчанию пункты меню в шапке в лэйаут никак не отображают где мы находимся, напишем для этого хэлперы


# 1. Для удоббства и динамических возможностей меню можно вынести и главное меню сайта из лэйаут в отдельный паршал
# Создадим паршал меню shared/_menu.html.erb


# 2. Кастомный хэлпер currently_at для передачи блока с меню в лэйаут через yield'
# Хэлпер для того чтобы рендерить паршал с меню на страницах в которые он будет подставлен через второстепенный yeald
module ApplicationHelper

  # currently_at - название любое, но это норм тк это хэлпер который нам говорит на какой странице мы находимся
  def currently_at # Обработку значения параметра, например 'Questions', рассмотрим ниже
    render partial: 'shared/menu'
    # render partial:  - говорит о том что рендерим именно паршал, а не полноценный вид, так будет рендерить без лэйаута, а по умолчанию(из модуля ??) рэндерит с ним
  end

end
# Последовательность работы:
# 1. Вызывается хэлпер currently_at с целевого представления(тут questions/index.html.erb)
# 2. Хэлпер currently_at(выше) рэндерит паршал с меню shared/_menu.html.erb
# 3. В процессе рендеринга обрабатывается код из паршала и строка <% provide :main_menu do ... end %> отправляет блок с меню в лэйаут в точку <%= yield :main_menu %>


# 3. Кастомный хэлпер nav_tab, который стилизует ссылки меню в зависимости от страницы на которой находится пользователь
# Хэлпер создадим глобальным в главном хэлпере app/helpers/application_helper.rb
module ApplicationHelper

  def currently_at(current_page = '') # параметр current_page с тем значеним что мы передали в обработчик(тут 'Questions')
    render partial: 'shared/menu', locals: {current_page: current_page}
    # locals: {current_page: current_page} - создается локальная переменная current_page(которую можно применять в представлении) через символ-ключ current_page: которому присвоили значение(тут 'Questions') из параметра current_page
  end

  def nav_tab(title, url, options = {}) # будет принимать параметры из из обработчика, по той же схеме что и ссылка(название, юрл, дополнительные опции в том числе классы)
    current_page = options.delete :current_page # значение текущей страницы(тут 'Questions') из элемента опций под ключем :current_page, заодно удаляем его из хэша(вместо options[:current_page]) options, тк будем использовать этот же options далее

    # переменная для класса бутстрапа, который передадим ссылке
    css_class = current_page == title ? 'text-secondary' : 'text-white' # если значение current_page(тут 'Questions') равно значению названия ссылки - параметра title, тогда присваеиваем одно значение для клсса иначе другое

    # Помещаем значение в хэш options под ключ :class, в зависимости от того есть ли у нашей ссылки nav_tab другие классы или нет
    options[:class] = options[:class] ? options[:class] + ' ' + css_class : css_class # если есть то прибавляем в значение класса новый класс, если нет создаем этот элемент хэша

    link_to title, url, options # передаем измененный хэш options и параметры названия и юрл в стандартный хэлпер ссылки и возвращаем его
  end

end
# Для того чтобы все работало нужно чтобы совпадали значения в хэлперах ссылок nav_tab(параметр названия ссылки) и значения названий страниц в currently_at(параметр). Но можно будет упростить при помощи i18n

















#
