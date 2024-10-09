puts '                                  Helpers(вспомогательные функции)'

# (?? Методы хэлперлов не действуют внутри контроллеров ??)

# http://rusrails.ru/action-view-overview
# https://guides.rubyonrails.org/form_helpers.html

# Хелпер - работает между контроллером и представлением. Чтобы не вставлять дополнительный код в представление:
# 1. Нет смысла дублировать один и тот же код во многих представлениях, проще записать его в хэлпере вызывать хэлпер в представление
# 2. Логику в представлениях писать непринято, лучше выносить в хелперы. Представления предназначены для того, чтобы отображать данные. Нехорошо размазывать логику по всему приложению, лучше держать в одном месте
# 3. Много кода в представлении будет мешать фронтэндерам
# 4. Код в представлениях трудно тестировать

# Отличие хэлпера от вспомогательной функции - хэлпер работает и в представлении

# Хэлперы бывают встроенные в Рэилс изначально и собственные, написанные разработчиком приложения

# app/helpers/application_helper.rb - главный хэлпер, в котором обычно пишут свои глобальные хэлперы использующиеся на разных страницах относящимся к разным моделям и контроллерам
module ApplicationHelper
end

# Для каждого нового контроллера можно создать отдельный хелпер в каталоге /app/helpers/
module ArticlesHelper # хэлпер(является модулем) для контроллера Articles /app/helpers/articles_helper.rb
  # тут можно писать методы
end
# Один хелпер создаётся для одного контроллера, но все хелперы доступны всем контроллерам.



puts '                          Назначение вспомогательных методов контроллера хэлперами'

# Создание хэлпера из вспомогательной функции контроллера
class ApplicationController < ActionController::Base
  # ... экшены контроллера ...

  # можно было бы и вынести код ниже в отдельный concern
  private

  def some
  end

  def some2
  end

  helper_method :some, :some2 # сделаем данные вспомогательные методы хэлперами, тоесть они будут доступны в представлениях
end



puts '                         Встроенные routes хэлперы(для URL) - именнованные маршруты'

# Их можно посмотреть в routes или открыв несуществующий URL или по адресу http://localhost:3000/rails/info.
# Их можно использовать с хелпером link_to, чтобы строить теги <a> для навигации внутри приложения.

# Окончание хэлпера может быть _path или _url, например course_path, semesters_url – это routes helpers
resourses_path  #=>  '/resourses'                   -   тоесть относительный маршрут
resourses_url   #=>  'localhost:5000/resourses'     -   тоесть полный маршрут

# для корневой страницы(get '/' root в маршруте), может содержать параметры, например для локалей
root_path

# Если название контроллера не во множественном числе(без s на конце), то хэлпер для URL index будет называться не name_path а:
name_index_path
# при этом хэлпер для show будет называться стандартно

# some_url - тут именно _url, тк нам нужен полный адрес с доменным именем сайта, например чтобы ссылка могла быть активирована гдето на почтовом сервисе клиента, для этого в config/environments/development.rb мы и указывали доменное имя в host:, тк он и будет тут задействован при генерации URL
edit_password_reset_url(user: {password_reset_token: @user.password_reset_token, email: @user.email})
# user: {password_reset_token: @user.password_reset_token, email: @user.email} - записываем в адрес ссылки что-то, например токен для сброса пароля и имэил пользователя, чтобы потом можно было их обработать
# Получится URL вроде:
# 'http://localhost:3000/password_reset/edit?user%5Bemail%5D=ser%40ser.com&user%5Bpassword_reset_token%5D=%242a%2412pZrpySgC'
# edit - тут от экшена или формы ??

# locale: :en - добавим локаль в ссылку. Можно разнести представления с разными переводами в разные представления (локализированные представления), если надо переводить так и тогда ссылка вызовет представление с определенным переводом.
# Локализированные представления - это представления, которые содержат код локали (ru, en) перед расширениями. Эти локализированные представления автоматически подтянутся, в представлениях нужно только добавить локаль в ссылку, чтобы при переходе по ней язык остался тем же.
edit_password_reset_url(locale: :en)


# url_for - генерирует из URL ту же строку просто как текст
url_for edit_password_reset_url(user: {password_reset_token: @user.password_reset_token, email: @user.email})


# Маршрут из 2х сущьностей, например для one-to-many. передаем 2 параметра тк для URL нам нужны оба айдишника, важно сохранить порядок чтоб обладающая сущность стояла первой. Получим URL /questions/2/answers/2
question_answer_path(@question, answer)

# polymorphic_path - создает URL для полиморфических ассоциаций, строит путь исходя из того что переданно в 1м элементе массива, тут comment.commentable тоесть комментируемая сущность, вопрос или ответ, а далее сущность коммента. Те путь будет либо '/questions/:qoestion_id/comments/:id' либо '/answers/:answer_id/comments/:id'
polymorphic_path([comment.commentable, comment])

# хэлпер с заданием формата в котором запрос будет обработан контроллером. К URL например в ссылке допишется .zip
admin_users_path(format: :zip)

# хэлпер URL содержащий в адресе айдишник данного (тут тега) GET '/questions?tag_ids=1'
questions_path(tag_ids: tag)



puts '                                 Редиректы, рендеры, отпрака фаилов'

# редирект на страницу с которой пришел запрос или корневую
redirect_to(request.referer || root_path)

# send_data - стандартный метод Рэилс, который пересылает фаилы пользователю на скачивание через браузер
send_data compressed_filestream.read, filename: 'users.zip'
# compressed_filestream.read - параметр метода send_data - фаил архива который передаем с методом read(читать)
# filename: 'users.zip' - имя передаваемого фаила архива



puts '                                      Встроенные хэлперы тэгов'

# 1. Разные теги:

# tag - позволяет прописывать теги, их значение и другие параметры на Руби
tag.div val, class: "alert", role: 'alert', id: 'some'
# div - метод создаст в представлении тег div
# val  - произвольная переменная со значением/содержанием тега


tag.time datetime: question.formatted_created_at do #<!-- <time datetime="..."> -->
  # .... какой-то тег например <small><%= question.formatted_created_at %></small>
end


# 2. Теги ссылок (тег "a"):

# link_to - хэлпер ссылки с возможностью задавать параметры(работает совместно с js-фаилом turbolinks)
link_to "Sign In", new_user_session_path
# "Sign In"  - имя/содержание/тело ссылки
# new_user_session_path  - URL адрес ссылки, тоесть значение атрибута href

# link_to с дата-атрибутами для работы с Турбо
link_to 'Sign Out', destroy_user_session_path, data: { 'turbo-method': :delete, 'turbo-confirm': 'Вы уверены?' }

# ссылка/кнопка для работы с форматом zip. Выгрузит для пользователя данные в формате zip
link_to 'Download zip', admin_users_path(format: :zip), data: {confirm: t('global.dialog.you_sure')}
# admin_users_path(format: :zip) - добавляем в хэлпер URL параметр format: :zip, это значит что к URL допишется .zip

# Ссылки удаления, редактирования для one-to-many
link_to 'Delete', question_answer_path(@question, answer), data: {method: :delete, confirm: "Are you sure?"}
link_to 'Edit', edit_question_answer_path(@question, answer), class: 'btn btn-info btn-sm'

# Ссылка с блоком для тела, которое содержит несколько объектов, которые будут обрамлены тегом ссылки
link_to '#', class: 'nav-link px-2 dropdown-toggle', data: {"bs-toggle": 'dropdown'} do
  tag.div '', class: "flag #{I18n.locale}-flag mt-1"
  t I18n.locale
end
# '#' - URL для ссылки тут стоит первым параметром, тк за тело ссылки отвечает блок вмето названия

# Cущьность obj принадлежащая вопросу, обернутый в ссылку
link_to questions_path(obj_ids: obj), class: 'badge rounded-pill bg-light text-dark d-inline-block px-2 pt-1 pb-2 me-1' do
  obj.title
end

# target: '_blank' - для открытия на другой вкладке
link_to 'Reset my password', edit_password_reset_url, target: '_blank'



# 3. Теги форм и полей:

# form_with - встроенный хэлпер для создания формы в виде

# вариант с до юрл
form_with model: @user, url: password_reset_path, method: :patch do |f|
end
# <!-- Тут не смотря на прописывание модели, прописываем URL и метод отдельно, тк если указать только модель, то эта форма будет отправлена на обработку в user-контроллер, но нам нужен контроллер сброса пароля, потому и нужно указать URL и метод, чтоб отправилось на его экшен update -->

# email_field - генерирует поля для ввода имэйла с базовой провекой на соответсвие текста имэйлу
f.email_field :email, placeholder: 'E-mail', class: 'form-control form-control-lg'

# file_field - хэлпер генерирует поле для загрузки фаила
f.file_field :archive, class: 'form-control'

# collection_select - хэлпер селектора, который может принимать коллекцию сущностей и подставлять ее свойства
f.collection_select :tag_ids, objcts, :id, :title, {}, multiple: true
# :tag_ids - значение атрибута name поля(селектора ?)
# objcts - произвольная переменная с коллекцией(массивом) сущьностей
# :id - метод сущьности(название колонки) который нужно применять к сущности из коллекции для значений элементов(передаются на сервер) селектора
# :title - метод сущьности(название колонки) который нужно применять к сущности из коллекции при отображении лэйблов(названий тегов) на странице в пунктах селектора
# {} - пустые опции (отделяют основные и доп опции хелпера ??)
# multiple: true - ставит атрибут multiple в селектор (выбор множества вариантов через контрл)

# f.check_box - вспомогательная функция для чекбокса
f.check_box :remember_me, class: 'form-check-input', value: '1'
# value: '1' - задаем значение которое будет передавать чекбокс: '0' - галочка не поставлена, '1' - галочка поставлена. Это можно посмотреть вернув render plain: params.to_yaml в экшене create, там среди прочего будет remember_me: '0'
f.label :remember_me, 'some message', class: 'form-check-label'
# 'some message' - подпись рядом с чекбоксом например запомнить на сколькото дней



puts '                          Встроенные хэлперы обработки HTML-кода в тексте'

# (Можно например оставить себе доступ, через условные операторы проверив содержание какого-то поля, на содержание какого-то текста-пароля, при обнаружении которого будет обрабатываться с html_safe. Можно обернуть все это в мутный хэлпер, например sanitise чтобы было незаметно)

# примеры в Askit questions/show.html.erb

# По умолчанию любые теги введенные в поле пользователем при отображении не активны и выводятся просто как символы текста, например если ввести из поля сущьности(тут body) '<b>hhh<b>' то это так и выведется вместо 'hhh' жирным шрифтом
@question.body

# html_safe - (AR ??) обрабатывает любые html-теги, что опасно, тк пользователь может ввести, например тег script с вредоносным js-скриптом, например украдет пароли пользователей тк будет записывать ввод или просто вызывать всплывающие окна
@question.body.html_safe

# sanitize - хэлпер разрешающий обработку только безопасных тегов и позволяет пользователю делать базовое форматирование текста
# https://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html
# https://github.com/flavorjones/loofah/blob/main/lib/loofah/html5/safelist.rb    - теги(какие допускаются какие еще чето)
sanitize @question.body

# strip_tags - хэлпер удаляет символы тегов, не обрабатывает их отавляя только текст из их тел
strip_tags @question.body

# Преобразует выводимый текст(@foo.body) в html, например заменяет "\n" на <br>
simple_format @foo.body



puts '                                      Встроенные хэлперы для моделей'

# (?? Это метод Рэилс или Девайс ??) update_attribute - Изменение значения поля сущьности(тут сущьность - current_user, поле - admin, значение - true)
current_user.update_attribute :admin, true


# new_record? - проверяет новая ли запись, те экземпляр модели созданный через new но не заполненный
User.find(params[:id]).new_record? #=> false
User.new.new_record?               #=> true

class Comment < ApplicationRecord
  belongs_to :article # модель создалась с ассоциацией article. Тоесть комментарии принадлежат статье. Можно добавлять вручную если в генераторе не указать article:references
  # Comment.find(id).article - теперь можно обращаться от любого коммента к статье которой он пренадлежит через метод article
end

# 2а. Допишем вручную в модель уже Article  /models/article.rb ...
class Article < ApplicationRecord
  has_many :comments # добавим ассоциацию comments, тоесть статья связывается с комментами (множественное число).
  # Article.find(id).comments - теперь можно обращаться от любой статьи к коллекции (массив) принадлежащих ей комментов через метод comments
end
# Таким образом мы связали 2 сущности между собой.

# 2б. Настроим владеющую модель чтобы можно было удалять статью со всеми зависимыми комментами (сначала удаляет комменты а потом саму статью)
class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  # dependent: :destroy  - параметр который и позволит нам удалять статьи у которых созданы принадлежащие им комменты
end



puts '                                      Встроенные хэлперы для миграций'

# Вариант references (алиас к belongs_to)
t.references :article, null: false, foreign_key: true # Создает столбец article_id являющийся foreign_key к id поля той статьи к которой относится коммент в таблице articles.
# Вариант belongs_to (алиас к references)
t.belongs_to :article, null: false, foreign_key: true  # в таблице укажет так если генерировали при помощи belongs_to
# МБ belongs_to лучше использовать для связи 1 - * (сущности разных моделей), а references для таблиц одной сущности при нормализации (1 - 1) ??
# Связи можно добавлять отдельной миграцией если в генераторе не указать article:references
# можно добавить и тут вручную если данная миграция еще не была запущена


# 1. Создадим новые миграции чтобы добавить user_id с foreign_key в таблицы questions и answers
# > rails g migration add_user_id_to_questions user:belongs_to
# > rails g migration add_user_id_to_answers user:belongs_to
# user:belongs_to - параметр создающий новое поле user_id с foreign_key к id в таблице users
# Создались миграции:
class AddUserIdToQuestions < ActiveRecord::Migration[7.0]
  def change
    # add_user_id_to_questions - изза такого правильного названия с именами таблиц, автоматически заполнилось:
    add_reference :questions, :user, null: false, foreign_key: true, default: User.first.id
    # Но если прямо так запустить миграцию, то опция null: false вызовет ошибку и миграция не пройдет изза того, что значение поля user_id не может быть пустым, но у уже ранее созданных записей оно пустое, а в прдакшене удалить существующие записи - не очень тема, потому, чтобы миграция прошла нужно будет обойти это при помощи временного значения по умолчанию:
    # default: User.first.id - поставит в старые записи в колонку user_id вместо NULL дефолтное значение с айди этого юзера (мб придумать специального юзера для этого, например с именем "Аноним")
  end
end


# Теперь удалим временное значения User.first.id из полей user_id при помощи еще одной миграции
# > rails g migration remove_default_user_id_from_questions_answers
class RemoveDefaultUserIdFromQuestionsAnswers < ActiveRecord::Migration[6.1]
  # В миграции заменим метод change на методы up и down:

  def up # этот метод вызывается при применении миграции  > rails db:migrate
    change_column_default :questions, :user_id, from: User.first.id, to: nil
    # from: User.first.id, to: nil - не обязательно(но не лишне) писать это при использовании методов up и down
    change_column_default :answers, :user_id, from: User.first.id, to: nil
    # Тоесть когда мы применим данную миграцию, мы заменим значения User.first.id в user_id в таблицах на пустое
  end

  def down # этот метод вызывается при откате миграции  > rails db:rollback
    change_column_default :questions, :user_id, from: nil, to: User.first.id
    # from: nil, to: User.first.id - не обязательно(но не лишне) писать это при использовании методов up и down
    change_column_default :answers, :user_id, from: nil, to: User.first.id
    # Тоесть когда мы откатим данную миграцию, мы обратно заполним значением User.first.id пустые значения user_id в таблицах
  end

  # Все тоже самое можно было бы сделать и используя метод change, но тогда писать from: User.first.id, to: nil обязательно иначе будет неоткатываемо
end



puts '                                         Встроенные хэлперы разные'

# truncate - если есть длинная строка, то при отображении урезается до указанного размера(можно применить например для всех статей на главной транице чтоб выводить только части статей, чтоб не занимать много места, пример на questions/index.html.erb):
truncate(@question.body, length: 20)
# length: 20 - указываем до скольки символов обрезаем отображаемый текст
truncate strip_tags(@question.body), length: 150, omission: '... (continued)'
# strip_tags(question.body)  -  применяем к результату другого метода
# omission: '... (continued)'  -  указываем то что будет в конце обрезанной строки(входит в length: 150)

# dom_id - позволяет удобно генерировать id для тегов, например якоря для ссылок-якорей(пример и реализация на questions/show.html.erb и в CRUD-фаиле)
dom_id(answer)

# debug, тут выведет список параметров, чтобы их отслеживать
debug(params)

# autolinks - автоматическая подсветка ссылок ??

# minutes - метод Рэилс для чисел
60.minutes
# Пример
Time.current - password_reset_token_sent_at <= 60.minutes



puts '                        Кастомный хэлпер для названия страницы во вкладке. Метод provide'

# На примере AskIt

# Можно на вкладке сайта в браузере, через теги head->title добалять не только статическое название сайта, но и динамически добавлять туда название активной страницы.

# Напишем хэлпер, оператор которого будет помещен в layouts/application(helper).html.erb -> <head> -> <title> и будет принимать название конкретной страницы и добавлять его к названию сайта во вкладке браузера
# Хэлпер создадим глобальным в главном хэлпере app/helpers/application_helper.rb
module ApplicationHelper

  def full_title(page_title = "") # page_title - параметр с названием конкретной страницы
    if page_title.present? # теперь если название страницы существует(значение переменной установлено, тут не равно "") ...
      "#{page_title} | AskIt" # ... то вернем данную строку с названием страницы и сайта ...
    else # ... а иначе просто название сайта
      "AskIt"
    end
    # теперь та строка которая возвращается и будет подставлена туда куда мы интегрируем хэлпер(тут в тайтл)
  end

end

# Тоесть мы подставляем например <% provide :page_title, 'Questions' %> в questions/index.html.erb, когда эта страница рендерится в главный yield, то в лэйаут в yield(:page_title) передается значение 'Questions', а оно как параметр передается в хэлпер и возвращается нужное название



puts '                     Кастомные хэлперы для динамического меню, переданного через yield'

# Есть подходы проще например https://github.com/comfy/active_link_to но они не дают такого контроля

# На примере AskIt

# По умолчанию пункты меню в шапке в лэйаут никак не отображают где мы находимся, напишем для этого хэлперы


# 1. Для удоббства и динамических возможностей меню можно вынести главное меню сайта из лэйаут в отдельный паршал
# shared/_menu.html.erb - создадим паршал с меню


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
# 3. В процессе рендеринга паршала shared/_menu.html.erb обрабатывается код с блоком <% provide :main_menu do ... end %> отправляет блок с меню в лэйаут в точку <%= yield :main_menu %>


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
