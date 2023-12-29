puts '                               CRUD. params. Формы. Валидация. Паршалы'

# CRUD - аббревиатура обозначающая основыные операции:
# Create - (new)              .create; .new.save
# Read   - (index | show)     .where; .find(3); .all
# Update - (update)
# Delete - (destroy)

# https://github.com/rails/strong_parameters
# https://guides.rubyonrails.org/action_controller_overview.html#more-examples


puts
puts '                                 new(resourses). Форма form_for. render'

# 1. Создадим представление app/views/articles/new.html.erb. Без него при обращении к http://localhost:3000/articles/new - выпадет ошибка ArticlesController#new is missing a template for request formats: text/html.(отсутствует шаблон/представление)
# Создаем форму form_for (устарела ??) в articles/new.html.erb

# 2. Добавим в app/controllers/articles_controller.rb экшен create для обработки данных формы из new.html.erb:
class ArticlesController < ApplicationController
  def new # get '/articles/new'
    # по умолчанию возвращает new.html.erb
  end
  def create # post '/articles'
    render plain: params[:article].inspect
    # render - метод для возврата/вывода данных из экшена в лэйаут. Выводит по URL экшена create: post '/articles';
    # plain: - ключ хеша(обозначает что будет выведен просто текст);
    # params[:article].inspect - значение хеша.
    # В итоге выведет #<ActionController::Parameters {"title"=>"какойто тайтл", "text"=>"какой то текст"} permitted: false>.

    # по умолчанию возвращает(рэндерит) create.html.erb(render 'articles/create')
  end
end
# Страницу /articles пользователь не сможет открыть вручную, тк для нее сейчас есть только POST-обработчик, но нет GET(index)


puts
puts '                             Запись в БД. Разрешение на использование атрибутов'

# Изменим /app/controllers/contacts_controller.rb
class ContactsController < ApplicationController
  def new
  end

  def create # принимает данные введенные пользователем в форму
    @contact = Contact.new(params[:contact]) # Но если принимать параметры так, то при нажатии кнопки формы вылезет ошибка: ActiveModel::ForbiddenAttributesError in ContactsController#create.
    # Аттрибуты params[:some] по умолчанию запрещены и их нужно разрешить, для этого используется специальный синтаксис:
    @contact = Contact.new(contact_params) # вместо params[:contact] вызываем наш разрешающий метод
    @contact.save
  end

  private

  def contact_params # название метода обычно сущность_params, хотя можно любое
    params.require(:contact).permit(:email, :message)
    # require(:contact) - получаем соответсвующий подхэш в params
    # permit(:email, :message) - разрешает вносить данные пд этими ключами в БД ??
  end
end
# Теперь мы можем добавить запись в БД через форму /contacts/new


puts
puts '                            Реализация объекта params и разрешения параметров'

# https://api.rubyonrails.org/classes/ActionController/Parameters.html -  реализация params в ActionController

# params - объект(хэш хэшей) который по умолчанию присутсвует(переходит при наследовании из ApplicationController) в контроллере. Можно обратиться к нему из любого метода в контроллере. В нем хранятся все параметры которые передаются из браузера в приложение.

# params – это объект определенного класса, но по своему виду очень напоминает хеш
params = ActionController::Parameters.new({
  person: {
    name: "Francesco",
    age:  22,
    role: "admin"
  }
})

params = ActionController::Parameters.new
params.permitted? #=> false  # проверяем разрешен или нет только что созданный params. Тоже самое автоматически проверяется методами модели изменяющими БД: save, create, updste, destroy

# require(:contact) - требует наличия параметров.
ActionController::Parameters.new(person: { name: "Francesco" }).require(:person) #=> #<ActionController::Parameters {"name"=>"Francesco"} permitted: false>
# require – метод, который получает значение хэша по ключу, где ключом в данном случае является наш ресурс, указанный в форме. Если такого ключа нет, то Rails выбросит ошибку

# permit(:email, :message) (изменяет значение метода permitted? на true)
params = ActionController::Parameters.new(user: { name: "Francesco", age: 22, role: "admin" })
permitted = params.require(:user).permit(:name, :age)
permitted.permitted?      # => true
permitted.has_key?(:name) # => true
permitted.has_key?(:age)  # => true
permitted.has_key?(:role) # => false
# permit – метод, который определяет разрешенные параметры в нашем ресурсе для передачи их значений в контроллер. Мы указываем только то, что хотим получить!

# Тоесть тут мы разрешили только параметры name и age для сущности user. И теперь если хакер захочет админские права(или прислать данные с айди чтоб перебить его) и отправит в запросе чтото вроде:
# user[name]=Francesco&user[age]=22&user[role]=admin
# то механизм разрешений отсечет все лишнее и пропустит только:
# user[name]=Francesco&user[age]=22

# Browser ===> Server ===> Controller ===> ActiveRecord ===> Database
#                                              ||
#                                              ===> тут идет наша защита(методы .new, .create итд)


puts
# посмотреть/проверить содержание всего params в приложении:
def create
  render plain: params #=>
  # {
  #   "authenticity_token"=>"73qb1Y3HRbnFXbkKtZNPHiBV-cp2xSQHyjCVA5qMH3FAyLE0_odUBhaSsouzuYzvuRBuAtHpgDACLVNLSOXhBA",
  #   "question"=>{"title"=>"some title", "body"=>"some question"},
  #   "commit"=>"Submit question!",
  #   "controller"=>"questions",
  #   "action"=>"create"
  # }

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
end


puts
puts '                                params и параметры из строки GET-запрса'

# params - хранит и может вернуть данные из URL гет запроса

# http://localhost:3000/?name=kroker&pass=7
# Данные в URL гет-запроса записываются через слэш и знак врпрса после адреса /?. Параметр и значение параметра пишутся через знак =. Несколько разных параметров разделяются знаком &.

# Обработаем параметры из гет запроса с URL http://localhost:3000/?name=kroker&pass=7 в нашем контроллере:
class HomeController < ApplicationController
  def index
    # params сможет получить эти данные по ключу соотв name
    @name = params[:name] # присваиваем значение "kroker" из параметра name=kroker
  end
end
# далее вставим @name в вид home/index.html.erb

# В консоли отображается обработка параметров:
# 12:31:50 web.1  | Started GET "/?name=kroker" for ::1 at 2023-10-16 12:31:50 +0300
# 12:31:50 web.1  | Processing by PagesController#index as HTML
# 12:31:50 web.1  |   Parameters: {"name"=>"kroker"}


puts
# Те можно посылать данные с разных ссылок или при помощи скрипта менять ссылку и отправлять данные в контроллер, например для меню выборки статы. (Работающий пример можно посмотреть в Chess/app/.../home/...)

# Добавим экшен и представление stata, в представлении создадим ссылки отправляющие данные что будем использовать
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


puts
puts '                                 Валидация и сообщения об ошибках'

# 1. Валидацию надо добавить в модель /app/models/contact.rb
class Contact < ApplicationRecord
  # Синтаксис тот же самый что и в Синатре, тк это тот же самый ActiveRecord
  validates :email, presence: true
  validates :message, presence: true
end

# 2. Исправим код в методе create в контроллере /app/controllers/contacts_controller.rb:
def create
  @contact = Contact.new(contact_params)
  if @contact.valid? # это можно не писать и тут сразу написать @contact.save
    @contact.save # содается сущность и строка в БД(создастся до возврата вида)
    # тут по умолчанию возвращает create.html.erb
  else
    # а если не валидно отрендерим/вернем нашу форму new.html.erb(но уже на URL /contacts) при помощи render, с переменными уже из данного экшена create, а не из new
    render action: 'new'     # полный вариант записи
    # render - метод для передачи данных (разных форматов) из экшена, сохраняет данные из экшена, например переменные
    # action: - ключ (устарел ?? для вывода только видов данного экшена)
    # 'new' - имя представления по которому будет сгенерирована HTML-страница
    render 'new'             # сокращенный вариант записи
    render :new              # сокращенный вариант записи
    render 'articles/create' # можно вывести представления по имени директори и фаила в каталоге views, так можно выводить представления и других контроллеров
    # https://rusrails.ru/layouts-and-rendering   -  про рэндеринг
  end
end

# 3. Теперь, если при заполнении формы будет ошибка валидаци, то форм билдер нам подскажет, автоматически обернув лэйбл неправильно заполненного поля и само поле в div-ы:
'<div class="field_with_errors"></div>'
# Оформление можно добавить любое через CSS в файле /app/assets/stylesheets/application.css
# Значения правильно заполненных полей вносит в value автоматически

# 4. Выведем список ошибок. Вывод будет таким ["Email can't be blank", "Message can't be blank"]
# Вариант 1(так без ошибок будет выведен пустой массив): В new.html.erb добавим код для сообщения об ошибках.
# В app/controllers/contacts_controller.rb нужно определить переменную:
def new
  @contact = Contact.new # пустая сущность
end
# Вариант 2: без пустой сущности, записать в /app/views/contacts/new.html.erb


puts
puts '                                  shared(дирректория для общих паршалов)'

# Добавим в /app/views/contacts/new.html.erb сообщение об ошибках при помощи паршала.

# shared - создадим дирректорию для общих(для видов всех контроллеров) паршалов

# Создадим паршал _errors.html.erb и поместим в него сообщения об ошибках. Рэндерим его в паршал формы или в вид где форма


puts
puts '                             Метод в модели для работы с сущностью в предсталении'

# Создадим в модели метод, который сможем применять в представлениях, для кастомного форматирования дат

class Question < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  # Создадим метод экземпляра в модели
  def formatted_created_at
    self.created_at.strftime('%Y-%m-%d %H:%M:%S') # можно и с self и без тк created_at это инстанс метод модели
  end
end

# пример использования в questions/show.html.erb


puts
puts '                                          index(resourses)'

# index(resourses) - обычно используется для вывода всех сущностей(тут выведем все статьи)

# Внесём изменения в /app/controllers/articles_controller.rb:
class ArticlesController < ApplicationController
  def new
  end

  # Заполним метод create для articles.
  def create
    @article = Article.new(article_params)
    if @article.save
      # по умолчанию возвращает create.html.erb
    else
      render action: 'new'
    end
  end
  # Создадим представление /app/views/articles/create.html.erb
  # Добавим ссылку в create.html.erb на все статьи '/articles'

  # Добавим экшен index. Список статей будет доступен по адресу /articles
  def index # get '/articles'
    @articles = Article.all
    # по умолчанию возвращает index.html.erb
  end
  # И создадим вид /app/views/articles/index.html.erb

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end
end


puts
puts '                           PRG(Post Redirect Get). redirect_to. show(resourses)'

# При обновлениии страницы, возвращенной пост запросом(тут post '/articles' articles#create), произойдет повторная отправка формы(выскакивает предупреждение от браузера), тк возвращается вид на тот же URL, что может вызвать проблемы например 2йной покупки и 2йного списания денег

# PRG(Post Redirect Get) - паттерн для предотвращения двойного сабмитта. Тоесть POST-запрос вместо рендера вида совершает перенаправление на GET-запрос.

# Для этого в нашем случае добавим redirect_to @article в метод create
class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article  # перенаправляет на GET /article/id articles#show. Тогда вид create.html.erb будет уже не нужен.
      # redirect_to получает сущность из @article и делает редирект по ее айди(те посылает браузеру указание перейти на другую страницу). Редирект происходит на стороне браузера, те новый get-запрос.
      # Так же аргументами redirect_to можно использовать хэлперы путей или сами URL адреса
    else
      render action: 'new'
    end
  end

  # Далее добавим метод show на который редиректит из create
  def show # get '/articles/id'
    @article = Article.find(params[:id]) # получаем id из URL через params
    # по умолчанию возвращает articles/show.html.erb
  end
  # Создадим представление /app/views/articles/show.html.erb

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end
end


puts
puts '                                     разница между render и redirect_to'

#  https://stackoverflow.com/questions/7493767/are-redirect-to-and-render-exchangeable

# render (возврат вида по умолчанию это тоже рендер) - когда пользователь обновляет страницу, он снова отправит предыдущий запрос POST. Это может привести к нежелательным результатам, таким как повторная покупка и другие. Соответвенно используем только в безопасных случаях, например когда не прошла валидация и данные не отправлены в БД

# redirect_to - когда пользователь обновляет страницу, он просто снова запросит ту же страницу. Это также известно как шаблон Post/Redirect/Get (PRG). После обработки post запроса браузеру возвращается маленький пакет(тк не содержит представлений итд, а только управляющую команду), браузер автоматически исполняет команду и отправляет GET-запрос

# В том числе и по этому в обработчиках GET-запросов не совершаюттся никакие опасные действия меняющие данные в БД, чтобы обновления не привели к 2йным отправкам данных и пользователь мог переходить по страницам безопасно.


puts
puts '                               edit, update (resourses) - pедактирование статьи'

# Добавим ссылку на редактирование в articles/index.html.erb

# https://guides.rubyonrails.org/routing.html#path-and-url-helpers  - _path методы

# Добавим в /app/controllers/articles_controller.rb:
def edit #  get '/articles/id/edit'
  @article = Article.find(params[:id])
  # по умолчанию возвращает edit.html.erb
end
# Создадим вид /app/views/articles/edit.html.erb c формой для редактирования

# Добавим в контроллер /app/controllers/articles_controller.rb экшен update
def update  # post -> put '/articles/id'
  @article = Article.find(params[:id])
  if @article.update(article_params) # update - метод для обновления/изменения сущности
    redirect_to @article # перенаправление на show  get '/articles/id'
  else
    render action: 'edit'
  end
end


puts
puts '                                 destroy(resourses) - удаление статьи'

# Все что нужно для удаления сущности это получить ее id

# Можно удалять через Pэилс консоль:
Article.find(10).destroy

# Есть несколько способов удаления: через форму или через кнопку (тут через кнопку)

# Добавим в файл articles/index.html.erb кнопку удаления статьи

# Добавим в articles_controller.rb метод destroy:
def destroy # post -> delete '/articles/id'
  @article = Article.find(params[:id]) # все что нам нужно для удаления это id
  @article.destroy

  redirect_to articles_path # перенаправляем на get '/articles' #index

  # по умолчанию возвращает destroy.html.erb
end


puts
puts '                             form_with. Паршал формы. Доп валидация на стороне браузера'

# По курсу Круковского и проекту AskIt

# form_with - начиная с новых версий(6?) рекомендуется использовать эту вспомогательную функцию для генерации формы

# Частичным представление(partial/паршал) - это такое представление которое рендерится само по себе, но не вставляется в лэйаут, нужны для того чтоб вставлять кусочки разметки на разных страницах

# контроллер
class QuestionsController < ApplicationController
  # ...
  def new
    @question = Question.new # создаем пустую сущность в памяти для генерации формы при помощи form_with
  end
  # ...
  def edit
    @question = Question.find_by id: params[:id] # находим сущность для заполнения form_with
  end
  # ...
end
# Для того чтобы избавиться от дублирования кода форм в edit и new, создадим фаил _form.html.erb, нижнее подчеркивание в начале имени указывает на то что данный фаил является не представлением, а частичным представлением(partial/паршал)


puts
puts '                                         flash/Флэш сообщения'

# Флэш сообщения(удобны для оповещения позьзователя о создании, изменении или удалении сущности) передаются в сессию и появляются только один раз и при перезагрузке страницы их уже не будет

# flash - это хранилище похожее на хэш но не являющееся хэшэм

# Удобнее всего отображать флэш сообщения в Лэйаут

# контроллер
class QuestionsController < ApplicationController
  # ...
  def create
    @question = Question.new question_params
    if @question.save
      flash[:success] = "Question created!"
      # Задаем ключ и значение для нашего флэш объекта, которые будем использовать в виде
      redirect_to questions_path
    else
      render :new
    end
  end
  # ...
  def update
    @question = Question.find_by id: params[:id]
    if @question.update question_params
      flash[:success] = "Question updated!"
      redirect_to questions_path
    else
      render :edit
    end
  end

  def destroy
    @question = Question.find_by id: params[:id]
    @question.destroy
    flash[:success] = "Question deleted!"
    redirect_to questions_path
  end
  # ...
end


puts
puts '                            Редирект по ссылке-якорю, после обновления сущности'

# На примере AskIt и сущности Answer создающейся в виде questions/show.html.erb

# 1. Допищем id для якоря в выводе каждого ответа в questions/show.html.erb

# 2а(Вариант 1 обычный). Добавим в answers_controller.rb в экшен update
def update
  if @answer.update answer_params
    flash[:success] = "Answer updated!"

    # Указываем доп параметры в хэлпер URL-а:
    redirect_to question_path(@question, anchor: "answer-#{@answer.id}") # редиректит на URL /questions/2#answer-6
    # anchor: "answer-#{@answer.id}"  - при помощи данного хэша редирект будет генерировать ссылку с указанным якорем
    # anchor: - ключ параметра-хэша, переводится как якорь, устанавливает значение хэша якорем в ссылку
    # "answer-#{@answer.id}" - значение которое и будет якорем
  else
    render :edit
  end
end

# 2б(Вариант 2 с хэлпером dom_id). Добавим в answers_controller.rb в экшен update
class AnswersController < ApplicationController
  include ActionView::RecordIdentifier # по умолчанию метод dom_id в контроллерах не работает, поэтому нужно его подключить, если хотим его применить и в контроллере, но можно просто наисать в контроллере якорб в ручную как выше, а хэлпер использовать только в видах

  def update
    if @answer.update answer_params
      flash[:success] = "Answer updated!"

      redirect_to question_path(@question, anchor: dom_id(@answer))
      # dom_id(@answer) - значение якоря
    else
      render :edit
    end
  end
end


puts
puts '                                Миграция обновления свойства поля'

# AskIt

# Сделаем миграцию которая запретит значения NULL в полях таблиц questions и answers(валидация на уровне БД)

# > rails g migration add_missing_null_checks

# db/migrate/20231119083044_add_missing_null_checks.rb
class AddMissingNullChecks < ActiveRecord::Migration[7.0]
  def change
    change_column_null :questions, :title, false
    # change_column_null - метод для того чтобы запретить/разрешить NULL в колонке
    # :questions, :title - названия таблицы и ее поля
    # false - означает, что в данной колонке значения NULL быть не может
    change_column_null :questions, :body, false
    change_column_null :answers, :body, false
  end
end

# > rails db:migrate

# Теперь в схеме эти колонки получили опцию null: false
t.string "title", null: false

# При такой миграции никакие данные потеряны не будут












#
