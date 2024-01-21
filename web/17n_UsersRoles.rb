puts '                                      Роли для пользователей. Enum'

# (если приложение задеплоить в продакшен – как создать пользователя с правами администратора? - Либо делать скрипт seeds.rb либо руками через консоль БД. Это однократное действие, так что особо страшного нет - назначили первого админа, он потом назначает других Правда возможно имеет смысл сделать валидацию в духе "нельзя удалить последнего админа")

# В лриложении (тут AskIt) сделаем так что пользователи могут иметь одну из нескольких ролей(например модератор, админ итд)

# (в СУБД Посгресс есть свои enum со спец типом данных для БД https://naturaily.com/blog/ruby-on-rails-enum)


# 1. Добавим при помощи миграции поле для роли в таблицу пользователей
# > rails g migration add_role_to_users role:integer
# role:integer - используем тип integer, тк это требование Рэилс, если мы хотим использовать enum, соответсвенно роль будет обозначаться в таблице числом, например 0 - пользователь, 2 - админ итд.
class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, default: 0, null: false
    # default: 0, null: false - добавим значение по умолчанию для роли 0 и немозможность пустой роли
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
  # _suffix: :role - добавляем суффикс(не обязательно можно и без него) "role"(название люблое) к методам проверки роли

  # ...
end
# Посмотрим в консоли (> rails c):
u = User.first #=> #<User:0x000001cd7ed4adf8 id: 1, ... , role: "basic">  # тоесть автоматически взял роль "basic" из enum
u.role #=> "basic"  # те метод модели role возвращает роль из enum сопоставленный с числом из БД
u.basic_role? #=> true  # метод проверяет соотв ли роль. Имя метода собирается из компонентов заданных в enum, а именно названия роли и суффикса если он есть(если нет суффикса было бы просто u.basic?)
u.admin_role? #=> false
u.role = :admin #=> :admin  # метод role так же имеет сеттер, чтобы назначать роль пользователю (это нужно сохранять отдельно чтоб записать в БД так же как и любое другое изменение сущьности)
u.admin_role? #=> true


# 3. Добавим в маршруты юзера для нэймспэйса админа экшены для редактирования и удаления пользователей, чтобы админ иметл возможность менять роли или удалять пользователя
namespace :admin do
  resources :users, only: %i[index create edit update destroy]
end


# 4. В представления нэймспэйса админа:
# admin/users/_user.html.erb - добавим роль и кнопки изменения и удаления пользователя
# admin/users/index.html.erb - добавим роль в название колонок таблицы


# 5. Добавим в админский контроллер admin/users_controller.rb экшены edit, update, destroy и доп функционал
module Admin
  class UsersController < ApplicationController
    before_action :require_authentication
    before_action :set_user!, only: %i[edit update destroy] # добавим

    # index и create не изменились

    def edit; end

    def update
      # Но когда мы пользователя обновляем в модели производятся валидации в том числе correct_old_password, которая проверяет старый пароль для того чтобы изменить пароль, но тк админ не знает старый пароль, изменим эту валидацию(ниже) чтобы для админа она была не обязательна
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
      # Нельзя давать такое разрешение в обычном users контроллере, чтобы не дать юзерам доступ без старого пароля, а так же прписывать :role в permit, а то пользователь сможет назначить себе роль
    end
  end
end
# Изменим валидацию correct_old_password в модели user.rb чтобы для админа она была не обязательна
class User < ApplicationRecord
  enum role: { basic: 0, moderator: 1, admin: 2 }, _suffix: :role

  attr_accessor :old_password, :remember_token, :admin_edit # добавим новое виртуальное поле admin_edit

  # ...

  validate :correct_old_password, on: :update, if: -> { password.present? && !admin_edit }
  # && !admin_edit - и если это поле не установлено(false), то вылидацию correct_old_password делать нужно, а если установлено(true), значит это админ и данную валидацию не проводим

  # ...

  validates :role, presence: true # заодно добавим валидацию для роли

  # ...
end


# 6. В представления нэймспэйса админа admin/users:
# edit.html.erb - создадим вид для редактирования юзеров админом, рендерит _form.html.erb и передает туда @user как локальную
# _form.html.erb - создадим паршал с формой(почти такой же как паршал как из обычного users, но с селектором для выбора роли), котороя рендерится в edit.html.erb
# Дополнительно можно добавить роль(просто отображение) в форму обычных юзеров users/_form.html.erb


# 7. Создадим хэлпер user_roles для заполнения селектора в форме admin/users/_form.html.erb
# Для этого в директории app/helpers создадим новую папку(пространство имен) admin м в ней фаил users_helper.rb
# Код хелпере там же в app/helpers/users_helper.rb


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

# Добавим Include Pundit::Authorization application_controller.rb:
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # ...
end
# Но лучше создадим новый консерн authorization.rb (код в нем) и добавим туда, а в application_controller.rb подключим консерн
class ApplicationController < ActionController::Base
  include Authorization
  # ...
end

# Запустим генератор pundit, который создаст базовый класс(базовую политику). pundit оперирует таким понятием как политика, которая является классом в отдельном фаиле, который описывает что пользователь может делать с определенным ресурсом(вопросами, ответами, юзерами итд)
# > rails g pundit:install
# app/policies/application_policy.rb - создалась директория для политик и главная политика (код там)


puts
puts '                                     Pundit. Политика для вопросов'

# Создадим новую политику для вопросов app/policies/question_policy.rb (политика как в названии фаила так и класса именуется в единственном числе) и переопределим(запишем в ней) методы
class QuestionPolicy < ApplicationPolicy # тк мы наследуем у главной политики то получаем оттуда все содержимое и остается только переопределить те методы что мы хотим изменить
  def index?
    true # тоесть просматривать все вопросы могут все посетители
  end

  def show?
    true # тоесть просматривать конкретные вопросы могут все гости
  end

  # def create?
  #   !user.guest?
  # end
  #
  # def update?
  #   user.admin_role? || user.moderator_role? || user.author?(record)
  # end
  #
  # def destroy?
  #   user.admin_role? || user.author?(record)
  # end
end

# Модифицируем наш questions_controller.rb, чтобы можно было применить к нему политику question_policy.rb
class QuestionsController < ApplicationController
  include QuestionsAnswers
  before_action :require_authentication, except: %i[show index] # добавим проверку, что пользователь вошел в систему для всех контроллеров кроме просмотра(тк без этого мы не сможем провнрить его права доступа)
  before_action :set_question!, only: %i[show destroy edit update]
  before_action :authorize_question! # собственно наш метод проверки доступа для экшенов контроллера через question_policy.rb
  after_action :verify_authorized # на всякий случай вызовем метод(pundit) дополнительной проверки того что мы в экшене или бефор_экшене сделали авторизацию, те проверили права доступа, если же права доступа проверены не были то вылезет ошибка

  # ...

  private

  # ...

  def authorize_question!
    authorize(@question || Question)
    # authorize - метод pundit, он проверяет имеет ли пользователь право на действие с соответсвующими контроллерами относящимися к данной модели
    # @question || Question - параметр либо конкретный вопрос, если он есть(:set_question!), либо модель, если в какомто экшене нет переменной с вопросом
  end
end

# Для примера в question_policy.rb в метод create? посавим false
class QuestionPolicy < ApplicationPolicy
  # ...

  def create?
    false
  end
  # Теперь при переходе на get 'questions/new' вылезет ошибка Pundit::NotAuthorizedError in QuestionsController#new, тк мы хотели использовать экшен new
  # Тоесть метод authorize_question! вызвал authorize(@question || Question), а он посмотрел для экшена new в question_policy.rb метож new? а тот соответсвенно вызвал метод create?, в котором мы прописали false
end
# Обработаем данную ошибку, чтобы вместо нее было просто сообщение для пользователя и редирект, для этого в консерне authorization.rb используем обработчик ошибок rescue_from и для спасения ошибки свой метод обработки user_not_authorized


















#
