puts '                                       Полиморфные ассоциации'

# При написании приложения могут быть сущности, которые содержат одинаковое поведение, одинаковые свойства. Например могут быть публикации: постов, картинок, ссылкок итд. И все эти сущности можно комментировать и пришлось бы создавать для каждой отдельную сущность коммента:
# Post   -  PostComment
# Image  -  ImageComment

# Но сущности комментариев для разных коментируемых сущностей по сути будут одинаковыми.
# Post   -  Comment
# Image  -  Comment
# Поэтому стоит использовать DRY-принцип, чтобы для всех сущностей была бы одна сущность комментариев.

# Тогда мы сможем обращаться к комментам универсально от любой сущности к одному методу коллекции:
Post.find(1).comments
Image.find(1).comments
Comment.find(1).commentable
# Это удобно тк при изменении комментария(например добалении новых полей), нужно менять только одну модель и таблицу


# Сгенерируем модели и миграции
# > rails g model Comment content:text
# > rails g model Post content:text
# > rails g model Image url:text


# Пропишем связи в моделях:
# /app/models/comment.rb:
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  # При связывании с полиморфной ассоциацией надо в belongs_to добавить аргумент(любой) с окончанием able:
  # commentable - получается комментируемый, тоесть комментарий принадлежит комментируемому(посту, изображению итд), как бы виртуальной модели
  # polymorphic: true - говорит о том что ассоциация полиморфная и соответсвенно commentable это не какаято отдельная сущность, а хэндл/рукоятка(посредник), которая существует у других сущностей и отвечает за группу всех этих сущностей
  # Comment.find(1).commentable  - сосдастся хэлпер связи с комментируемыми сущностями
end
# /app/models/post.rb:
class Post < ApplicationRecord
  has_many :comments, as: :commentable
  # as: :commentable  -  подключаем хэндл commentable к ассоциации с comments (те теперь для коммента, пост это commentable)
end
# /app/models/image.rb:
class Image < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  # dependent: :destroy - при удалении изображения удалит и все принадлежащие ему комменты
end

# db/migrate/20190205095251_create_comments.rb
class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content
      # добавим строку:
      t.references :commentable, polymorphic: true # создает 2 столбца "commentable_type" и "commentable_id"
      # "commentable_type" - содержит имя модели к сущности, к которой относится коммент, например "Post"
      # "commentable_id" - содержит id сущности(например Post) к которой принадлежит коммент
      t.timestamps
    end
  end
end
# > bundle exec rake db:migrate


# Проверим в rails console:
post = Post.create(content: 'Foo bar') # создадим пост(c id 1)
post.comments #=> [] # все комменты данного поста
post.comments.create(content: 'Baz Buuu Foo') # создадим коммент  #=> INSERT INTO "comments" ("content", "commentable_type", "commentable_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["content", "Baz Buuu Foo"], ["commentable_type", "Post"], ["commentable_id", 1], ["created_at", "2023-08-15 07:53:00.708040"], ["updated_at", "2023-08-15 07:53:00.708040"]]
# "commentable_type", "Post" - коммент относится к сущности модели Post
# "commentable_id", 1 - коммент относится к сущности(Post) id которой 1
post.comments.create(content: 'Comment 2')
image = Image.create(url: '1.jpg') # создадим картинку(c id 1)
image.comments #=> [] # все комменты данной картинки
image.comments.create(content: 'Wow!') #=> ... [["content", "Wow!"], ["commentable_type", "Image"], ["commentable_id", 1], ...]
image.comments.create(content: 'This is comment for image!')
image2 = Image.create(url: '2.jpg')  # создадим картинку(c id 2)
image2.comments.create(content: 'Bar') #=> ... [["content", "Bar"], ["commentable_type", "Image"], ["commentable_id", 2], ... ]

# Посмотрим базу данных /db/development.sqlite3:
# > sqlite3 development.sqlite3
# ======================================= SELECT * FROM comments; =======================================
# id  content                     commentable_type  commentable_id  created_at                  updated_at
# --  --------------------------  ----------------  --------------  --------------------------  --------------------------
# 1   Baz Buuu Foo                Post              1               2023-08-15 07:53:00.708040  2023-08-15 07:53:00.708040
# 2   Comment 2                   Post              1               2023-08-15 07:55:01.729813  2023-08-15 07:55:01.729813
# 3   Wow!                        Image             1               2023-08-15 08:08:48.464931  2023-08-15 08:08:48.464931
# 4   This is comment for image!  Image             1               2023-08-15 08:10:52.998994  2023-08-15 08:10:52.998994
# 5   Bar                         Image             2               2023-08-15 08:11:36.064177  2023-08-15 08:11:36.064177
# ======================================= SELECT * FROM posts; ==========================================
# id  content  created_at                  updated_at
# --  -------  --------------------------  --------------------------
# 1   Foo bar  2023-08-15 07:50:00.584876  2023-08-15 07:50:00.584876
# ======================================= SELECT * FROM images; =========================================
# id  url    created_at                  updated_at
# --  -----  --------------------------  --------------------------
# 1   1.jpg  2023-08-15 08:06:17.392201  2023-08-15 08:06:17.392201
# 2   2.jpg  2023-08-15 08:11:19.472970  2023-08-15 08:11:19.472970



puts '                         Генерация полиморфных ассоциаций. concern для модели и маршрутов'

# 1. Сгенерируем модель комментариев с полиморфическими ассоциациями, указав все необходимые параметры в генераторе
# > rails g model Comment body:string commentable:references{polymorphic} user:belongs_to
# Создалась модель:
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
end
# Создалась миграция:
class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :body
      t.references :commentable, polymorphic: true, null: false # тоесть миграции не в курсе какие именно сущности commentable, тоесть можно будет потом добавить новые
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
# > rails db:migrate
# В схеме появилось:
create_table "comments", force: :cascade do |t|
  t.string "body"
  t.string "commentable_type", null: false # поле для имени модели(например 'Answer' или 'Question') для привязки
  t.integer "commentable_id", null: false  # поле с айди сущности для привязки
  t.integer "user_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  t.index ["user_id"], name: "index_comments_on_user_id"
end
add_foreign_key "comments", "users"


# 2. models/concerns/commentable.rb  - создадим консерн, общий для всех комментируемых моделей. В нем пропишем ассоциации для комментируемых моделей, вместо того чтобы писать их в каждой модели, просто подключим в них консерн
class Question < ApplicationRecord
  include Commentable
  # ...
end
class Answer < ApplicationRecord
  include Commentable
  # ...
end


# 3а. Пропишем маршруты для комментариев
resources :questions do
  resources :comments, only: %i[create destroy] # добавим вложенные комменты
  resources :answers, except: %i[new show] # тут не будем делать еще одно вложение для комментов, тк маршрут получится слишком длинный и сложный ...
end
# ... вместо этого придется сделать дополнительные маршруты ответов и вложить в них комменты
resources :answers, except: %i[new show] do
  resources :comments, only: %i[create destroy]
end

# 3б. Пропишем маршруты для комментариев с использованием консерна, чтобы не дублировать маршруты
Rails.application.routes.draw do
  concern :commentable do # создаем консерн маршрутов называем его :commentable (? название любое ?)
    resources :comments, only: %i[create destroy] # помещаем внутрь дублирующиеся маршруты
  end

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    resources :questions, concerns: :commentable do
      # concerns: :commentable - маршруты из консерна :commentable будут вложены в данный
      resources :answers, except: %i[new show]
    end

    resources :answers, except: %i[new show], concerns: :commentable # тут тоже вкладываем консерн
  end
end


# 4. Добавим в application.js модуль бутстрапа collapse для выпадающих форм


# 5. Представления:
# a. questions/show.html.erb - добавим рендер паршала comments/commentable с формой и списком комментариев
# б. answers/_answer.html.erb - добавим рендер паршала comments/commentable с формой комментариев (заодно добавим новую версию паршала)
# в. comments/_commentable.html.erb - создадим директорию и паршал с формой комментариев и списком всех комментариев для commentable сущности. Форма и список комментов будут выпадающими при помощи бутстрапа, для чего добавим уникальные значения айди(для каждого элемента коллекции ответов, тк для каждого будет своя форма и список комментов и для вопроса), по которому кнопка будет открывать нужный выпадающий элемент, соотв будем передавать это айди и со страниц questions/show.html.erb и answers/_answer.html.erb, где нужная форма и список комментариев и рендерятся
# г. _comment.html.erb - создадим паршал для конкретного комментария. Так же создадим полиморфическую ссылку для удаления коммента


# 6. Создадим декоратор для комментариев comment_decorator.rb
class CommentDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user # задекорируем юзера, вызванного от комментария (для методов gravatar и name_or_email)
end


# 7. Создадим контроллер для комментариев comments_controller.rb
class CommentsController < ApplicationController
  include QuestionsAnswers # подключим консерн questions_answer.rb чтобы использовать его метод load_question_answers
  before_action :set_commentable! # определение сущьности для @commentable
  before_action :set_question # сущность вопроса для метода консерна в create, если валидация не прошла и для редиректа

  def create
    @comment = @commentable.comments.build comment_params # создадим новый комментарий

    if @comment.save
      flash[:success] = t '.success'
      redirect_to question_path(@question) # GET 'questions/:id' questions/show.html.erb
      # так же можно редиректить: (?? переменная @commentable для этих вариантов определяется както проще чем метод ниже ??)
      redirect_to @commentable # GET 'some/:id' но для этого нам нужны экшены show в контроллерах и виды для всех комментируемых сущьностей, больше подходит для множества комментируемых сущностей
    else
      @comment = @comment.decorate
      load_question_answers do_render: true # используем метод из консерна questions_answer.rb если не прошла валидация, для того чтоб передать все необходимые задекорированные коллекции с пагинацией и сущности и отрендерить questions/show.html.erb
    end
  end

  # В _comment.html.erb - добавим спец ссылку для удаления полиморфического коммента
  def destroy # '/questions/:qoestion_id/comments/:id' либо '/answers/:answer_id/comments/:id'
    comment = @commentable.comments.find params[:id] # ищем коммент для конкретного комментируемого
    comment.destroy
    flash[:success] = t '.success'
    redirect_to question_path(@question)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user) # сразу добавим юзера
  end

  def set_commentable! # с воскл знаком, тк метод опасный, потому что может вызвать ошибку
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] } # определяем константу класса комментируемой сущности, для этго константы вопроса и ответа преобразуем либо в 'question_id' либо в 'answer_id' и проверяем через params передается ли это значение в URL
    raise ActiveRecord::RecordNotFound if klass.blank? # вызываем ошибку если никакой класс не найден в параметрах
    @commentable = klass.find(params["#{klass.name.underscore}_id"]) # ищем нашу сущность в БД по ее айди, взятое из 'question_id' или 'answer_id' в зависимости от того какая константа в переменной klass
  end

  def set_question
    @question = @commentable.is_a?(Question) ? @commentable : @commentable.question
    # Если комментируемая сущность это вопрос, то оставляем @commentable, а если ответ то вызываем от него связанный вопрос
  end
end



puts '                       Решение проблемы с отображением ошибки при не прохождении валидаций'

# Тк при ошибке валидации переменная @comment с заполненными полями из comments_controller#create, передаваемая через questions/show.html.erb в паршал _commentable.html.erb и соотв в паршал ошибок из него, передается в блок каждого ответа и вопроса, то сообщения об ошибке появляется в блоке каждого ответа и вопроса на странице show.html.erb, а не только в целевом
form_with model: [commentable, (@comment || commentable.comments.build)] # тоесть @comment тут это просто инстанс коментария и он не содержит информацию о том к какому классу и индексу комментируемой сущности он отностится и соотв мы не знаем где конкретно исполнять или не исполнять код отображения об ошибке
render 'shared/errors', object: @comment # тоесть этот код исполняется в блоке вопроса и каждого ответа

# Эту проблему можно было бы решить при помощи ассинхронных форм JS но тут решим без этого:
# Нужно определить для какой комментируемой сущьности был оставлен комментарий переданный в @comment и соотв отображать ошибку только в нужном блоке конкретного ответа или вопроса, а не везде, а так же дополнительно раскроем только необходимый коллапс-блок

# 1. Пропишем основную логику определения класса комментируемой сущности в методе for? декораторе comment_decorator.rb, но возможно лучше это писать прямо в модели Comment
class CommentDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user

  def for?(commentable) # commentable - парамертр с комментируемой сущностью, те вопросом или ответом (не знаем с чем именно)
    commentable = commentable.object if commentable.decorated? # тоесть если комментируемая сущьность была задекорирована то нужно вытащить эту сущность при помощи метода object, тк гем Дрэйпер добавляет к задекорированному объекту свои артибуты
    commentable == self.commentable # сравниваем и возвращаем true или false
    # self.commentable - self указывает на конкретный комментарий от которого вызвали метод for? и вызываем от него commentable которому он принадлежит
  end
end

# 2. Используем метод for? в паршале _commentable.html.erb















#
