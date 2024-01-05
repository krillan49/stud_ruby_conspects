puts '                                     Полиморфные ассоциации(Polymorphism)'

# Создание полиморфного коммента(мой способ наугад): https://github.com/krillan49/blog2_rs

# Создадим приложение poly_demo(исправим ошибки таймзон, бандл апдэйт итд)
# > rails new poly_demo

# При написании приложения у нас могут быть сущности, которые содержат одинаковое поведение, одинаковые свойства. Например на главной у нас могут быть публикации: постов, картинок, ссылкок. И все эти сущности можно комментировать и пришлось бы создавать для каждой отдельную сущность коммента:
# Post   -  PostComment
# Image  -  ImageComment

# Но сущности комментариев для разных сущностей по сути будут одинаковыми, поэтому нам захочется использовать DRY-принцип, чтобы для всех сущностей была бы одна сущность комментприев
# Post   -  Comment
# Image  -  Comment

# Соотв мы сможем обращаться к комментам универсально от любой сущности к одному методу коллекции:
Post.comments
Image.comments

# Одна модель может принадлежать разным сущностям, но при этом оставаться сама собой (полиморфизм). Это удобно тк при изменении сущности комментария(например добалении новых полей), нужно менять только одну сущность


# Сгенерируем модели и миграции
# > rails g model Comment content:text
# > rails g model Post content:text
# > rails g model Image url:text


# Пропишем связи в моделях:
# /app/models/comment.rb:
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  # При связывании с полиморфной ассоциацией надо в belongs_to добавить аргумент(любой) с окончанием able:
  # commentable - получается комментируемый, тоесть принадлежит комментируемому(посту, изображению итд), как бы виртуальной модели
  # polymorphic: true - говорит о том что ассоциация полиморфная и соответсвенно commentable это не какаято сущность, а хэндл/рукоятка(посредник), которая существует у других сущностей, отвечающая за группу всех этих сущностей
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

# Далее, откроем миграцию db/migrate/20190205095251_create_comments.rb и добавим строку:
class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :commentable, polymorphic: true # добавляем, создает 2 столбца "commentable_type" и "commentable_id"
      # "commentable_type" - содержит имя модели к сущности которой относится коммент, например "Post"
      # "commentable_id" - содержит id сущности(например Post) к которой принадлежит коммент
      t.timestamps
    end
  end
end
# > bundle exec rake db:migrate


# Далее, откроем rails console:
post = Post.create(content: 'Foo bar') # создадим пост(c id 1)
post.comments #=> [] # все комменты данного поста
post.comments.create(content: 'Baz Buuu Foo') # создадим коммент  #=> INSERT INTO "comments" ("content", "commentable_type", "commentable_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["content", "Baz Buuu Foo"], ["commentable_type", "Post"], ["commentable_id", 1], ["created_at", "2023-08-15 07:53:00.708040"], ["updated_at", "2023-08-15 07:53:00.708040"]]
# "commentable_type", "Post" - коммент относится к сущности модели Post
# "commentable_id", 1 - коммент относится к сущности(Post) id которой 1
post.comments.create(content: 'Comment 2')
image = Image.create(url: '1.jpg') # создадим картинку(c id 1)
image.comments #=> [] # все комменты данной картинки
image.comments.create(content: 'Wow! Super!') #=> ... [["content", "Wow! Super!"], ["commentable_type", "Image"], ["commentable_id", 1], ...]
image.comments.create(content: 'This is comment for image!')
image2 = Image.create(url: '2.jpg')  # создадим картинку(c id 2)
image2.comments.create(content: 'Bar') #=> ... [["content", "Bar"], ["commentable_type", "Image"], ["commentable_id", 2], ... ]

# Посмотрим базу данных /db/development.sqlite3:
# > sqlite3 development.sqlite3
# select * from comments; =======================================
# id  content                     commentable_type  commentable_id  created_at                  updated_at
# --  --------------------------  ----------------  --------------  --------------------------  --------------------------
# 1   Baz Buuu Foo                Post              1               2023-08-15 07:53:00.708040  2023-08-15 07:53:00.708040
# 2   Comment 2                   Post              1               2023-08-15 07:55:01.729813  2023-08-15 07:55:01.729813
# 3   Wow! Super!                 Image             1               2023-08-15 08:08:48.464931  2023-08-15 08:08:48.464931
# 4   This is comment for image!  Image             1               2023-08-15 08:10:52.998994  2023-08-15 08:10:52.998994
# 5   Bar                         Image             2               2023-08-15 08:11:36.064177  2023-08-15 08:11:36.064177
# select * from posts; ==========================================
# id  content  created_at                  updated_at
# --  -------  --------------------------  --------------------------
# 1   Foo bar  2023-08-15 07:50:00.584876  2023-08-15 07:50:00.584876
# select * from images; =========================================
# id  url    created_at                  updated_at
# --  -----  --------------------------  --------------------------
# 1   1.jpg  2023-08-15 08:06:17.392201  2023-08-15 08:06:17.392201
# 2   2.jpg  2023-08-15 08:11:19.472970  2023-08-15 08:11:19.472970


puts
puts '                              Генерация полиморфнфх ассоциаций. concern для модели'

# (Для AskIt)

# 1. Сгенерируем модель комментариев с прлиморфическими ассоциациями, указав все необходимые параметры в генераторе
# > rails g model Comment body:string commentable:references{polymorphic} user:belongs_to
# Создалась модель:
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates :body, presence: true, length: { minimum: 2 }  # заодно добавим валидацию
end
# Создалась миграция:
class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :body
      t.references :commentable, polymorphic: true, null: false # ?? тоесть миграции и БД не в курсе какие именно сущности commentable, тоесть можно будет потом добавить новые
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
# > rails db:migrate
# В схеме появилось:
create_table "comments", force: :cascade do |t|
  t.string "body"
  t.string "commentable_type", null: false # поле для имени модели('Answer', 'Question') для привязки
  t.integer "commentable_id", null: false # поле с айди сущности для привязки
  t.integer "user_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  t.index ["user_id"], name: "index_comments_on_user_id"
end
add_foreign_key "comments", "users"


# 2. Создадим новй консерн, только уже в директории моделей, а не контроллеров - models/concerns/commentable.rb. В нем пропишем ассоциации для комментируемых моделей, вместо того чтобы писать их в каждой модели, просто подключим в них консерн
class Question < ApplicationRecord
  include Commentable
  # ...
end
class Answer < ApplicationRecord
  include Commentable
  # ...
end


# 3. Пропишем маршруты для комментариев
resources :questions do
  resources :comments, only: %i[create destroy] # добавим вложенные комменты
  resources :answers, except: %i[new show] # тут не будем делать еще одно вложение для комментов, тк маршрут получится слишком длинный и сложный ...
end
# ... вместо этого придется сделать дополнительные маршруты ответов и вложить в них комменты
resources :answers, except: %i[new show] do
  resources :comments, only: %i[create destroy]
end


# 4. Добавим в application.js модуль бутстрапа collapse для выпадающих форм
# (Для асккит урока 15, работает только через запуск st.cmd)


# 5. Представления:
# a. questions/show.html.erb - добавим рендер паршала comments/commentable с формой и списком комментариев
# б. answers/_answer.html.erb - добавим рендер паршала comments/commentable с формой комментариев (заодно добавим новую версию паршала)
# в. comments/_commentable.html.erb - создадим директорию и паршал с формой комментариев(выпадающей) и списком всех комментариев для конкретной commentable сущности.
# г. _comment.html.erb - создадим паршал для конкретного комментария
# Далее сделаем выпадающими comments/_commentable.html.erb при помощи бутстрапа, для чего добавим уникальные значения айди(для каждого элемента коллекции ответов, тк для каждого будет своя форма и список комментов и для вопроса), по которому кнопка будет открывать нужный выпадающий элемент, соотв будем передавать это айди и со страниц questions/show.html.erb и answers/_answer.html.erb, где нужная форма и список комментариев и рендерятся


# 6. Создадим новый декоратор comment_decorator.rb
class CommentDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user # задекорируем юзера, вызванного от комментария (для gravatar и name_or_email)
end
















#
