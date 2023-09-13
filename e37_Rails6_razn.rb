puts '                                       Rails разное'

# Хэлперы для URL
root_path # для ссылок на главную(get '/' root в маршруте), может содержать параметры, например для локалей
url_for(locale: locale) # ??


puts
# ссылка(на путь '#') внутри тега которой объекты, тут тег div, так же содержит дата-атрибуты
<%= link_to '#', class: 'nav-link px-2 dropdown-toggle', data: {"bs-toggle": 'dropdown'} do %>
  <%= tag.div '', class: "flag #{I18n.locale}-flag mt-1" %>
  <%= t I18n.locale %>
<% end %>


puts
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
# что выводит params
params.inspect #=> #<ActionController::Parameters {"controller"=>"comments", "action"=>"index"} permitted: false>


puts
# https://stackoverflow.com/questions/2165665/how-do-i-get-the-current-absolute-url-in-ruby-on-rails
request.fullpath #=> возвращает относительный URL на который пришел запрос в данный экшен. Так же можно использовать в представлении
























#
