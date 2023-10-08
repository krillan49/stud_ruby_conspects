puts '                                     Полиморфные ассоциации(полиморфизм)'

# Polymorphism

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


# Свяжем эти сущности.

# /app/models/comment.rb:
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  # При связывании с полиморфной ассоциацией надо в belongs_to добавить аргумент(любой) с окончанием able:
  # commentable - получается: комментируемый, тоесть принадлежит комментируемому(посту, изображению итд)
  # polymorphic: true - говорит о том что ассоциация полиморфная, те commentable это не какаято сущность, а хэндл(рукоятка, посредник ?) отвечающая за группу сущностей
  # Хендл, рукоятка, которая существует у других сущностей.
end

# /app/models/post.rb:
class Post < ApplicationRecord
  has_many :comments, as: :commentable
  # as: :commentable  -  подключаем хэндл commentable к ассоциации comments
end

# /app/models/image.rb:
class Image < ApplicationRecord
  has_many :comments, as: :commentable
end

# Далее, откроем миграцию db/migrate/20190205095251_create_comments.rb и добавим строку:
class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :commentable, polymorphic: true # добавляем строку, создает 2 столбца "commentable_type" и "commentable_id"
      # "commentable_type" - содержит имя модели к сущности которой относится коммент, например "Post"
      # "commentable_id" - содержит id сущности(например Post) к которой принадлежит коммент
      t.timestamps
    end
  end
end

# Запускаем миграции:
# > bundle exec rake db:migrate


# Далее, откроем rails console:
post = Post.create(content: 'Foo bar') # создадим пост(c id 1)
post.comments #=> [] # все комменты данного поста
post.comments.create(content: 'Baz Buuu Foo') # создадим комменты  #=> INSERT INTO "comments" ("content", "commentable_type", "commentable_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["content", "Baz Buuu Foo"], ["commentable_type", "Post"], ["commentable_id", 1], ["created_at", "2023-08-15 07:53:00.708040"], ["updated_at", "2023-08-15 07:53:00.708040"]]
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
# Создание полиморфного коммента(мой способ наугад):
# =====================================
# https://github.com/krillan49/blog2_rs
# =====================================

# http://rusrails.ru/active-record-associations     -    статья про типы связей


















#
