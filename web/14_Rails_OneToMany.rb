puts '                                            Типы связей(AR)'

# Существует множество типов связей, но среди них есть 3 основные: one-to-many, one-to-one, many-to-many
# http://rusrails.ru/active-record-associations

# 1. one-to-many (1 - *)
# Article            |  Comment
# has_many :comments |  belongs_to :article
# id                 |  id, article_id

# 2. one-to-one (1 - 1) - помогает нормализовать БД(не нужно в orders держать все поля адреса, а только айди отдельно сделанной для этого таблицы. Те делим данные из формы на 2 связанные таблицы для удобства)
# Order              |  Address
# has_one :address   |  belongs_to :order
# id                 |  id, order_id
# Нормализация - разбитие на подтаблицы, денормализация - обобщение в одну таблицу. Минус нормализованного подхода в усложнении SQL запроса, иногда может повлиять на скорость.

# 3. many-to-many (* - *) - Есть статьи и теги(категории), у каждого тега есть много статей и у каждой статьи есть много тегов. для связи между ними создаётся ещё одна таблица tags_articles состоит только из 2х столбцов tag_id, article_id, тк недостаточно 2х таблиц для реализации. В Рэилс доп таблица создается автоматически
# Tag                               |                        |  Article
# таблица tags                      |  таблица tags_articles |  таблица articles
# id                                |  tag_id, article_id    |  id
# has_and_belongs_to_many :articles |                        |  has_and_belongs_to_many :tags



# Изучить: http://www.rusrails.ru/active-record-associations#foreign_key


puts
puts '                               one-to-many. На примере Article 1 - * Comment'

# https://railsguides.net/advanced-rails-model-generators/
# https://guides.rubyonrails.org/association_basics.html
# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html


# Схема one-to-many: Article 1 - * Comment.
# Кадлая статья имеет много комментариев. Тоесть к каждой сущностьи статьи относится много сущностей комментов(принадлежат ей), но при этом каждый коммент принадлежит только одной статье

# Полезная особенность генераторов, возможность указывать reference columns - делать ссылки на другие сущности
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

      # Вариант references
      t.references :article, null: false, foreign_key: true # Создает столбец article_id являющийся foreign_key к id поля той статьи к которой относится коммент в таблице articles.
      # Тоже можно добавлять отдельной миграцией если в генераторе не указать article:references ??
      # можно добавить вручную если данная миграция еще не была запущена

      # Вариант belongs_to (алиас к references)
      t.belongs_to :article, null: false, foreign_key: true  # в таблице укажет так если генерировали при помощи belongs_to

      # МБ belongs_to лучше использовать для связи сущностей, а references для таблиц одной сущности при нормализации ??

      t.timestamps
    end
  end
end
# /models/comment.rb:
class Comment < ApplicationRecord
  belongs_to :article # модель создалась с ассоциацией article. Тоесть комментарии принадлежат статье. можно добавлять вручную если в генераторе не указать article:references

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
  has_many :comments # добавим ассоциацию comments, тоесть статья связывается с комментами(множественное число).

  # Article.find(id).comments - теперь можно обращаться от любой статьи к коллекции(массив) принадлежащих ей комментов через метод comments
end
# Таким образом мы связали 2 сущности между собой.


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


# 3. Напишем маршрут. У нас в /config/routes.rb есть строка:
resources :articles
# Изменим ее и сделаем вложенный маршрут:
resources :articles do
  resources :comments, exсept: %i[new show] # создает карту маршрутов по REST, но вложенный(одни ресурсы в других)
  # exсept: %i[new show] - (для AskIt) создадим все маршруты кроме указанных в параметре
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
    @article.comments.create(comment_params) # создаем комментарий через сущность статьи(так мы точно знаем что такая статья есть)

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
  # Порядок before_action-ов важкен, тк нам сначала нужно найти вопрос и уже потом из его коллекции найти ответ

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

# Настроим владеющую модель чтобы можно было удалять вопрос со всеми зависимыми ответами(сперва удаляет ответы а потом вопрос)
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy # dependent: :destroy  - параметр который и позволит нам удалять вопросы у которых созданы принадлежащие им ответы
end
















#
