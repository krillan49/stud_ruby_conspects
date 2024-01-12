puts '                               Многие-ко-многим/Many-to-many/(* - *)'

# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
# https://rusrails.ru/active-record-associations

# Например есть врачи и пациенты, каждый врач может принимать многих пациентов и каждый пациент может записаться ко многим врачам

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


puts
puts '                                         has_many :through'

# На примере AskIt воспользуемся данным типом ассоциации многие-ко-многим, чтобы для каждого вопроса было множество тегов и каждый тег мог принадлежать множеству вопросов

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
    # Добавляем индекс естественно отдельно от блока созлания таблицы, иначе будет ошибка
    # Добавим вркчную только этот индекс, чтобы в таблице не появилось 2х записей с одинаковой комбинацией :question_id и :tag_id, тк нет смысла для одного вопроса добалять одинаковые теги
    add_index :question_tags, [:question_id, :tag_id], unique: true
  end
end
# > rails db:migrate
# Промежуточная таблица в схеме выглядит так
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
end
class Question < ApplicationRecord # такие же связи добавим в модель вопроса
  # ...
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags
  # ...
end


# 3. Создадим сами теги (заполним таблицу) чеорез скрипт в db/seeds.rb при помощи Faker. Не забываем закомментировать старые наполнения, чтоб их не дублировать
30.times do
  title = Faker::Hipster.word
  Tag.create title: title # Создаем 30 записей в таблице тегов сгенерированные Фэйкером
end
# > rails db:seed


# 4. Добавим новые элементы в представления и создадим новые представления
# questions/_form.html.erb - добавим новое поле-селектор, чтобы добавлять теги вопросу
# questions/new.html.erb и questions/edit.html.erb - добавим опцию в рендер для передачи коллекции тегов
# questions/_question.html.erb - добавим отоборажение тегов, чтобы они были видны при рендере в index
# tags/_tag.html.erb - создадим новую директорию и паршал для тега в ней, с выбором вопросов для этого тега


# 5. Добавим в questions_controller.rb метод для передачи коллекции тегов в questions/new.html.erb и questions/edit.html.erb
class QuestionsController < ApplicationController
  # ...
  before_action :fetch_tags, only: %i[new edit]

  # ...

  private

  def question_params
    params.require(:question).permit(:title, :body, tag_ids: []) # добавим tag_ids: [], где пустой массив в конце обозначает, что будет передаваться целый массив из айдишников тегов
  end
  # ...
  def fetch_tags
    @tags = Tag.all
  end
end


# 5. Сделаем функционал поиска вопросов по тегу в tags/_tag.html.erb. Можно было бы это делать в контроллере, но лучше сделаем основной функционал в модели:
# a. В questions_controller.rb изменим экшен index
def index
  @tags = Tag.where(id: params[:tag_ids]) if params[:tag_ids] # либо теги с айди с совпадающим с переданным либо nil
  # params[:tag_ids] - айди тега переданный из _tag.html.erb при помощи questions_path(tag_ids: tag)
  # @pagy, @questions = pagy Question.includes(:user).order(created_at: :desc) # заменим эту строку на...
  @pagy, @questions = pagy Question.all_by_tags(@tags) # ... эту. Тоесть теперь выбираем только те вопросы, которые имеют тег, айди которого мы получили из params[:tag_ids], тоесть из конца URL(например /questions?tag_ids=1), если же айди нет то выбираем все вопросы
  # all_by_tags(@tags) - метод класса модели в модели, который и делает вышеописанное, передаем в него тег из запроса
  @questions = @questions.decorate
end
# б. В модели question.rb добавим метод класса при помощи синтаксиса scope
class Question < ApplicationRecord
  # ...
  scope :all_by_tags, ->(tags) do
  # scope :all_by_tags - это в РоР по сути тоже самое что и def self.all_by_tags, тоесть метод класса модели, но так визуально мы сразу понимаем, что это не просто какойто метод, а тот при помощи которого мы можем выбирать определенные записи из БД по неким критериям
  # ->(tags) - далее параметр-лямбда, который принимает свой параметр tags, тоесть тег из запроса из index
  # do ... end - принимаемый блок относится к лямбде ->(tags)
    questions = includes(:user) # тоесть тут было бы Question.includes(:user) тк вернем эту переменную к вызову от модели
    if tags # если тег передан
      questions = questions.joins(:tags).where(tags: tags).preload(:tags) # то джойним запрос с таблицой тегов и выбираем вопросы у которых есть тег как в переданном параметре
    else # если вопрос не передан то выбираем все вопросы с тегами
      questions = questions.includes(:question_tags, :tags)
    end
    questions.order(created_at: :desc) # возвращаем к константе модели с сортировкой
  end
end















#
