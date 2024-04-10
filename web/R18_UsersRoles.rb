puts '                                      Роли для пользователей. Enum'

# (если приложение задеплоить в продакшен – то создать пользователя это - Либо делать скрипт seeds.rb либо руками через консоль БД. Это однократное действие, так что особо страшного нет - назначили первого админа, он потом назначает других. Правда возможно имеет смысл сделать валидацию в духе "нельзя удалить последнего админа")

# В приложении (тут AskIt) сделаем так что пользователи могут иметь одну из нескольких ролей(например модератор, админ итд)

# (в СУБД Посгресс есть свои enum со спец типом данных для БД https://naturaily.com/blog/ruby-on-rails-enum)


# 1. Добавим при помощи миграции поле для роли в таблицу пользователей
# > rails g migration add_role_to_users role:integer
# role:integer - используем тип integer, тк это требование Рэилс, если мы хотим использовать enum, соответсвенно роль будет обозначаться в таблице числом, например 0 - пользователь, 2 - админ итд.
class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, default: 0, null: false
    # default: 0, null: false - добавим значение по умолчанию для роли 0 и невозможность пустой роли
    add_index :users, :role # так же добавим индекс для роли
  end
end
# > rails db:migrate
# Теперь все пользователи получили роль 0.


# 2. Добавим enum с ролью в модель пользователей user.rb
class User < ApplicationRecord
  # Добавляем в самое начало (?? или необязательно в начало)
  enum role: { basic: 0, moderator: 1, admin: 2 }, _suffix: :role
  # basic: 0, moderator: 1, admin: 2 - хэш со всеми возможными именами ролей с привязкой к номерам из БД (можно написать сколько угодно любых ролей)
  # _suffix: :role - добавляем суффикс(не обязательно можно и без него) "role"(название любое) к методам проверки роли

  # ...
end
# Посмотрим в консоли (> rails c):
u = User.first #=> #<User:0x000001cd7ed4adf8 id: 1, ... , role: "basic">  # тоесть автоматически взял роль "basic" из enum
u.role #=> "basic"  # те метод модели role возвращает роль из enum сопоставленный с числом из БД
u.basic_role? #=> true  # метод проверяет на конкретную соотв роль. Имя метода собирается из компонентов заданных в enum, а именно названия роли и суффикса если он есть(если нет суффикса было бы просто u.basic?)
u.admin_role? #=> false
u.role = :admin #=> :admin  # метод role так же имеет сеттер, чтобы назначать роль пользователю (это нужно сохранять отдельно чтоб записать в БД так же как и любое другое изменение сущьности)
u.admin_role? #=> true


# 3. Добавим в админские маршруты юзера экшены для редактирования и удаления пользователей, чтобы админ иметл возможность менять роли или удалять пользователя
namespace :admin do
  resources :users, only: %i[index create edit update destroy]
end


# 4. В представления нэймспэйса админа admin/users:
# index.html.erb - добавим роль в название колонок таблицы
# _user.html.erb - добавим роль и кнопки изменения и удаления пользователя
# edit.html.erb - создадим вид для редактирования юзеров админом, рендерит _form.html.erb и передает туда @user как локальную
# _form.html.erb - создадим паршал с формой(почти такой же как и из обычного users, но с селектором для выбора роли)
# Дополнительно можно добавить роль(просто отображение) в форму обычных юзеров users/_form.html.erb


# 5. Создадим хэлпер user_roles для заполнения селектора в форме admin/users/_form.html.erb
# Для этого в директории app/helpers создадим новую папку(пространство имен) admin и в ней фаил users_helper.rb
# Код хелпере там же в app/helpers/users_helper.rb


# 6. Но когда будем обновлять пользователя, в модели user.rb производятся валидации, в том числе correct_old_password, которая проверяет старый пароль, но тк админ не знает старый пароль, изменим эту валидацию чтобы для админа она была не обязательна
class User < ApplicationRecord
  enum role: { basic: 0, moderator: 1, admin: 2 }, _suffix: :role

  attr_accessor :old_password, :remember_token, :admin_edit # добавим новое виртуальное поле admin_edit

  validate :correct_old_password, on: :update, if: -> { password.present? && !admin_edit }
  # && !admin_edit - и если это поле не установлено(false), то вылидацию correct_old_password делать нужно, а если установлено(true), значит это админ и данную валидацию не проводим

  validates :role, presence: true # заодно добавим валидацию для роли

  # ...
end


# 7. Добавим в админский контроллер admin/users_controller.rb экшены edit, update, destroy и доп функционал
module Admin
  class UsersController < ApplicationController
    before_action :require_authentication
    before_action :set_user!, only: %i[edit update destroy] # добавим

    # index и create не изменились

    def edit; end

    def update
      @user.admin_edit = true # ставим true значением виртуального поля admin_edit, чтобы валидация проверки старого пароля не производилась(альтернатива для merge(admin_edit: true) в параметрах)
      if @user.update user_params
        flash[:success] = t '.success'
        redirect_to admin_users_path
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      flash[:success] = t '.success'
      redirect_to admin_users_path
    end

    private

    # respond_with_zipped_users - метод для зип фаилов не изменился

    def set_user!
      @user = User.find params[:id]
    end

    def user_params # параметры юзеров, которые разрешим менять админу
      params.require(:user).permit(:email, :name, :password, :password_confirmation, :role).merge(admin_edit: true)
      # merge(admin_edit: true) - ставим true значением виртуального поля admin_edit, чтобы валидация проверки старого пароля не производилась(альтернатива для @user.admin_edit = true в экшене update)
      # Нельзя давать такое разрешение в обычном users контроллере, чтобы не дать юзерам доступ без старого пароля, а так же прописывать :role в permit, а то пользователь сможет назначить себе роль
    end
  end
end


puts
puts '                                      Авторизация (Pundit)'

# Аутентификация - это процесс когда мы понимаем кто вошел в систему, пользователь предоставляет свои учетные данные(например логин и пароль или смарткарта или специальный токен от соцсети если вход через соцсеть), мы проверяем их, после чего по этим данным устанавливаем кто вошел в приложение
# Авторизация - это процесс когда мы проверяем может ли данный пользователь выполнять то или иное действие(например создать или удалить вопрос)

# Систему авторизации можно написать свою или воспользоваться готовым решением:
# https://github.com/varvet/pundit              -  pundit - наиболее простое и понятное решение
# https://github.com/CanCanCommunity/cancancan  -  решение с некоторым колличеством магии
# https://github.com/palkan/action_policy       -  pundit на стероидах


# В данном случае (AskIt) воспользуемся Pundit, тк это самое простое и минималистичное решение. Оно позволит с помощью обычных классов Руби описывать то что могут делать пользователи в зависимости, например от их роли
# https://www.rubydoc.info/gems/pundit
# https://github.com/varvet/pundit

# Установим гем
# > bundle add pundit
# либо
gem 'pundit', '~> 2.3'
# > bundle i

# Подключим Pundit в application_controller.rb:
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # ...
end
# Но лучше создадим новый консерн authorization.rb (код в нем) и добавим туда, а в application_controller.rb подключим консерн
class ApplicationController < ActionController::Base
  include Authorization
  # ...
end

# Запустим генератор pundit, который создаст базовый класс(базовую политику).
# pundit оперирует таким понятием как политика, которая является классом в отдельном фаиле, который описывает что пользователь может делать с экшенами контроллера, отвечающего за определенный ресурс(вопросами, ответами, юзерами итд)
# > rails g pundit:install
# app/policies/application_policy.rb - создалась директория для политик и главная политика (код там)


puts
puts '                                    Pundit. Политика для ресурса вопросов'

# Создадим новую политику для вопросов app/policies/question_policy.rb (политика как в названии фаила так и класса именуется в единственном числе) и переопределим(запишем в ней) методы
class QuestionPolicy < ApplicationPolicy # тк мы наследуем у главной политики, то получаем оттуда все содержимое и остается только переопределить те методы что мы хотим изменить
  def index?
    true # тоесть просматривать все вопросы могут все посетители
  end

  def show?
    true # тоесть просматривать конкретные вопросы могут все гости
  end
end


# Модифицируем наш questions_controller.rb, чтобы можно было применить к нему политику question_policy.rb
class QuestionsController < ApplicationController
  include QuestionsAnswers
  before_action :require_authentication, except: %i[show index] # добавим проверку, что пользователь вошел в систему для всех контроллеров кроме просмотра(тк без этого мы не сможем проверить его права доступа)
  before_action :set_question!, only: %i[show destroy edit update]
  before_action :authorize_question! # собственно наш метод проверки доступа для экшенов контроллера через question_policy.rb
  after_action :verify_authorized # на всякий случай вызовем метод(pundit) дополнительной проверки того что мы в экшене или бефор_экшене сделали авторизацию, те проверили права доступа, если же права доступа проверены не были то вылезет ошибка

  # ...

  private

  # ...

  def authorize_question!
    authorize(@question || Question)
    # authorize - метод pundit, он проверяет имеет ли пользователь право на действие с соответсвующими контроллерами относящимися к данной модели. Для этого данный метод создает объект класса QuestionPolicy
    # По умолчанию для того чтобы передать параметр user в initialize используется метод с названием current_user (можно при желании прописать, чтоб вызывался другой)
    # @question || Question - параметр передаваемый в record в initialize. Либо конкретный вопрос, если он есть(:set_question!), либо модель, если в какомто экшене нет переменной с вопросом
  end
end


# Для примера в question_policy.rb в метод create? посавим false
def create?
  false
end
# Теперь при переходе на get 'questions/new' вылезет ошибка Pundit::NotAuthorizedError in QuestionsController#new, тк мы хотели использовать экшен new
# Тоесть метод authorize_question! вызвал authorize(@question || Question), а он посмотрел для экшена new в question_policy.rb метод new? а тот соответсвенно вызвал метод create?, в котором мы прописали false
# Обработаем данную ошибку, чтобы вместо нее было просто сообщение для пользователя и редирект, для этого в консерне authorization.rb используем обработчик ошибок rescue_from и для спасения ошибки свой метод обработки user_not_authorized


# Разрешим некоторые экшены некоторым пользователям в question_policy.rb
class QuestionPolicy < ApplicationPolicy
  # ...

  def create?
    user.present? # тоесть если юзер существует, то он может создать вопрос
    # user - берется из attr_reader application_policy.rb от которого тут наследуем
  end

  def update?
    user.admin_role? || user.moderator_role? || user.author?(record) # тоесть редактировать могут админы, модеры и авторы вопросов
    # record - переменная из attr_reader с конкретным вопросом, который пользователь пытается отредактировать
    # author? - наш кастомный метод, который добавим в модель(ниже), чтобы определить что это автор
  end

  def destroy?
    user.admin_role? || user.author?(record) # тоесть удалить может либо админ либо автор
  end
end
# Добавим метод в модель user.rb
class User < ApplicationRecord
  # ...

  # Метод проверяет является ли автор владельцем этого объекта(вопроса, ответа или коммента)
  def author?(obj) # сделаем метод универсальным для вопросов, ответов и комментов
    obj.user == self # тоесть юзер которому принадлежит сущьность(тоесть в поле user_id у сущьности то же айди) это тот юзер что вызывает метод(тоесть текущий)
  end
end
# Так же сделаем метод обратный методу author?, который будет проверять, написан ли данный вопрос ответ или коммент переданным юзером. Для этого создадим отдельный консерн в моделях models/concerns/authorship.rb (код там), и подключим этот консерн во все соответсвующие модели
include Authorship # подключим в модели Question, Answer, Comment


puts
puts '                                       Объект гость/Гостевой юзер'

# Если мы будем заходить на метод update с незарегистритованного пользователя, то возникнет ошибка undefined method `admin_role?' for nil:NilClass, тк метод admin_role? вызывается от user, но у незарегистрированного гостя нет юзера и current_user вернет nil от которого и вызывается метод
# Можно конечно писать так user&.admin_role?, но тогда это придется дублировать в куче мест
# Поэтому лучше внедрить концепцию гостевого пользователя


# Создадим новый сервисный объект services/guest_user.rb (полный код есть и в нем)
# Так же добавим экземпляр гостевого юзера в initialize в application_policy.rb, чтобы собственно был объект в переменной user от которой вызываем методы
class GuestUser
  def guest? # создадим в нем метод, который можно вызвать от user и определяющий гостся как true
    true
  end

  # Гостевой юзер должен уметь отвечать на все методы юзера(методы ролей, метод author? итд) тоесть эти методы тут нужно прописать:

  def author?(_) # параметр объекта не важен тк гость все равно ничему не автор
    false # всегда возвращаем false
  end

  # Так как ролей может быть много удобнее использовать method_missing, чем отдельные методы для каждой роли
  def method_missing(name, *args, &block)
    return false if name.to_s.end_with?('_role?') # тоесть если название оканчивается на '_role?' то возвращаем false
    super(name, *args, &block) # в остальных случаях отправляем метод "выше по икрархии" (?? в ApplicationService ??)
  end

  # ??
  def respond_to_missing?(name, include_private)
    return true if name.to_s.end_with?('_role?') # Образец нашего класса отвечает на методы, которые кончаются на '_role?'
    super(name, include_private)
  end
end

# В модели user.rb создадим точно такой же метод guest? только со значением false
class User < ApplicationRecord
  def guest?
    false
  end
end

# Теперь мы можем изменить политику вопросов question_policy.rb с использованием гостевого объекта для create?
def create?
  !user.guest? # теперь можем писать и так вместо user.present?. Тоесть пользователи могут создавать вопросы если они не гости
end


puts
puts '                     Сокрытие элементов в представлениях, в зависимости от доступа'

# Синтаксис сокрытия элементов в представлении:
if policy(question).edit?
  # ... какойто элемент разметки
end
# просто обрамляем элемент в условный оператор с этой проверкой, которая проверяет в соотв политике (тут для вопросов) соответсвующий метод (тут edit?) и показывает или скрывает элемент в зависимости от того true или false
# edit? - например для кнопки редактирования, destroy? - для кнопки удаления итд

# Для представлений questions/ :
# _question.html.erb и show.html.erb - скроем кнопки редактирования и удаления пользователям которым не разрешены эти функции
# index.html.erb - скроем кнопку нового вопроса

# Это сокрытиие чисто косметический момент, тк политика все равно закроет доступ к экшенам


puts
puts '                                    Политики для ответов и комментов'

# policies/answer_policy.rb - создадим политику для ответов, код будет точно таким же как и был для вопросв
class AnswerPolicy < ApplicationPolicy
  def index?
    true
  end
  def create?
    !user.guest?
  end
  def show? # прописываем на будущее на всякий, хоть сейчас такого экшена в контроллере ответов и нет
    true
  end
  def update?
    user.admin_role? || user.moderator_role? || user.author?(record)
  end
  def destroy?
    user.admin_role? || user.author?(record)
  end
end

# В answers_controller.rb добавим аналогичный фильтр и метод проверки доступа
class AnswersController < ApplicationController
  # ...
  before_action :authorize_answer!
  after_action :verify_authorized

  # ...

  def authorize_answer!
    authorize(@answer || Answer)
  end
end

# Скроем кнопки ответов в answers/: _answer.html.erb


puts
# policies/comment_policy.rb - создадим политику для комментариев, код будет точно таким же как и был для вопросв и ответов
class CommentPolicy < ApplicationPolicy
  # Код полностью аналогичен как был для вопросв и ответов
end

# В comments_controller.rb сделаем авторизацию прямо в экшенах, без фильтра и метода, тк всего 2 экшена
class CommentsController < ApplicationController
  # ...
  after_action :verify_authorized

  def create
    @comment = @commentable.comments.build comment_params
    authorize @comment # проверим авторизацию прямо тут, до создания естественно

    # ...
  end

  def destroy
    comment = @commentable.comments.find params[:id]
    authorize comment # проверим авторизацию прямо тут, до удаления естественно

    # ...
  end

  # ...
end

# В виде comments/_commentable.html.erb - скроем тело формы для тех кому недоступно создание комментов
# В comments/_comment.html.erb - скроем кнопку удаления коммента


puts
puts '                                    Политики для юзеров и админ/юзеров'

# policies/user_policy.rb - создадим политику для юзеров
class UserPolicy < ApplicationPolicy
  def index?
    false # никто, тк у админа свой контроллер, а обычному юзеру статка других незачем
  end

  def create?
    user.guest? # зарегистрироваться(создать пользователя) может только гость, те еще не вошедший в систему
  end

  def show? # опять же чисто на будущее, тк такого экшена нет
    true # чужие профили можно дать смотреть кому угодно
  end

  def update?
    record == user # тк в случае контроллера юзера record это и есть юзер, тоесть обновлять межет только юзер сам себя
    # Тут не прописываем админа, тк у него отдельный контроллер в нэймспэйсе
  end

  def destroy?
    false # никто, тк у админа свой контроллер, хотя можно и разрешить пользователю удалять свою учетную запись
  end
end

# В users_controller.rb добавим фильтр и метод проверки прав
class UsersController < ApplicationController
  # ...
  before_action :authorize_user!
  after_action :verify_authorized

  # ...

  def authorize_user!
    authorize(@user || User)
  end
end


puts
# policies/admin/user_policy.rb - создадим нэймспэйс и политику для админского контроллера юзеров
module Admin # естественно в модуле
  class UserPolicy < ApplicationPolicy
    # Везде разрешаем доступ к любым экшенам только админу
    def index?
      user.admin_role?
    end
    def create?
      user.admin_role?
    end
    def show?
      user.admin_role?
    end
    def update?
      user.admin_role?
    end
    def destroy?
      user.admin_role?
    end
  end
end

# Для удобства применения политики в controllers/admin создадим базовый контроллер base_controller.rb от которого будут наследовать все остальные админские контроллеры (юзеров или какие угодно еще)
module Admin
  class BaseController < ApplicationController # наследует у главного коньроллера
    # переопределим для всех админских контроллеров метод authorize
    def authorize(record, query = nil) # query - у нас этого параметра не будет, так что пофиг что он делает(?? хотя мб это куда добавляется current_user ??)
      super([:admin, record], query) # добавляем родительскому методу :admin, тоесть так мы указываем пространство имен, где лежит в политиках наша политика, будет добавлять его во все проверки по умолчанию, чтобы не писать везде authorize([:admin, user])
    end
  end
end

# В admin/users_controller.rb добавим фильтр и метод проверки прав
module Admin
  class UsersController < BaseController # теперь наследует от админского базового контроллера
    # ...
    before_action :authorize_user!
    after_action :verify_authorized

    # ...

    def authorize_user!
      authorize(@user || User) # теперь метод будет модифицированный из базового адмиского контроллера, те он будет по умодчанию добавлять :admin и без этого прилось бы писать authorize([:admin, (@user || User)])
    end
  end
end

# shared/_menu.html.erb - добавим пункт просмотра всех юзеров в главное меню, с доступом только для админа


puts
puts '                                           TODO'

# Можно дальше все это усложнять например:
# 1. Внедрить для пользователей состояние "забанен", не обязательно роль. И соотв модифицировать политику например комментов, чтобы забаненый не мог комментировать
# 2. Новые роли, например подмодер, который модеррит только комменты

# Так же Пандит умеет работать(есть в доках) со:
# 1. Скоупами (записываются прямо в конкретной политике) - они позволяют выдавать список записей из БД в зависимости от роли, например админам все, а комуто только определенные(WHERE)
# 2. Так же можно выдавать разные разрешенны_атрибуты(из форм) в зависимости от роли пользователя
# 3. Внизу доков так же есть инфа как тестировать, как работать с Девайс, как переходить с КанКанКан итд


















#
