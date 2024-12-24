puts '                                            Типы связей(AR)'

# http://www.rusrails.ru/active-record-associations
# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html

# Существует множество типов связей, среди них 3 основные это: one-to-many, one-to-one, many-to-many


# 1. one-to-many (1 - *)
# Article            |  Comment
# has_many :comments |  belongs_to :article
# id                 |  id, article_id


# 2. one-to-one (1 - 1) - помогает нормализовать БД. Делим данные из формы на 2 связанные таблицы для удобства (не нужно в orders держать все поля адреса, а только айди для отдельно сделанной для этого таблицы). Минус нормализованного подхода в усложнении SQL запроса, иногда может повлиять на скорость.
# Order              |  Address
# has_one :address   |  belongs_to :order
# id                 |  id, order_id


# 3. many-to-many (* - *) - это отношение, при котором каждая запись в одной таблице может быть связана с несколькими записями в другой таблице, и наоборот. Есть, например статьи и теги, у каждого тега есть много статей и у каждой статьи есть много тегов. Для связи между ними создаётся ещё одна таблица tags_articles состоит только из 2х столбцов tag_id, article_id. В Рэилс доп таблица создается автоматически
# Tag                               |                        |  Article
# таблица tags                      |  таблица tags_articles |  таблица articles
# id                                |  tag_id, article_id    |  id
# has_and_belongs_to_many :articles |                        |  has_and_belongs_to_many :tags



















#
