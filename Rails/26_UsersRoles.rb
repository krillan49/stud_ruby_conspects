puts '                          Авторизация(роли для пользователей) с применением Enum'

# (Если приложение задеплоить в продакшен - то можно создать 1го пользователя (админа) через скрипт в seeds.rb либо руками через консоль. Это однократное действие, так что оно норм - назначили первого админа, он потом назначает других. Но возможно стоит сделать валидацию в духе "нельзя удалить последнего админа")


# (AskIt) Сделаем так что пользователи могут иметь одну из нескольких ролей(например модератор, админ итд)


# 1. Добавим при помощи миграции поле для роли в таблицу пользователей
# > rails g migration add_role_to_users role:integer
# role:integer - используем тип integer, тк это требование Рэилс, если мы хотим использовать числовой enum, соответсвенно роль будет обозначаться в таблице числом, например 0 - пользователь, 2 - админ итд.
class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, default: 0, null: false
    # default: 0, null: false - добавим значение по умолчанию для роли - 0 и невозможность пустой роли
    add_index :users, :role # так же добавим индекс для роли
  end
end
# > rails db:migrate
# Теперь все пользователи получили роль 0.


# 2. Добавим оператор метода enum с ролью в модель пользователей user.rb
class User < ApplicationRecord
  enum role: { basic: 0, moderator: 1, admin: 2 }, _suffix: :role
  # basic: 0, moderator: 1, admin: 2 - хэш с любым количеством любых имен ролей с привязкой к номерам из БД
  # _suffix: :role - необязательный суффикс (тут "role") который добавится к именам методов проверки роли

  # ...
end

# Посмотрим в консоли (> rails c):

# roles - метод класса модели, получаем от enum хэш всех возможных ролей:
User.roles      #=> { basic: 0, moderator: 1, admin: 2 }

# При создании экземпляра, enum автоматически конвертирует цифру из БД в заданное нами значение (тут 0 в "basic") и поместит его в соответсвующее свойство экземпляра:
u = User.first  #=> #<User:0x000001cd7ed4adf8 id: 1, ... , role: "basic">

# role - метод экземпляра модели, возвращает роль из enum, в сооответсвии с числом из БД
u.role          #=> "basic"

# Автоматически генерируются методы экземпляра, проверяющие на конкретную роль. Имя генерируемых методов собирается из заданных в enum названия роли и суффикса если он есть(если нет суффикса было бы просто basic?, admin? итд)
u.basic_role?   #=> true
u.admin_role?   #=> false

# Метод role так же имеет сеттер, чтобы назначать роль пользователю (его нужно потом сохранять, чтоб записать в БД так же как и любое другое изменение в БД)
u.role = :admin #=> :admin
u.admin_role?   #=> true


# 3. Добавим в админские маршруты юзера экшены для редактирования и удаления пользователей, чтобы админ имел возможность менять роли или удалять пользователя
namespace :admin do
  resources :users, only: %i[index create edit update destroy]
end


# 4. В представления нэймспэйса админа admin/users:
# index.html.erb - добавим роль в название колонок таблицы
# _user.html.erb - добавим роль и кнопки изменения и удаления пользователя
# edit.html.erb  - создадим вид для редактирования юзеров админом, рендерит _form.html.erb и передает в нее @user
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
  # !admin_edit - если это виртуальное поля модели не установлено, то вылидацию correct_old_password делать нужно, а если установлено(true), значит это админ и данную валидацию не проводим

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
















#
