puts '                                      Роли для пользователей. Enum'

# В лриложении (тут AskIt) сделаем так что пользователи могут иметь одну из нескольких ролей(например модератор, админ итд)

# (в СУБД Посгресс есть свои enum со спец типом данных для БД https://naturaily.com/blog/ruby-on-rails-enum)


# 1. Добавим при помощи миграции поле для роли в таблицу пользователей
# > rails g migration add_role_to_users role:integer
# role:integer - используем тип integer, тк это требование Рэилс, если мы хотим использовать enum, соответсвенно роль будет обозначаться в таблице числом, например 0 - пользователь, 2 - админ итд. А название роли мы будем транслировать из чисел уже в коде приложения Рэилс.
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
  # basic: 0, moderator: 1, admin: 2 - хэш со всеми возможными именами ролей с привязкой к номерам из БД (можно написать сколько угодно ролей)
  # _suffix: :role - добавляем суффикс(не обязательно можно и без него) "role"(название люблое) к методам проверки роли

  # ...
end
# Посмотрим в консоли (> rails c):
u = User.first #=> #<User:0x000001cd7ed4adf8 id: 1, ... , role: "basic">  # тоесть автоматически взял роль из enum
u.role #=> "basic"  # те метод модели role возвращает роль из enum сопоставленный с числом из БД
u.basic_role? #=> true  # метод проверяет соотв ли роль. Имя метода собирается из компонентов заданных в enum, а именно названия роли и суффикса если он есть(если нет суффикса было бы просто u.basic?)
u.admin_role? #=> false
u.role = :admin #=> :admin  # метод role так же имеет сеттер, чтобы назначать роль пользователю (это нужно сохранять отдельно чтоб записать в БД так же как и любое другое изменение сущьности)
u.admin_role? #=> true


# 3. Добавим в маршруты нэймспэйса админа экшены для редактирования и удаления пользователей, чтобы админ иметл возможность менять роли или удалать пользователя
namespace :admin do
  resources :users, only: %i[index create edit update destroy]
end


# 4. В представления нэймспэйса админа:
# admin/users/_user.html.erb - добавим роль и кнопки изменения и удаления пользователя
# admin/users/index.html.erb - добавим роль в название колонок таблицы




















#