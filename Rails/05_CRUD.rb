puts '                                   CRUD. Формы. Валидация. Паршалы'

# CRUD - аббревиатура обозначающая основыные операции:
# Create - (new)              .create; .new.save
# Read   - (index | show)     .where; .find(3); .all
# Update - (update)
# Delete - (destroy)

# https://github.com/rails/strong_parameters
# https://guides.rubyonrails.org/action_controller_overview.html#more-examples



puts '                                   new(resourses). form_for. render'

# https://guides.rubyonrails.org/form_helpers.html

# 1. Создадим представление app/views/articles/new.html.erb. Без него при запросе GET /articles/new выпадет ошибка
# В articles/new.html.erb создаем форму при помощи форм билдера form_for (устарел ??) и необходимые поля для нее

# 2. app/controllers/articles_controller.rb - добавим в контроллер экшен create для обработки данных формы из new.html.erb:
class ArticlesController < ApplicationController
  def new # get '/articles/new'
    # по умолчанию рендерит new.html.erb
  end
  def create # post '/articles'

    # https://rusrails.ru/layouts-and-rendering   -  про рэндеринг

    # render - метод для возврата/вывода данных из экшена в лэйаут. Выводит по URL того экшена, из которого вызывавется, тут это create: post '/articles'.

    # Рендер каких то данных:
    render plain: params[:article].inspect
    # plain: - ключ обозначает что будет выведен просто текст;
    # params[:article].inspect - значение хеша params, тут параметры в виде строки;
    # В итоге выведет: #<ActionController::Parameters {"title"=>"какойто тайтл", "text"=>"какой то текст"} permitted: false>.

    # Рендер представлений. К представлениям применяет переменные из экшена из которого рендерим:
    render action: 'new'     # полный вариант записи
    # render  - метод для передачи данных (разных форматов) из экшена, сохраняет данные из экшена, например переменные
    # action: - ключ для имени представления, которое будем рендерить (?? нужен, если хотим указать еще какие-то опции)
    # 'new'   - имя представления по которому будет сгенерирована HTML-страница
    render 'new'             # сокращенный вариант записи
    render :new              # сокращенный вариант записи
    render 'articles/create' # можно вывести представления по имени директори и фаила в каталоге views, так можно выводить представления из других контроллеров

    # Рендер представления без Лэйаут:
    render partial: 'shared/menu'
    # render partial:  - говорит о том что рендерим именно паршал, а не полноценный вид, так будет рендерить без лэйаута, а по умолчанию рэндерит с ним

    # Передача дополнительной локальной переменной при рендере
    render partial: 'shared/menu', locals: { var: 'Kroker' }
    # locals: { var: val } - создается локальная переменная var со значением 'Kroker', которую можно применять в представлении

    # Рендер статических страниц без вставки их в Лэйаут:
    render file: 'public/404.html', status: :not_found, layout: false
    # file:              -  ключ означает что рендерим фаил
    # 'public/404.html'  -  рендерим фаил 404.html из директории public. Фаилы из директории public не проходят через Рэилс приложения, те вставок на Руби иметь не могут, это просто обычные статические HTML-фаилы, которые сгенерированы приложением, при желании можно его модифицировать вручную.
    # layout: false      -  опция выводит HTML-фаилы без интеграции его в layout

    # Рендер на страницу json из переменной some
    render json: some
    # не нужно представление some/index.json тк это просто рендер json на страницу

    # Рендер обычного текста
    render text: "Some text"

    # по умолчанию(если сами не пропишем render) рэндерит представление с именем данного экщена из директории с именем данного контроллера, тоесть тут create.html.erb
  end
end
# На данный момент страницу /articles пользователь не сможет открыть вручную, тк для нее сейчас есть только POST-обработчик(create), но нет GET-обработчика(index)



puts '                             Запись в БД. Разрешение на использование атрибутов'

# /app/controllers/contacts_controller.rb
class ContactsController < ApplicationController
  def new
  end

  def create # принимает данные, введенные пользователем в форму
    # можно в принципе принимать в столбик или хэш как в синатре с АР и это норм сработает, но так никто не делает
    @contact = Contact.create(params[:contact][:email], params[:contact][:message])

    # Вместо этого можно передать весь хэш params[:contact] сразу, тк выше один фиг хэш
    @contact = Contact.new(params[:contact]) # Но если принимать параметры так, то при нажатии кнопки формы вылезет ошибка: ActiveModel::ForbiddenAttributesError in ContactsController#create, тк это не безопасно, тк там могут быть всякие параметры отправленные злоумышоенниками, а мы их не заметим тк не прописываем вручную

    # Атрибуты params[:some] по умолчанию запрещены и их нужно разрешить, для этого создадим приватный метод contact_params, но можно былоб прописать и тут:
    @contact = Contact.new(contact_params) # вместо params[:contact] вызываем наш разрешающий метод
    @contact = Contact.new(params.require(:contact).permit(:email, :message)) # либо прописываем тут

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



puts '                                  Валидация(AR) и сообщения об ошибках'

# (?? Потом вынести валидации в отдельный фаил ??)

# (! Потом проверить все это в консоли !)
# new - возвращает объкт с заполненными полями, но id у него nil, тк оно назначается уже при сохранении базй данных
# Валидация производится когда применяется метод save, create, update. Если валидация не проходит, то create возвращает объект все поля которого равны nil.
# Если применить к объекту методы valid?, save или update то вернет false если валидаци не пройдены, либо true, если валидация прошла

# 1. Валидацию надо добавить в модель, тут /app/models/contact.rb
class Contact < ApplicationRecord
  validates :email, presence: true
  validates :message, presence: true
end

# 2. Исправим код в методе create в контроллере /app/controllers/contacts_controller.rb:
def create
  @contact = Contact.new(contact_params)
  if @contact.valid? # это можно не писать и тут сразу написать @contact.save
    @contact.save # содается сущность и строка в БД(создастся до возврата вида)
    # по умолчанию(если сами не пропишем render) рэндерит представление с именем данного экщена из директории с именем данного контроллера, тоесть create.html.erb, либо выдает ошибку если его нет
  else
    # а если не валидно отрендерим/вернем нашу форму new.html.erb(но уже на URL /contacts) при помощи render, с переменными уже из данного экшена create, а не из new:
    render 'new'
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



puts '                                          Паршалы(partials)'

# partial/паршал (Частичное представление) - это такое представление которое не вставляется в лэйаут, а рендерится само по себе, например в коде полноценной вьюхи. Нужны для того чтоб вставлять одни и теже кусочки разметки в разные вьюхи

# Нижнее подчеркивание в начале имени указывает на то, что данный фаил является не представлением, а паршалом. Но при рендере в какойто вьюхе нижнее подчеркивание не нужно

# Рендер одиночного аршала в представлении
render 'contacts/contact', contact: @contact
render 'contact', contact: @contact # аналог того что выше (если представление и парша в одной директории)
render @contact # аналог того что выше. Рэилс из названия класса объекта определит название паршала, переведя в снэйккейс и добавив подчеркивание в начале и попробует найти этот фаил в соответсвующей папке, если найдет то передаст в него одноименную локальную переменную с объектом из инстанс переменной

# Рендер коллекции паршалов в представлении (пример и более подробно на questions/show)
render partial: 'answers/answer', collection: @answers, as: :answer
render @answers # аналог того что выше

# shared - ?общепринятое название? для дирректории для общих паршалов, тоесть используемых во вьюхах разных контроллеров

# shared/_errors.html.erb - создадим этот паршал и поместим в него сообщения об ошибках. Рэндерим его в паршал или вид с формой

# /app/views/contacts/new.html.erb  - добавим сообщение об ошибках при помощи паршала.



puts '                                          index(resourses)'

# index(resourses) - обычно используется для вывода списка всех сущностей(тут выведем все статьи)

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
  # Добавим в create.html.erb ссылку на все статьи '/articles'

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



puts '                           PRG(Post Redirect Get). redirect_to. show(resourses)'

# Если отрендрить и отправить вид на тот же URL, что мспользовался пост запросом(тут post '/articles' articles#create), если потом пользователь обновит эту страницу, то произойдет повторная отправка формы(выскакивает предупреждение от браузера), что может вызвать проблемы например 2йной покупки и 2йного списания денег

# PRG(Post Redirect Get) - паттерн для предотвращения двойного сабмитта. Тоесть POST-запрос вместо рендера вида совершает перенаправление на GET-запрос.

# Для этого в нашем случае добавим redirect_to @article в метод create
class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article  # перенаправляет на GET /article/id articles#show. Тогда вид create.html.erb будет уже не нужен.
      # redirect_to получает сущность из @article и делает редирект по ее айди(те посылает браузеру указание (с кодом 302) перейти на другую страницу). Редирект происходит на стороне браузера, те новый get-запрос.
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



puts '                                     разница между render и redirect_to'

#  https://stackoverflow.com/questions/7493767/are-redirect-to-and-render-exchangeable

# render (возврат вида по умолчанию это тоже рендер) - когда пользователь обновляет страницу, он снова отправит предыдущий запрос POST. Это может привести к нежелательным результатам, таким как повторная покупка и другие. Соответвенно используем только в безопасных случаях, например когда не прошла валидация и данные не отправлены в БД

# redirect_to - когда пользователь обновляет страницу, он просто снова запросит ту же страницу. Это также известно как шаблон Post/Redirect/Get (PRG). После обработки post запроса браузеру возвращается маленький пакет(тк не содержит представлений итд, а только управляющую команду), браузер автоматически исполняет команду и отправляет GET-запрос

# В том числе и по этому в обработчиках GET-запросов не совершаюттся никакие опасные действия меняющие данные в БД, чтобы обновления не привели к 2йным отправкам данных и пользователь мог переходить по страницам безопасно.



puts '                               edit, update (resourses) - pедактирование статьи'

# https://guides.rubyonrails.org/routing.html#path-and-url-helpers  - _path методы

# Добавим ссылку на редактирование в articles/index.html.erb

# Добавим в /app/controllers/articles_controller.rb:
def edit #  get '/articles/id/edit'
  @article = Article.find(params[:id])
  # по умолчанию возвращает edit.html.erb
end
# Создадим вид /app/views/articles/edit.html.erb c формой для редактирования

# Добавим в контроллер /app/controllers/articles_controller.rb:
def update  # post -> put '/articles/id'
  @article = Article.find(params[:id])
  if @article.update(article_params) # update - метод для обновления/изменения сущности
    redirect_to @article # перенаправление на show  get '/articles/id'
  else
    render action: 'edit'
  end
end


# (AR ? потом перенсти в AR ??) Вместо применения update можно еще менять так
@article = Article.find(params[:id])
@article.title = 'jhfghjfghg'
@article.save # тут сохраняет объект в БД



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

  # по умолчанию рендерит destroy.html.erb
end



puts '                             form_with. Доп валидация на стороне браузера'

# form_with - начиная с новых версий(6?) рекомендуется использовать эту вспомогательную функцию для генерации формы

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

# Для того чтобы избавиться от дублирования кода форм в edit и new, создадим паршал question/_form.html.erb и будем рендерить его в представлениях question/new и question/edit



puts '                                          flash сообщения'

# Протокол HTTP не сохраняет состояние между запросами, потому без дополнительных действий мы не можем отследить, что 2 запроса пришли от одного и того же пользователя.
# Создание, изменение или удаление сущьности мы заканчиваем редиректом (код 302), тоесть новым гет запросом от браузера, тесть в сумме будет 2 запроса (на манипуляцию с сущьностью и гет зпрос редиректа)
# Задача при манипуляции с сущьностью показать одноразовое сообщение только для этого юзера

# Флэш сообщения передаются в сессию (при помощи механизма куки) и работают только в 2х запросах при текущем зпросе и при следующем запросе, тоесть будет видно один раз при редиректе (тк после нашего запроса баузер деолает еще один) и 2 раза при рендере (тут чтобы при перезагрузке страниы сообщение не дублировалось нужно применить метд now). При третьем запросе, их уже не будет. Удобны, например для оповещения пользователя о создании, изменении или удалении сущности

# flash - это хранилище похожее на хэш но не являющееся хэшэм, может вызываться и в контроллерах и в видах

# Удобнее всего отображать флэш сообщения в layouts/application.html.erb (код там)

# контроллер
class QuestionsController < ApplicationController
  # ...
  def create
    @question = Question.new question_params
    if @question.save
      # Вариант 1 (отдельно присвоить во flash объкт по ключу сообщение ?можно ли так несколько передать?)
      flash[:success] = "Question #{@question.title} created!" # можем сразу использовать имя созданной сущности в сообщении
      # Задаем ключ(:success) и значение для нашего флэш объекта, которые будем использовать в лэйаут
      redirect_to questions_path

      # Вариант 2 (прямо в режиректе передать через ключ хэша)
      redirect_to questions_path, notice: "Question #{@question.title} created!"
      # "notice:" аналогично "flash[:notice] ="
    else
      flash.now[:warning] = "Incorrect data"
      # now - метод чтобы флэш сообщение отрисовывалось только при одном запарпосе (текущем), а не при 2х как по умолчанию, тк иначе при перезагрузке страницы флэш-сообщение отобразится еще раз
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



puts '                            Редирект по ссылке-якорю, после обновления сущности'

# На примере AskIt и сущности Answer создающейся в виде questions/show.html.erb

# 1. Допищем id для якоря в выводе каждого ответа в questions/show.html.erb

# 2а(Вариант 1 обычный). Добавим в answers_controller.rb в экшен update
def update
  if @answer.update answer_params
    flash[:success] = "Answer updated!"

    # Указываем доп параметры(#answer-6) в хэлпер URL-а:
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
  include ActionView::RecordIdentifier # по умолчанию метод dom_id в контроллерах не работает, поэтому нужно его подключить, если хотим его применить и в контроллере, но можно просто наисать в контроллере якорь в ручную как выше, а хэлпер использовать только в видах

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














#
