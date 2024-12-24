puts '                                         Many-to-many (* - *)'

# Many-to-many (* - *) - это отношение, при котором каждая запись в одной таблице может быть связана с несколькими записями в другой таблице, и наоборот. Например есть врачи и пациенты, каждый врач может принимать многих пациентов и каждый пациент может записаться ко многим врачам

# Есть два способа построить отношения «многие ко многим» c отдельной моделью для связывающей таблицы и без нее:

# 1. С отдельной моделью для связывающей таблицы. Используется has_many ассоциация с :through опцией (есть много через) и отдельной моделью для связывающей таблицы, поэтому существует два этапа ассоциаций. В связывающей таблице есть так же и свой первичный ключ и могут быть дополнительные поля для дополнительных данных
# таблица tags                      |  таблица tags_articles           |  таблица articles
# id                                |  id, tag_id, article_id, some    |  id
class TagArticle < ActiveRecord::Base
  belongs_to :tag         # foreign key -> tag_id
  belongs_to :article     # foreign key -> article_id
end
class Tag < ActiveRecord::Base
  has_many :tags_articles                     # есть много тегов_статей напрямую
  has_many :articles, through: :tags_articles # есть много статей через теги_статьи
end
class Article < ActiveRecord::Base
  has_many :tags_articles                 # есть много тегов_статей напрямую
  has_many :tags, through: :tags_articles # есть много тегов через теги_статьи
end

# 2. Без отдельной модели для связывающей таблицы. Обе модели используют has_and_belongs_to_many. Для этого автоматически создается связывающая таблица, у которой нет собственной модели или первичного ключа. Связывающая таблица состоит только из 2х столбцов - айди связанных сущьностей для таблиц которые нужно свящать.
# таблица tags                      |  таблица tags_articles |  таблица articles
# id                                |  tag_id, article_id    |  id
class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles
end
class Article < ActiveRecord::Base
  has_and_belongs_to_many :tags
end



puts '                                           has_many :through'

# На примере AskIt, воспользуемся has_many :through типом ассоциации многие-ко-многим, чтобы для каждого вопроса было множество тегов и каждый тег мог принадлежать множеству вопросов

# 1. Сгенерируем модели и миграции для тегов и промежуточной таблицы тегов-вопросов
# > rails g model Tag title:string
# > rails g model QuestionTag question:belongs_to tag:belongs_to   # тоесть генерируем с отношениями сразу для 2х таблиц
class CreateQuestionTags < ActiveRecord::Migration[7.0]
  def change
    create_table :question_tags do |t|
      t.belongs_to :question, null: false, foreign_key: true
      t.belongs_to :tag, null: false, foreign_key: true

      t.timestamps
    end
    # Добавим вручную только этот индекс(отдельно от блока создания таблицы, иначе будет ошибка), чтобы в таблице не появилось 2х записей с одинаковой комбинацией :question_id и :tag_id, тк нет смысла для одного вопроса добалять одинаковые теги
    add_index :question_tags, [:question_id, :tag_id], unique: true
  end
end
# Так же добавим индекс(можно было в миграции талицы тегов) в таблицу тегов для проверки уникальности названия тега
# > rails g migration add_unique_constraint_to_users_on_title
class AddUniqueConstraintToUsersOnTitle < ActiveRecord::Migration[7.0]
  def change
    add_index :tags, :title, unique: true
  end
end
# > rails db:migrate
# Промежуточная таблица в схеме выглядит так:
create_table "question_tags", force: :cascade do |t|
  t.integer "question_id", null: false
  t.integer "tag_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["question_id", "tag_id"], name: "index_question_tags_on_question_id_and_tag_id", unique: true
  t.index ["question_id"], name: "index_question_tags_on_question_id"
  t.index ["tag_id"], name: "index_question_tags_on_tag_id"
end


# 2. Добавим связи в модели
class QuestionTag < ApplicationRecord # тут все связи сгенерировались автоматически
  belongs_to :question
  belongs_to :tag
end
class Tag < ApplicationRecord # создалась пустой, добавим отношения
  has_many :question_tags, dependent: :destroy # имеет много question_tags напрямую
  has_many :questions, through: :question_tags # имеет много вопросов, через промежуточную question_tags

  validates :title, presence: true, uniqueness: true # заодно вылидацию, чтобы не было тегов с одинаковыми именами
end
class Question < ApplicationRecord # такие же связи добавим в модель вопроса
  # ...
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags
end


# 3. Создадим сами теги (заполним таблицу) через скрипт в db/seeds.rb при помощи Faker (Не забываем закомментировать старые наполнения, чтоб их не дублировать)
30.times do
  title = Faker::Hipster.word
  Tag.create title: title # Создаем 30 записей в таблице тегов, сгенерированные Фэйкером
end
# > rails db:seed


# 4. Добавим новые элементы в представления и создадим новые представления
# questions/new.html.erb и questions/edit.html.erb - добавим опцию с переменной в рендер формы для передачи коллекции тегов
# questions/_form.html.erb - добавим новое поле-селектор, чтобы добавлять теги вопросу
# questions/_question.html.erb - добавим отоборажение тегов, чтобы они были выведены для каждого вопроса при рендере в index
# tags/_tag.html.erb - создадим новую директорию и паршал для тега в ней(рендерятся в _question.html.erb), с выбором вопросов для этого тега


# 5. Добавим в questions_controller.rb метод для передачи коллекции тегов в questions/new.html.erb и questions/edit.html.erb
class QuestionsController < ApplicationController
  # ...
  before_action :fetch_tags, only: %i[new edit]

  # ...

  private

  def question_params
    params.require(:question).permit(:title, :body, tag_ids: []) # добавим tag_ids: [], где пустой массив в конце обозначает, что будет передаваться массив из айдишников тегов, а не отдельный айди
  end
  # ...
  def fetch_tags
    @tags = Tag.all
  end
end


# 6. Сделаем функционал поиска вопросов по тегу в tags/_tag.html.erb. Можно было бы это делать только в контроллере, но лучше сделаем основной функционал в модели:

# a. questions_controller.rb - изменим экшен index
class QuestionsController < ApplicationController
  # ...
  def index # GET '/questions' или GET '/questions?tag_ids=1'
    @tags = Tag.where(id: params[:tag_ids]) if params[:tag_ids] # либо тег с айди совпадающим с переданным, либо nil
    # params[:tag_ids] - айди тега (?tag_ids=1) переданный из _tag.html.erb при помощи questions_path(tag_ids: tag)
    @pagy, @questions = pagy Question.all_by_tags(@tags)
    # all_by_tags(@tags) - статический метод модели(код ниже), передаем в него тег из запроса - выбирает только те вопросы, которые имеют тот тег, id которого мы получили из params[:tag_ids], если же id не было передано то выбираем все вопросы
    @questions = @questions.decorate
  end
  # ...
end

# b. В модели question.rb добавим метод класса при помощи синтаксиса scope
class Question < ApplicationRecord
  # ...
  scope :all_by_tags, ->(tags) do
  # scope :all_by_tags - это в Рэилс +- тоже def self.all_by_tags, тоесть метод класса модели, принято, если метод выбирает записи из БД по критериям. scope всегда возвращает relation, а обычный метод класса может вернуть nil
  # ->(tags) do ... end - далее метод принимает лямбду с параметором(коллекция @tags из index), тоесть тег из запроса и блоком
    questions = includes(:user) # тут Question.includes(:user) тк это тело статического метода модели
    if tags # если тег передан, тоесть не nil
      questions = questions.joins(:tags).where(tags: tags).preload(:tags) # джойним запрос с таблицой тегов и выбираем вопросы у которых есть тег как в переданном параметре
    else # если тег не передан то выбираем все вопросы вместе с тегами
      questions = questions.includes(:question_tags, :tags)
    end
    questions.order(created_at: :desc) # возвращаем в index к константе модели с сортировкой
  end
end
















#
