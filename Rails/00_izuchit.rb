# ТУДУ:
# 1. https://habr.com/ru/articles/191762/  - пройти (различные способы загрузки ассоциаций)
# 2. https://softwareengineering.stackexchange.com/questions/230307/mvc-what-is-the-difference-between-a-model-and-a-service       отличия модели и сервиса


# История Рэилс, отличие разных верий
# https://habr.com/ru/articles/871710/


# Пример из blog2(с Devise):
# При редиректе с fallback_location: происходит почемуто множественный редирект если пользователь не соответсвует фильтру:
class ProtectedController < ApplicationController
  before_action :admin? # Если пользователь не админ то ...

  def users_list # get 'users_list'
    @users = User.all
  end

  private

  def admin?
    unless user_signed_in? && current_user.try(:admin?)
      # ... так будет множественный редирект и браузер выдаст ошибку
      redirect_back fallback_location: root_path, notice: 'User is not admin'

      # ... а так будет все ок
      redirect_to root_path, notice: 'User is not admin'
    end
  end
end


puts
# Пример из blog2(с Devise):
# при удалении контента по ссылкам с видов другого контроллера перенаправляет на страницу соотв контента, а нужно на ту же страницу(?? нужны отдельные экшены для удаления и создания в другом контроллере?)


puts
# ?? ( Рэилс )Возвращает true, если этот объект включен в аргумент. Аргументом должен быть любой объект, который отвечает на include?
characters = ["Konata", "Kagami", "Tsukasa"]
"Konata".in?(characters) # => true















#
