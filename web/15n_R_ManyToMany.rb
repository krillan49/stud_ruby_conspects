puts '                               Многие-ко-многим/Many-to-many/(* - *)'

# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
# https://rusrails.ru/active-record-associations

# Например есть врачи и пациенты, каждый врач может принимать многихпациентов и каждый пациент может записаться к многим врачам

# Есть два способа построить отношения «многие ко многим» c отдельной моделью для связывающей таблицы и без нее:

# 1. Используется has_many ассоциация с :through опцией (есть много через) и отдельной моделью для таблицы соединения, поэтому существует два этапа ассоциаций. В связываюзей таблице есть первичный ключ и могут быть другие поля для дополнительных данных
# таблица tags                      |  таблица tags_articles           |  таблица articles
# id                                |  id, tag_id, article_id, some    |  id
class TagArticle < ActiveRecord::Base
  belongs_to :tag         # foreign key - tag_id
  belongs_to :article     # foreign key - article_id
end
class Tag < ActiveRecord::Base
  has_many :tags_articles
  has_many :articles, through: :tags_articles # есть много статей через теги_статьи
end
class Article < ActiveRecord::Base
  has_many :tags_articles
  has_many :tags, through: :tags_articles
end

# 2. Обе модели используют has_and_belongs_to_many. Для этого автоматически создается соединительная таблица, у которой нет собственной модели или первичного ключа. tags_articles состоит только из 2х столбцов tag_id, article_id.
# таблица tags                      |  таблица tags_articles |  таблица articles
# id                                |  tag_id, article_id    |  id
class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles
end
class Article < ActiveRecord::Base
  has_and_belongs_to_many :tags
end

















#
