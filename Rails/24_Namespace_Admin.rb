puts '                                   namespace (для администратора)'

# (На примере AskIt) Создадим namespace для администратора

# Namespace - пространство имен, которое можно объявить в маршрутах и использовать, создавая для них в поддиректориях в директориях controllers и views, отдельные от общих контроллеры и представления.

# Удобно что мы впоследствии можем легко ограничить доступ к URLам администратора другим пользователем на уровне маршрутов и к экшенам тк будем использовать отдельный контроллер в поддирректории


# 1. Создадим отдельные маршруты в namespace для администратора
namespace :admin do # создаем namespace с именем :admin и внутри создаем(копируем) маршруты отдельные для админа
  resources :users, only: %i[index create]
end
# Посмотрим как выглядят эти маршруты:
# admin_users_path	   GET	     /admin/users(.:format)	   admin/users#index
#                      POST	     /admin/users(.:format)	   admin/users#create
# тоесть это отдельные URLы и им нужен отдельный контроллер useres_controller.rb в поддирректоррии admin


# 2. Создадим в controllers новую поддиректорию admin и отдельный контроллер controllers/admin/useres_controller.rb в ней (дублирование имени контроллера допустимо тк он в отдельной подпапке и в модуле, те в отдельном пространстве имен)
module Admin # создаем в модуле
  class UsersController < ApplicationController
    before_action :require_authentication

    def index
      @pagy, @users = pagy User.order(created_at: :desc)
      # рендерит admin/users/index.html.erb
    end
  end
end


# 3. Создадим так же поддирректорию admin и в представлениях, в ней отдельную директорию users с видом admin/users/index.html.erb который будет содержать таблицу с пользователями. А так же паршал admin/users/_user.html.erb для этого вида.














# 
