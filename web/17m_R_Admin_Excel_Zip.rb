puts '                    Админ. Импорт/экспорт Excel, архивы ZIP, сервисные объекты'

# (На примере AskIt) Создадим функционал, который позволит администратору сайта выгружать информацию о пользователях в формате Excel а именно xlsx, при этом чтобы эта инфа была разбита по отдельным Excel фаилам для каждого пользователя и чтобы все эти фаилы вместе помещались в архив ZIP, чтобы можно было загрузить этот архив и работать с фаилами в нем


puts
puts '                                   Namespace (для администратора)'

# Namespace - пространство имен, которое можно объявить в маршрутах и использовать создавая дополнительные поддиректории в controllers и views


# 1. Создадим маршруты с namespace для администратора
Rails.application.routes.draw do
  # ...
  namespace :admin do # создаем namespace с именем :admin и внутри создаем маршруты только для админа(отдельные директории контроллеров и представлений admin/чето)
    resources :users, only: %i[index create]
  end
  # ...
end
# Посмотрим как выглядят эти маршруты:
# admin_users_path	   GET	     /admin/users(.:format)	   admin/users#index
#                      POST	     /admin/users(.:format)	   admin/users#create
# тоесть это отдельные URLы и нужен отдельный контроллер users в поддирректоррии admin


# Удобно что мы впоследствии можем легко ограничить доступ к URLам администратора другим пользователем и к экшенам тк будем использовать отдельный контроллер users в поддирректории


# 2. Создадим в controllers новую поддиректорию admin и отдельный контроллер useres_controller.rb в ней(дублирование имени контроллера допустимо тк он в отдельной подпапке, те в отдельном пространстве имен)
module Admin # создаем в модуле, так жн можно былоб написать class Admin::UsersController < ApplicationController
  class UsersController < ApplicationController
    before_action :require_authentication

    def index
      @pagy, @users = pagy User.order(created_at: :desc)
      # возвращает admin/users/index.html.erb
    end
  end
end


# 3. Создадим так же поддирректорию admin и в представлениях, в ней отдельную users с видом admin/users/index.html.erb который будет содержать таблицу с пользователями. А так же паршал _user.html.erb для этого вида.












#
