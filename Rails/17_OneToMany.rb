puts '                                          One-to-many (1 - *)'

# https://guides.rubyonrails.org/association_basics.html


# В генераторах есть возможность указывать reference columns - делать ссылки(foreign_key) на другие сущности

# reference columns создаются при помощи значения генератора belongs_to или reference (псевдонимы)


# Схема one-to-many: Article 1 - * Comment.
# Каждая статья имеет много комментариев. Тоесть к каждой сущностьи статьи относится много сущностей комментов, но при этом каждый коммент относится только к одной статье



puts '                         Article 1 - * Comment. Модели и миграции с ассоциациями'

# 1. Сгенерируем модель Comment со ссылкой на article:
# > rails g model Comment author:string body:text article:references
# или
# > rails g model Comment author:string body:text article:belongs_to
# :references / :belongs_to   -   дополнительный параметр, отвечающий за отношение между сущностями

# /db/migrate/12312314_create_comments.rb:
class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :author
      t.text :body

      # Вариант references (алиас к belongs_to)
      t.references :article, null: false, foreign_key: true # Создает столбец article_id являющийся foreign_key к id поля той статьи к которой относится коммент в таблице articles.

      # Вариант belongs_to (алиас к references)
      t.belongs_to :article, null: false, foreign_key: true  # в таблице укажет так если генерировали при помощи belongs_to

      # МБ belongs_to лучше использовать для связи 1 - * (сущности разных моделей), а references для таблиц одной сущности при нормализации (1 - 1) ??

      # Связи можно добавлять отдельной миграцией если в генераторе не указать article:references / article:belongs_to
      # можно добавить и тут вручную если данная миграция еще не была запущена

      t.timestamps
    end
  end
end

# /models/comment.rb:
class Comment < ApplicationRecord
  belongs_to :article # модель создалась с ассоциацией article. Тоесть комментарии принадлежат статье. Можно добавлять вручную если в генераторе не указать article:references
  # Comment.find(id).article - теперь можно обращаться от любого коммента к статье, которой он пренадлежит, через метод article
end
# > rails db:migrate

# schema.rb:
ActiveRecord::Schema[7.0].define(version: 2023_08_04_075512) do
  # ...
  create_table "comments", force: :cascade do |t|
    # ...
    t.integer "article_id", null: false # поле для foreign_key, что будет ссылться на поле id таблицы articles
    t.index ["article_id"], name: "index_comments_on_article_id"  # по умолчанию для foreign_key создается и индекс
  end
  add_foreign_key "comments", "articles"
end


# 2. /models/article.rb - допишем метод ассоциации вручную в модель Article
class Article < ApplicationRecord
  has_many :comments, dependent: :destroy # добавим ассоциацию comments, тоесть статья связывается с комментами (множественное число).
  # Article.find(id).comments - теперь можно обращаться от любой статьи к коллекции (массив) принадлежащих ей комментов через метод comments
  # dependent: :destroy  - параметр который и позволит удалять статьи у которых созданы принадлежащие им комменты. При этом удаляются и все связанные комменты (сначала удаляет комменты а потом саму статью)
end
# Таким образом мы связали 2 сущности между собой.


Article.find(1).comments                      # этот синтаксис аналогичен ...
Comment.where(article_id: Article.find(1).id) # ... этому(.id  - не обязательно)



puts '                         Создание связанных сущьностей в rails console. Метод build'

# https://mkdev.me/ru/posts/vsyo-chto-nuzhno-znat-o-routes-params-i-formah-v-rails  - доп инфа по созданию через build

# Посмотрим в rails console:
Article.comments           #=> будет ошибка тк у самой модели нет такого свойства comments
@article = Article.find(1) # но если создать объект с одной статьей ...
@article.comments          #=> ... то мы получаем доступ к списку всех комментов для этой статьи


# 1. Создание через create:
@article.comments.create(:author => 'Foo', :body => 'Bar') #=> создание коммента для данной статьи, через сущность статьи


# 2. Создание через метод build. (?? альтернатива new, но для связей ??) требует последующего save:

# Если к коллекции, например @article.comments, применить метод build, то создастся новый объект Comment, все поля которого будут со значением nil, за исключением aricle_id, которое будет соответствовать @article, те новый коммент будет привязан к этой статье. Этот объект пока не будет сохранен, для сохранения после нужно применить метод save

q = Question.first         #=> #<Question:0x0000024c7357e5b0  #->
# SELECT "questions".* FROM "questions" ORDER BY "questions"."id" ASC LIMIT ?  [["LIMIT", 1]]
q.answers                  #=> []  #->
# SELECT "answers".* FROM "answers" WHERE "answers"."question_id" = ?  [["question_id", 2]]
a = q.answers.build body: "My first answer" # создание методом build новый ответ от коллекции ответов
#=> #<Answer:0x0000024c7358dc90 id: nil, body: "My first answer", question_id: 2, created_at: nil, updated_at: nil>
a.save #=> true #->
# INSERT INTO "answers" ("body", "question_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["body", "My first answer"], ["question_id", 2], ["created_at", "2023-11-01 08:29:29.370745"], ["updated_at", "2023-11-01 08:29:29.370745"]]
q.answers #=> [ #<Answer:0x0000024c7358dc90 id: 1, body: "My first answer", question_id: 2, created_at: Wed, 01 Nov 2023 08:29:29.370745000 UTC +00:00, updated_at: Wed, 01 Nov 2023 08:29:29.370745000 UTC +00:00>]


# build и new работают с ассоциациями одинаково ?? Для рельсов 2.2 и более поздних версий new и build делают то же самое для отношений has_many и has_and_belongs_to_many.
q.answers.build #=> #<Answer:0x000001fa4a53f958 id: nil, body: nil, question_id: 4, created_at: nil, updated_at: nil>
q.answers.new   #=> #<Answer:0x000001fa47c4bc90 id: nil, body: nil, question_id: 4, created_at: nil, updated_at: nil>



puts '                             Article 1 - * Comment. Маршруты с ассоциациями'

# Создадим карту маршрутов по REST, но вложенный (одни ресурсы в других). Добавим в маршруты статей через блок маршруты комментариев в /config/routes.rb:
resources :articles do # Добавим сюда блок с маршрутами комментов, те сделаем вложенный маршрут:
  resources :comments, exсept: %i[new show]
end

# article_comments_path     GET      /articles/:article_id/comments          comments#index
# new_article_comment_path  GET      /articles/:article_id/comments/new      comments#new
#                           POST     /articles/:article_id/comments          comments#create
# article_comment_path      GET      /articles/:article_id/comments/:id      comments#show
# edit_article_comment_path GET      /articles/:article_id/comments/:id/edit comments#edit
#                           PATCH    /articles/:article_id/comments/:id      comments#update
#                           PUT      /articles/:article_id/comments/:id      comments#update
#                           DELETE   /articles/:article_id/comments/:id      comments#destroy
# Тут article_id то, что в маршрутах articles являлось id, тут id это айди коммента



puts '                         Article 1 - * Comment. Ассоциации в представлениях'

# 1. form_for:
# articles/show.html.erb - добавим форму для комментариев и вывод всех комментариев для статьи

# 2. form_with:
# questions/show.html.erb (Форма для ответа AskIt). Там же вывод всех ответов и хэлперы URL для создания пути для ссылки на связанную сущность.



puts '                         Article 1 - * Comment. Ассоциации в контроллерах'

# 1. Добавляем контроллер для комментариев
# > rails g controller Comments
# Для комментариев нам тут нужен только один метод - create, тк не будем с ним больше ничего делать, кроме добавления(POST), а форма и вывод для него будут на странице статьи к которой он относится(article#show).
class CommentsController < ApplicationController
  # Создадим метод create в /app/controllers/comments_controller.rb:
  def create # post '/articles/:article_id/comments'
    @article = Article.find(params[:article_id]) # используем :article_id тк это контроллер Comments и его карта маршрутов
    @article.comments.create(comment_params)     # создаем новый комментарий через сущность статьи

    redirect_to article_path(@article) # get '/articles/id'  articles#show
  end

  private

  def comment_params
    params.require(:comment).permit(:author, :body)
  end
end


# 2. (AskIt) answer_controller.rb
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
      @answers = @question.answers.order created_at: :desc # нужна тк используется в виде questions/show
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



puts '                                User 1 - * Some. Методы up и down'

# (На примере AskIt) Привяжем вопросы и ответы к пользователям(их авторам) что были созданы кастомно в CustomAutReg

# 1. Создадим новые миграции чтобы добавить user_id с foreign_key в существующие таблицы questions и answers
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
# В схему добавились все указанные ниже поля в таблицах(остальные поля тут опустим):
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
  has_many :questions, dependent: :destroy # User.find(1).questions
  has_many :answers, dependent: :destroy   # User.find(1).answers
end
class Question < ApplicationRecord
  belongs_to :user   # Question.find(1).user
end
class Answer < ApplicationRecord
  belongs_to :user   # Question.find(1).user
end


# 3. Задекорируем ассоциации для user (question.user, answer.user) при помощи спец синтаксиса прямо в декораторах вопросав и ответов, тк будем в представлениях применять к юзеру вызванному при помощи методов ассоциаций(взятому из таблицы) метод name_or_email(question.user.name_or_email, answer.user.name_or_email) и нам нужно чтобы юзер любого вопроса или ответа декорировался
class QuestionDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user # синтаксис автоматически декорирует ассоциацию юзера, получинную от вопроса
end
class AnswerDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user # синтаксис автоматически декорирует ассоциацию юзера, получинную от ответа
end


# 4. Вынесем в паршал _question.html.erb основной блок из questions/index.html.erb и добавим в него пользователя вызванного от ассоциации (с методом name_or_email)


# 5. Обновим код создания вопросов и ответов в их контроллерах, чтобы они создавались с привязкой к текущему юзеру:
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
    @answer = @question.answers.build answer_create_params # но у ответа уже есть привязка к вопросу при создании, потому добавим значение для user_id в params
    # @answer.user = current_user можно тут отдельно добавить значение для поля user_id вопроса вместо .merge(user: current_user) в методе answer_create_params
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
















#
