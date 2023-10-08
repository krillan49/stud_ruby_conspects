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

# Схема one-to-many: Article 1 - * Comment.
# Кадлая статья имеет много комментариев. Тоесть к каждой сущностьи статьи относится много сущностей комментов(принадлежат ей)

# https://railsguides.net/advanced-rails-model-generators/
# https://guides.rubyonrails.org/association_basics.html
# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html

# Полезная особенность генераторов, возможность указывать reference columns - делать ссылки на другие сущности

# 1. Создадим модель Comment со ссылкой на article:
# > rails g model Comment author:string body:text article:references
# article:references - дополнительный параметр, отвечающий за отношение между сущностями
# Создалось:
# /db/migrate/12312314_create_comments.rb:
class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :author
      t.text :body
      t.references :article, null: false, foreign_key: true # создало в миграции эту строку - связь по айди для комментов с какойто статьей, те поле для id статьи к которой относится коммент. Создает столбец article_id являющийся foreign_key к id в таблице articles.
      # Тоже можно добавлять отдельной миграцией если в генераторе не указать article:references ??
      # можно добавить вручную если данная миграция не была запущена

      t.timestamps
    end
  end
end
# /models/comment.rb:
class Comment < ApplicationRecord
  belongs_to :article # модель создалась с ассоциацией article. Тоесть комментарии принадлежат статье. можно добавлять вручную если в генераторе не указать article:references
  # + Теперь можно обращаться от любого коммента к статье которой он пренадлежит через Comment.find(1).article
end
# rake db:migrate


# 2. Допишем вручную в модель уже Article  /models/article.rb ...
class Article < ApplicationRecord
  has_many :comments # добавим ассоциацию comments, тоесть статья связывается с комментами.
  # Теперь можно обращаться от любой статьи к коллекции принадлежащих ей комментов через Article.find(id).comments
end
# Таким образом мы связали 2 сущности между собой.


# 3. Напишем маршрут. У нас в /config/routes.rb есть строка:
resources :articles
# Изменим ее и сделаем вложенный маршрут:
resources :articles do
  resources :comments # создает список маршрутов по REST, но вложенный(одни ресурсы в других)
end
# article_comments     GET      /articles/:article_id/comments(.:format)          comments#index
# new_article_comment  GET      /articles/:article_id/comments/new(.:format)      comments#new
#                      POST     /articles/:article_id/comments(.:format)          comments#create
# article_comment      GET      /articles/:article_id/comments/:id(.:format)      comments#show
# edit_article_comment GET      /articles/:article_id/comments/:id/edit(.:format) comments#edit
#                      PATCH    /articles/:article_id/comments/:id(.:format)      comments#update
#                      PUT      /articles/:article_id/comments/:id(.:format)      comments#update
#                      DELETE   /articles/:article_id/comments/:id(.:format)      comments#destroy
# Тут article_id то что в маршрутах articles являлось id, тут id это айди коммента


# Посмотрим в rails console:
Article.comments           #=> будет ошибка тк у модели нет такого свойства comments
@article = Article.find(1) #=> но если создать объект с одной статьей ...
@article.comments          #=> ... то мы получаем доступ к списку всех комментов для этой статьи
@article.comments.create(:author => 'Foo', :body => 'Bar') #=> создание коммента для данной статьи, через сущность статьи
Comment.last
Comment.all                # все комменты ко всем статьям


# 4. Добавим форму для комментариев на '/articles/id'  show.html.erb (Вывод комментариев там же)


# 5. Добавляем контроллер для комментариев
# > rails g controller Comments
# Для комментариев нам(тут) нужен только один метод - create, тк не будем с ним больше ничего делать, кроме добавления(POST), а форма для него и вывод будут на странице статьи к которой он относится(article#show).
class CommentsController < ApplicationController
  # Создадим метод create в /app/controllers/comments_controller.rb:
  def create # post '/articles/:article_id/comments'
    @article = Article.find(params[:article_id]) # :article_id тк это контроллер Comments и его карта маршрутов
    @article.comments.create(comment_params) # создаем комментарий через сущность статьи

    redirect_to article_path(@article) # get '/articles/id'  articles#show
  end

  private

  def comment_params
    params.require(:comment).permit(:author, :body)
  end
end
















#
