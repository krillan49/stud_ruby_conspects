puts '                                                params'

# https://rusrails.ru/action-controller-overview

# params - объект(похож на хэш хэшей), в нем хранятся все параметры которые передаются запросами из браузера в приложение.

# params по умолчанию наследуется из ApplicationController во все контроллеры, тоесть можно обратиться к нему из любого метода в контроллере



puts '                              Разрешение на запись в БД значений из params'

# Атрибуты params по умолчанию запрещены для записи значений из них и их нужно разрешить

# /app/controllers/contacts_controller.rb
class ContactsController < ApplicationController
  def new
  end

  def create # принимает данные от post '/contacts', введенные пользователем в форму
    @contact = Contact.new(params[:contact]) # Если принимать параметры так, то при нажатии кнопки формы вылезет ошибка, тк атрибуты params по умолчанию запрещены: ActiveModel::ForbiddenAttributesError in ContactsController#create.

    # Для того чтобы разрешить атрибуты params создадим приватный метод contact_params:
    @contact = Contact.new(contact_params) # вместо params[:contact] вызываем наш разрешающий метод

    @contact.save
  end

  private

  def contact_params # название метода обычно сущность_params, хотя можно любое
    params.require(:contact).permit(:email, :message)
    # require(:contact)        - запрашиваем/требуем подхэш по ключу :contact в params
    # permit(:email, :message) - разрешает вносить/изменять данные под этими ключами в БД
  end
end
# Теперь мы можем добавить запись в БД через форму /contacts/new



puts '                            Реализация объекта params и разрешения параметров'

# https://api.rubyonrails.org/classes/ActionController/Parameters.html -  реализация params в ActionController

# params – это объект класса Parameters, но по своему функционалу очень похож на хеш:
params = ActionController::Parameters.new({
  person: {
    name: "Francesco",
    age:  22,
    role: "admin"
  }
})

params = ActionController::Parameters.new
# permitted? - метод проверяет разрешен ли только что созданный params. Тоже самое автоматически проверяется методами модели изменяющими БД: save, create, updste, destroy
params.permitted? #=> false

# require – метод, который получает значение хэша по ключу, где ключом в данном случае является наш ресурс, указанный в форме. Если такого ключа нет, то Rails выбросит ошибку
ActionController::Parameters.new(person: { name: "Francesco" }).require(:person) #=> #<ActionController::Parameters {"name"=>"Francesco"} permitted: false>

# permit – метод, который определяет разрешенные параметры в нашем ресурсе для передачи их значений в контроллер. Мы указываем только то, что хотим получить. ?? permit(:email, :message) - изменяет значение метода permitted? на true ??
params = ActionController::Parameters.new(user: { name: "Francesco", age: 22, role: "admin" })
permitted = params.require(:user).permit(:name, :age)
permitted.permitted?      #=> true
permitted.has_key?(:name) #=> true
permitted.has_key?(:age)  #=> true
permitted.has_key?(:role) #=> false

# Тоесть тут мы разрешили только параметры name и age для сущности user. И теперь если хакер захочет админские права(или прислать данные с айди чтоб перебить его) и отправит в запросе чтото вроде:
'user[name]=Francesco&user[age]=22&user[role]=admin'
# то механизм разрешений отсечет все лишнее и пропустит только:
'user[name]=Francesco&user[age]=22'

# Browser ===> Server ===> Controller ===> ActiveRecord ===> Database
#                                              ||
#                                              ===> тут идет наша защита(методы .new, .create итд)



puts '                               Посмотреть содержание params в приложении'

# /app/controllers/contacts_controller.rb
class ContactsController < ApplicationController
  def new
  end

  def create # принимает данные, введенные пользователем в форму

    # посмотреть/проверить в формате json/hash:
    render plain: params #=>
    # {
    #   "authenticity_token"=>"73qb1Y3HRbnFXbkKtZNPHiBV-cp2xSQHyjCVA5qMH3FAyLE0_odUBhaSsouzuYzvuRBuAtHpgDACLVNLSOXhBA",
    #   "question"=>{"title"=>"some title", "body"=>"some question"},
    #   "commit"=>"Submit question!",
    #   "controller"=>"questions",
    #   "action"=>"create"
    # }

    # Посмотреть в формате yaml:
    render plain: params.to_yaml #=>
    # --- !ruby/object:ActionController::Parameters
    # parameters: !ruby/hash:ActiveSupport::HashWithIndifferentAccess
    #   authenticity_token: EIe2q9uVSAa_pnzea-Zw2Bhr9lIn5D1VHMS7UdCQWN4IY5zG6wPlIFsA7pP8d9zK49qTFdmG2vKFsG15eKWH9A
    #   email: kroker@mail.ru
    #   password: '123456'
    #   commit: Sign In!
    #   controller: sessions
    #   action: create
    # permitted: false

    # Посмотреть в формате строки:
    render plain: params.inspect
    #=> #<ActionController::Parameters {"controller"=>"comments", "action"=>"index"} permitted: false>
    render plain: params[:article].inspect
    # => #<ActionController::Parameters {"title"=>"какойто тайтл", "text"=>"какой то текст"} permitted: false>.
  end
end

# debug - хэлпер выведет список параметров в виде при помощи хэлпера debug, чтобы их отслеживать
debug(params)



puts '                                params и параметры из строки GET-запрса'

# params - хранит и может вернуть данные из URL get-запроса

'http://localhost:3000/?name=kroker&pass=7' # Данные в URL гет-запроса записываются через слэш и знак врпрса после адреса /?. Параметр и значение параметра пишутся через знак =. Несколько разных параметров разделяются знаком &.

# Обработаем параметры из get запроса с URL http://localhost:3000/?name=kroker&pass=7 в нашем контроллере:
class HomeController < ApplicationController
  def index
    # params сможет получить эти данные по ключу, тут соответсвенно по ключу name
    @name = params[:name] # присваиваем в переменную значение "kroker" из параметра name=kroker
  end
end
# далее вставим @name в вид home/index.html.erb

# В консоли отображается обработка параметров:
# 12:31:50 web.1  | Started GET "/?name=kroker" for ::1 at 2023-10-16 12:31:50 +0300
# 12:31:50 web.1  | Processing by PagesController#index as HTML
# 12:31:50 web.1  |   Parameters: {"name"=>"kroker"}


# Можно посылать данные с разных ссылок или при помощи скрипта менять ссылку и отправлять данные в контроллер, например для меню выборки статы. (Работающий пример можно посмотреть в Chess/app/.../home/...)

# Добавим экшен и представление stata, в представлении home/stata создадим ссылки отправляющие данные что будем использовать
class HomeController < ApplicationController
  def stata
    order = params[:order]
    res = params[:result]

    if [order, res].all?{|e| e == ''}
      @accounts = Account.all
    else
      # @accounts = Account.order("? ?", [(res == '' ? 'id' : res), (order == '' ? 'ASC' : order)]) # так не сработало ??
      @accounts = Account.order("#{res == '' ? 'id' : res} #{order == '' ? 'ASC' : order}")
    end
  end
end


# Посылать параметры мжно из URL-хэлпера, чтобы потом принимать их в контроллере, например:
questions_path(filter: 'Vasya')
# Принимаем в контроллере и используем как нам надо:
render 'fuck_you/vasya' if params[:filter] == 'Vasya'














#
