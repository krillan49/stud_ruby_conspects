puts '                               one-to-many. На примере Article 1 - * Comment'

# https://railsguides.net/advanced-rails-model-generators/
# https://guides.rubyonrails.org/association_basics.html
# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html


# Схема one-to-many: Article 1 - * Comment.
# Кадлая статья имеет много комментариев. Тоесть к каждой сущностьи статьи относится много сущностей комментов(принадлежат ей), но при этом каждый коммент относится только к одной статье

# В генераторах есть возможность указывать reference columns - делать ссылки на другие сущности
# reference columns создаются при помощи значения генератора belongs_to или reference (псевдонимы)

# 1. Создадим модель Comment со ссылкой на article:
# > rails g model Comment author:string body:text article:references
# или
# > rails g model Comment author:string body:text article:belongs_to
# :references / :belongs_to   -   дополнительный параметр, отвечающий за отношение между сущностями
# Создалось:
# /db/migrate/12312314_create_comments.rb:
class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :author
      t.text :body

      # Вариант references (алиас к belongs_to)
      t.references :article, null: false, foreign_key: true # Создает столбец article_id являющийся foreign_key к id поля той статьи к которой относится коммент в таблице articles.
      # Тоже можно добавлять отдельной миграцией если в генераторе не указать article:references
      # можно добавить вручную если данная миграция еще не была запущена

      # Вариант belongs_to (алиас к references)
      t.belongs_to :article, null: false, foreign_key: true  # в таблице укажет так если генерировали при помощи belongs_to

      # МБ belongs_to лучше использовать для связи 1 - * (сущности разных моделей), а references для таблиц одной сущности при нормализации (1 - 1) ??

      t.timestamps
    end
  end
end
# /models/comment.rb:
class Comment < ApplicationRecord
  belongs_to :article # модель создалась с ассоциацией article. Тоесть комментарии принадлежат статье. Можно добавлять вручную если в генераторе не указать article:references
  # Comment.find(id).article - теперь можно обращаться от любого коммента к статье которой он пренадлежит через метод article
end
# > rake db:migrate   # или > rails db:migrate

# schema.rb Посмотрим на таблицы articles и comments
ActiveRecord::Schema[7.0].define(version: 2023_08_04_075512) do
  create_table "articles", force: :cascade do |t|
    # ...
  end

  create_table "comments", force: :cascade do |t|
    # ...
    t.integer "article_id", null: false # поле для foreign_key ссылающееся на поле id таблицы articles
    t.index ["article_id"], name: "index_comments_on_article_id"  # по умолчанию для foreign_key создается и индекс
  end

  add_foreign_key "comments", "articles"
end


# 2. Допишем вручную в модель уже Article  /models/article.rb ...
class Article < ApplicationRecord
  has_many :comments # добавим ассоциацию comments, тоесть статья связывается с комментами (множественное число).
  # Article.find(id).comments - теперь можно обращаться от любой статьи к коллекции (массив) принадлежащих ей комментов через метод comments
end
# Таким образом мы связали 2 сущности между собой.


# Дополнение1:
Article.find(1).comments # этот синтаксис аналогичен ...
Comment.where(article_id: Article.find(1).id) # ... этому(.id  - не обязательно)

# Посмотрим в rails console:
Article.comments           #=> будет ошибка тк у самой модели нет такого свойства comments
@article = Article.find(1) #=> но если создать объект с одной статьей ...
@article.comments          #=> ... то мы получаем доступ к списку всех комментов для этой статьи

# Создание через create:
@article.comments.create(:author => 'Foo', :body => 'Bar') #=> создание коммента для данной статьи, через сущность статьи

# Создание через build:
q = Question.first         #=> #<Question:0x0000024c7357e5b0  #->
# SELECT "questions".* FROM "questions" ORDER BY "questions"."id" ASC LIMIT ?  [["LIMIT", 1]]
q.answers                  #=> []  #->
# SELECT "answers".* FROM "answers" WHERE "answers"."question_id" = ?  [["question_id", 2]]
a = q.answers.build body: "My first answer" # метод build(?? альтернатива new но для связей ??) требует последующего save
#=> #<Answer:0x0000024c7358dc90 id: nil, body: "My first answer", question_id: 2, created_at: nil, updated_at: nil>
a.save #=> true #->
# INSERT INTO "answers" ("body", "question_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["body", "My first answer"], ["question_id", 2], ["created_at", "2023-11-01 08:29:29.370745"], ["updated_at", "2023-11-01 08:29:29.370745"]]
q.answers #=> [ #<Answer:0x0000024c7358dc90 id: 1, body: "My first answer", question_id: 2, created_at: Wed, 01 Nov 2023 08:29:29.370745000 UTC +00:00, updated_at: Wed, 01 Nov 2023 08:29:29.370745000 UTC +00:00>]

# build и new работают с ассоциациями одинаково ?? Для рельсов 2.2 и более поздних версий new и build делают то же самое для отношений has_many и has_and_belongs_to_many.
q.answers.build #=> #<Answer:0x000001fa4a53f958 id: nil, body: nil, question_id: 4, created_at: nil, updated_at: nil>
q.answers.new   #=> #<Answer:0x000001fa47c4bc90 id: nil, body: nil, question_id: 4, created_at: nil, updated_at: nil>

# https://mkdev.me/ru/posts/vsyo-chto-nuzhno-znat-o-routes-params-i-formah-v-rails  - доп инфа по созданию через build


# 3. Добавим в маршруты статей через блок маршруты комментариев в /config/routes.rb:
resources :articles do # Добавим сюда блок с маршрутами комментов, те сделаем вложенный маршрут:
  resources :comments, exсept: %i[new show] # создает карту маршрутов по REST, но вложенный (одни ресурсы в других)
  # exсept: %i[new show] - создает все маршруты кроме указанных в параметре-массиве
end
# article_comments_path     GET      /articles/:article_id/comments          comments#index
# new_article_comment_path  GET      /articles/:article_id/comments/new      comments#new
#                           POST     /articles/:article_id/comments          comments#create
# article_comment_path      GET      /articles/:article_id/comments/:id      comments#show
# edit_article_comment_path GET      /articles/:article_id/comments/:id/edit comments#edit
#                           PATCH    /articles/:article_id/comments/:id      comments#update
#                           PUT      /articles/:article_id/comments/:id      comments#update
#                           DELETE   /articles/:article_id/comments/:id      comments#destroy
# Тут article_id то что в маршрутах articles являлось id, тут id это айди коммента


# 4a. Добавим форму для комментариев на '/articles/id'  articles/show.html.erb (Вывод комментариев там же)
# 4b. Либо вариант для form_with(там же про путь ссылки на связанную сущность) и проекта AskIt questions/show.html.erb


# 5a. Добавляем контроллер для комментариев
# > rails g controller Comments
# Для комментариев нам(тут) нужен только один метод - create, тк не будем с ним больше ничего делать, кроме добавления(POST), а форма для него и вывод будут на странице статьи к которой он относится(article#show).
class CommentsController < ApplicationController
  # Создадим метод create в /app/controllers/comments_controller.rb:
  def create # post '/articles/:article_id/comments'
    @article = Article.find(params[:article_id]) # используем :article_id тк это контроллер Comments и его карта маршрутов
    @article.comments.create(comment_params) # создаем комментарий через сущность статьи

    redirect_to article_path(@article) # get '/articles/id'  articles#show
  end

  private

  def comment_params
    params.require(:comment).permit(:author, :body)
  end
end

# 5b. (AskIt) answer_controller.rb
class AnswersController < ApplicationController
  before_action :set_question!
  before_action :set_answer!, except: :create
  # Порядок before_action-ов важен, тк нам сначала нужно найти вопрос и уже потом из его коллекции найти ответ

  def create # post '/questions/:question_id/answers'
    @answer = @question.answers.build answer_params # создаем сущность при помощи метода build
    if @answer.save
      flash[:success] = "Answer created!"
      redirect_to question_path(@question)
    else
      @answers = @question.answers.order created_at: :desc # нужен тк используется в виде что рендерится ниже
      render 'questions/show'  # рэндерим вид из папки другого контроллера, тот где наша форма
    end
  end

  def edit
    # set_answer!
  end

  def update
    if @answer.update answer_params # set_answer!
      flash[:success] = "Answer updated!"
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy # delete(get ??) '/questions/:question_id/answers/:id'
    @answer.destroy # set_answer!
    flash[:success] = "Answer deleted!"
    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question!
    @question = Question.find params[:question_id]
  end

  def set_answer!
    @answer = @question.answers.find params[:id]
  end
end

# Экшен show контроллера Question
def show
  # @question = Question.find params[:id]  - приходит из метода set_question!
  @answer = @question.answers.build
  @answers = @question.answers.order created_at: :desc
end


# 6. Настроим владеющую модель чтобы можно было удалять вопрос со всеми зависимыми ответами(сперва удаляет ответы а потом вопрос)
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  # dependent: :destroy  - параметр который и позволит нам удалять вопросы у которых созданы принадлежащие им ответы
end


puts
puts '                         User 1 - * Question. User 1 - * Answer. Методы up и down'

# (На примере AskIt) Привяжем вопросы и ответы к пользователям(их авторам) что были созданы кастомно в Reg_Aut_Dec

# 1. Создадим новые миграции чтобы добавить user_id с foreign_key в таблицы questions и answers
# > rails g migration add_user_id_to_questions user:belongs_to
# > rails g migration add_user_id_to_answers user:belongs_to
# user:belongs_to - параметр создающий новое поле user_id с foreign_key к id в таблице users
# Создались миграции:
class AddUserIdToQuestions < ActiveRecord::Migration[7.0]
  def change
    # add_user_id_to_questions - изза такого правильного названия с именами таблиц, автоматически заполнилось:
    add_reference :questions, :user, null: false, foreign_key: true, default: User.first.id
    # Но если прямо так запустить миграцию, то опция null: false вызовет ошибку и миграция не пройдет изза того, что значение поля user_id не может быть пустым, но у уже ранее созданных записей оно пустое, а в прдакшене удалить существующие записи - не очень тема, потому, чтобы миграция прошла нужно будет обойти это при помощи временного значения по умолчанию:
    # default: User.first.id - поставит в старые записи в колонку user_id вместо NULL дефолтное значение с айди этого юзера (мб придумать специального юзера для этого, например с именем "Аноним")
  end
end
class AddUserIdToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :user, null: false, foreign_key: true, default: User.first.id # тоже добавим дефолтного юзера
  end
end
# > rails db:migrate
# В схему добавились все указанные ниже поля в таблицах(остальные поля тут опустим/не напишем в примере):
ActiveRecord::Schema[7.0].define(version: 2023_12_29_124632) do
  create_table "answers", force: :cascade do |t|
    t.integer "user_id", default: 1, null: false
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "user_id", default: 1, null: false
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  add_foreign_key "answers", "users"
  add_foreign_key "questions", "users"
end
# Теперь удалим временное значения User.first.id из полей user_id при помощи еще одной миграции
# > rails g migration remove_default_user_id_from_questions_answers
class RemoveDefaultUserIdFromQuestionsAnswers < ActiveRecord::Migration[6.1]
  # В миграции заменим метод change на методы up и down:

  def up # этот метод вызывается при применении миграции  > rails db:migrate
    change_column_default :questions, :user_id, from: User.first.id, to: nil
    # from: User.first.id, to: nil - не обязательно(но не лишне) писать это при использовании методов up и down
    change_column_default :answers, :user_id, from: User.first.id, to: nil
    # Тоесть когда мы применим данную миграцию, мы заменим значения User.first.id в user_id в таблицах на пустое
  end

  def down # этот метод вызывается при откате миграции  > rails db:rollback
    change_column_default :questions, :user_id, from: nil, to: User.first.id
    # from: nil, to: User.first.id - не обязательно(но не лишне) писать это при использовании методов up и down
    change_column_default :answers, :user_id, from: nil, to: User.first.id
    # Тоесть когда мы откатим данную миграцию, мы обратно заполним значением User.first.id пустые значения user_id в таблицах
  end

  # Все тоже самое можно было бы сделать и используя метод change, но тогда писать from: User.first.id, to: nil обязательно иначе будет неоткатываемо
end
# > rails db:migrate
# В схеме изменились поля
ActiveRecord::Schema[7.0].define(version: 2023_12_29_130823) do
  create_table "answers", force: :cascade do |t|
    t.integer "user_id", null: false # значения default: 1 больше нет
  end

  create_table "questions", force: :cascade do |t|
    t.integer "user_id", null: false # значения default: 1 больше нет
  end
end
# Но мы можем эту миграцию откатить, если передумали и хотим вернуть значение default: User.first.id
# > rails db:rollback (!!! почемуто с откаченной миграцией выдает ошибку и нужно обязательно снова ее выполнить)


# 2. Добавим новые ассоциации в модели
class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
end
class Question < ApplicationRecord
  belongs_to :user
end
class Answer < ApplicationRecord
  belongs_to :user
end


# 3. Задекорируем ассоциации для user (question.user, answer.user) при помощи спец синтексиса прямо в декораторах вопросав и ответов, тк будем в представлениях применять к юзеру вызванному при помощи методов ассоциаций(взятому из таблицы) метод name_or_email и нам нужно чтобы юзер любого вопроса или ответа декорировался
class QuestionDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user # синтаксис автоматически декорирует ассоциацию юзера, получинную от вопроса
end
class AnswerDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user # синтаксис автоматически декорирует ассоциацию юзера, получинную от ответа
end


# 4. Вынесем в паршал _question.html.erb основной блок из questions/index.html.erb и добавим в него пользователя вызванного от ассоциации (с методом name_or_email)


# 5. Обновим код создания вопросов и ответах в их контроллерах, чтобы они создавались с привязкой к текущему юзеру
# questions_controller.rb
def create
  @question = current_user.questions.build question_params # изменим c Question.new(question_params)
  # тоесть создаем вопрос от текущего пользователя и применяем build вместо new
  # ...
end
# answers_controller.rb
class AnswersController < ApplicationController
  # ... set question и прочее

  def create
    @answer = @question.answers.build answer_create_params # но у ответа уже есть привязка при создании, потому добавим значение для user_id в params
    # @answer.user = current_user можно тут написать вместо .merge(user: current_user) в методе answer_create_params
    # ...
  end

  def update
    if @answer.update answer_update_params
    # ...
  end

  private

  # Сделаем разные параметры для create и update, тк для второго уже будет и так существовать user_id и меняться он не будет

  def answer_create_params
    params.require(:answer).permit(:body).merge(user: current_user) # просто добавляем значение через метод хэшей
    # merge(user: current_user) - упрощенная запись от merge(user_id: current_user.id)
  end

  def answer_update_params
    params.require(:answer).permit(:body)
  end

  # ...
end


# Дополнительно(не относится к основной теме) вынесем повторяющийся код из экшенов контроллеров вопросов и ответов в отдельный метод нового консерна questions_answers.rb, тк далее он будет еще и 3м контроллере
# answers_controller.rb
def create
  @answer = @question.answers.build answer_create_params # разница тут
  if @answer.save
    flash[:success] = t '.success'
    redirect_to question_path(@question)
  else
    # далее наш повторяющийся код для выноса в метод консерна:
    @question = @question.decorate
    @pagy, @answers = pagy @question.answers.order created_at: :desc
    @answers = @answers.decorate
    render 'questions/show' # разница тут
  end
end
# questions_controller.rb
def show
  @question = @question.decorate
  @answer = @question.answers.build # разница тут
  @pagy, @answers = pagy @question.answers.order(created_at: :desc)
  @answers = @answers.decorate
end
# Заменим на
class AnswersController < ApplicationController
  include QuestionsAnswers # подключаем консерн
  # ...

  def create
    @answer = @question.answers.build answer_create_params
    if @answer.save
      flash[:success] = t '.success'
      redirect_to question_path(@question)
    else
      load_question_answers(do_render: true) # вызываем метод консерна с параметром true для render 'questions/show'
    end
  end
end
class QuestionsController < ApplicationController
  include QuestionsAnswers # подключаем консерн
  # ...

  def show
    load_question_answers # вызываем метод консерна
  end

  # ...
end



puts
puts '                               Отображение аватаров юзера при помощи Gravatar'

# Покачто упрощенная реализация через Gravatar, без загрузки в БД

# https://docs.gravatar.com/general/images/
# Gravatar - это сторонний сервис(сайт) глобальных аватаров, те для привязки аватара к имэйлу, чтобы автоматически использовать его на других сайтах
# Нужно зарегаться на сайте граватара, загрузить туда аватарку и привязать ее к имэйлу, далее при использовании этого имэйла на других сайтах, если они поддерживают Gravatar, будет отображаться данная аватарка
# Gravatar хэширует имэил пользователя и добавляет к адресу ссылки, ведущему к аватарке, например так https://gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50 и потом аватар на нашем сайте можно применить, например через тег картинки <img src="https://gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50" />. Удобно что можно настраивать размер. Если пользователь не использует граватар, то будет аватар по умолчанию

# 1. Создадим метод граватара в декораторе юзера user_decorator.rb
class UserDecorator < ApplicationDecorator
  # ...
  def gravatar(size: 30, css_class: '')
    email_hash = Digest::MD5.hexdigest email.strip.downcase # генерируем хэш на основе имэйла пользователя (обрезаем пробелы и помещаем в нижний регистр - это требования граватара)
    h.image_tag "https://www.gravatar.com/avatar/#{email_hash}.jpg?s=#{size}", class: "rounded #{css_class}", alt: name_or_email
    # h - объект префикса, обозначает что мы хотим использовать хэлпер Рэилс (?? это для граватара или декоратора надо ??)
    # image_tag - хэлпер для генерации тега <img ...>
    # email_hash - помещаем сгенерированный выше хэш в адрес изображения
    # size - опция размера картинки, по умолчанию установлена в атрибутах
    # css_class - можем так же применить сразу стили, по умолчанию нет
  end
end

# 2. Применим в _quesion.html.erb метод gravatar к объекту юзера, а так же в shared/_menu.html.erb рядом с именем текущего юзера
# Далее можно применить тоже самое на всех страницах, где мы отображам зависимые от юзера сущьности: questions/show.html.erb, answers/_answer.html.erb


puts
puts '                                 callbacks(функции обратного вызова)'

# https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html
# https://guides.rubyonrails.org/active_record_callbacks.html

# Не очень правильно что каждый раз при выводе аватарки при помощи граватара мы в декораторе постоянно пересчитываем хэш имэйла, тк на странице может быть куча этих аватарок. И так как хэш одной и той же строки всегда получается одинаковым, то лучше сохранять этот хэш в БД для каждого юзера(закэшировать)

# Создадим новую миграцию чтобы добавить поле для хэшей в таблицу users:
# > rails g migration add_gravatar_hash_to_users gravatar_hash:string
class AddGravatarHashToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :gravatar_hash, :string # прописалось автоматически тк правильный синтаксис при генерации
  end
end
# > rails db:migrate

# Хэш нам нужно будет генерировать и заносить в БД когда регистрируется новый пользователь, а так же когда пользователь меняет свой имэйл(тк хэшируется имэйл). Для этого нам и пригодятся функции обратного вызова
# Функции обратного вызова можно прописывать в моделях

# Пропишем колбэк в модели user.rb
class User < ApplicationRecord
  # ... аксессоры, ассоциации, валидации

  before_save :set_gravatar_hash, if: :email_changed?
  # before_save - колбэк, который выполняется каждый раз, когда запись сохраняется в БД (как новая так и апдэйт)
  # :set_gravatar_hash - метод(ниже) который будет исполнен колбэком (но можно прямо тут передать и лямбду или процедуру)
  # if: - означет что для выполнения колбека существует условие
  # :email_changed? - условие выполнения колбэка, тут проверяется методом, который автоматически создает Рэилс, он проверяет, был ли изменен имэйл сущности

  # ... методы

  private

  def set_gravatar_hash
    return if email.blank? # выходим если нет имэйла
    hash = Digest::MD5.hexdigest email.strip.downcase # посчитаем хэш из имэйла так же как в декораторе
    self.gravatar_hash = hash # присваиваем в метод поля/свойства/имя колонки текущей записи(юзера). Тоесть перед тем как сохранить юзера (новый или апдэйт), к нему добавится это значение
  end
  # ...
end
# Теперь можем не считать в декораторе хэш и соотв удалить email_hash = Digest::MD5.hexdigest email.strip.downcase
class UserDecorator < ApplicationDecorator
  # ...
  def gravatar(size: 30, css_class: '')
    h.image_tag "https://www.gravatar.com/avatar/#{gravatar_hash}.jpg?s=#{size}", class: "rounded #{css_class}", alt: name_or_email
    # gravatar_hash - теперь просто используем значение взятое из свойства юзера (БД)
    # можно было бы сохранять не только хэш а весь URL, но малоли детали ссылки изменятся в новых версиях граватара
  end
end

# Но у нас в БД до добавления этого функционала уже могли быть юзеры и нам надо посчитать хэши их имэйлов и добавить в БД в соот колонку этих юзеров.
# Для этого воспользуемся db/seeds.rb, чтобы заполнить БД этими данными.
# Предварительно закоментим старые наполнения(код что был ранее, у нас Фэйкер), чтоб они не сработали поторно
User.find_each do |u| # тоесть для каждого юзера проделаем:
  u.send(:set_gravatar_hash) # применим к юзерам метод модели set_gravatar_hash (через send чтобы обойти private)
  u.save # сохраняем юзера(обновляем его запись в БД)
end
# > rails db:seed













#
