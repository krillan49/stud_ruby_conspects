puts '                                            Типы связей(AR)'

# Изучить: http://www.rusrails.ru/active-record-associations#foreign_key
# http://rusrails.ru/active-record-associations     -    статья про типы связей

# Существует множество типов связей, 3 основные: one-to-many, one-to-one, many-to-many
# http://rusrails.ru/active-record-associations


# 1. one-to-many (1 - *)
# Article            |  Comment
# has_many :comments |  belongs_to :article
# id                 |  id, article_id


# 2. one-to-one (1 - 1) - помогает нормализовать БД - делим данные из формы на 2 связанные таблицы для удобства (не нужно в orders держать все поля адреса, а только айди для отдельно сделанной для этого таблицы)
# Order              |  Address
# has_one :address   |  belongs_to :order
# id                 |  id, order_id
# Нормализация - разбитие на подтаблицы
# Денормализация - обобщение в одну таблицу
# Минус нормализованного подхода в усложнении SQL запроса, иногда может повлиять на скорость.


# 3. many-to-many (* - *) - Есть, например статьи и теги(категории), у каждого тега есть много статей и у каждой статьи есть много тегов. Для связи между ними создаётся ещё одна таблица tags_articles состоит только из 2х столбцов tag_id, article_id, тк недостаточно 2х таблиц для реализации. В Рэилс доп таблица создается автоматически
# Tag                               |                        |  Article
# таблица tags                      |  таблица tags_articles |  таблица articles
# id                                |  tag_id, article_id    |  id
# has_and_belongs_to_many :articles |                        |  has_and_belongs_to_many :tags



















#
