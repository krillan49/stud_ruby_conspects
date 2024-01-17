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
    # Добавляем индекс естественно отдельно от блока создания таблицы, иначе будет ошибка
    # Добавим вручную только этот дополнительный индекс, чтобы в таблице не появилось 2х записей с одинаковой комбинацией :question_id и :tag_id, тк нет смысла для одного вопроса добалять одинаковые теги
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

  validates :title, presence: true, uniqueness: true # заодно вылидацию, чтобы не было тегов с одинаковыми именами
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
# questions/new.html.erb и questions/edit.html.erb - добавим опцию с переменной в рендер формы для передачи коллекции тегов
# questions/_question.html.erb - добавим отоборажение тегов, чтобы они были видны при рендере в index
# tags/_tag.html.erb - создадим новую директорию и паршал для тега в ней, с выбором вопросов для этого тега


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
# a. В questions_controller.rb изменим экшен index
def index # GET '/questions' или GET '/questions?tag_ids=1'
  @tags = Tag.where(id: params[:tag_ids]) if params[:tag_ids] # либо тег с айди с совпадающим с переданным либо nil
  # params[:tag_ids] - айди тега (?tag_ids=1) переданный из _tag.html.erb при помощи questions_path(tag_ids: tag)
  @pagy, @questions = pagy Question.all_by_tags(@tags)
  # all_by_tags(@tags) - статический метод модели(передаем в него тег из запроса) - выбирает только те вопросы, которые имеют тот тег, id которого мы получили из params[:tag_ids], если же id не было передано то выбираем все вопросы
  @questions = @questions.decorate
end
# b. В модели question.rb добавим метод класса при помощи синтаксиса scope
class Question < ApplicationRecord
  # ...
  scope :all_by_tags, ->(tags) do
  # scope :all_by_tags - это в Рэилс по сути тоже самое что и def self.all_by_tags, тоесть метод класса модели, но так мы понимаем, что этот метод выбирает определенные записи из БД по неким критериям
  # ->(tags) do ... end - далее метод принимает лямбду с параметором(коллекция @tags из index), тоесть тег из запроса и блоком
    questions = includes(:user) # тоесть тут было бы Question.includes(:user) тк вернем эту переменную к вызову от модели
    if tags # если тег передан
      questions = questions.joins(:tags).where(tags: tags).preload(:tags) # то джойним запрос с таблицой тегов и выбираем вопросы у которых есть тег как в переданном параметре
    else # если вопрос не передан то выбираем все вопросы с тегами
      questions = questions.includes(:question_tags, :tags)
    end
    questions.order(created_at: :desc) # возвращаем к константе модели с сортировкой
  end
end
# Различия между scope и методом класса в то что scope всегда возвращает relation, а обычный метод класса может вернуть nil, поэтому для метода класса нужны доп проверки или использовать &. scope удобный инструмент, но реализация скрыта что может привести к проблемам при использовании со сложной логикой. Поэтому, при простой логике - scope, при сложной - метод класса. Хотя scope тоже может содержать сложную логику, тк может быть расширен модулями scope.extended


puts
puts '                              TomSelect, ajax и поиск, парсинг json(serialize)'

# Альтернативы для TomSelect:
# а. select2(устарел, тк зависит от JQuery) https://select2.org/data-sources/ajax
# б. библиотека choices.js. Ну и кроме того, есть и другие select библиотеки на ванильном JS

# TomSelect - решение для удобного селектора со стилями и JS. По умолчанию имеет поддержку бутстрап 5
# Канал SupeRails делал ролик по этой библиотеке с реализацией на ванильном JS и Stimulus JS. Ещё подробнее инструкция - https://blog.corsego.com/select-or-create-with-tom-select. Эта реализация интересна ещё и тем что можно автоматически создавать тэги прямо в форме создания объекта. Есть алгоритм использования этой библиотеки с async/await.

# Установка TomSelect:
# > yarn add tom-select
# в package.json добавилось "tom-select": "^2.3.1",

# Подключение и скрипт для TomSelect:
# В app/javascript создадим подпаку для отдельных скриптов - script (можно и прямо в application.js писать скрипты, но тогда там будет каша)
# В app/javascript/script создадим фвил select.js в котором собственно и будет код скрипта для нашего селектора с TomSelect, не забываем подключить фаил select.js в application.js
# Для переводов придется отдельно сделать в директории script подпапку i18n и в ней фаил с переводами select.json
# Так же подключим стили для TomSelect в app/assets/stylesheets/application.bootstrap.scss


puts
# questions/index.html.erb - добавим секцию с формой для поиска вопросов по тегам, при помощи которой будем отображать на главной только те вопросы у которых есть выбранные в селекторе теги

# Но для него в контроллер вопросов придется добавить запрос на все теги чтобы заполнить селектор
def index
  # ...
  @tags = Tag.all # добавляем список всех тегов для селектора тегов
end
# Но выведение результатов Tag.all для селектора слишком затратно и неудобно если тегов очень много, тк отобразит в селекторе абсолютно все теги
# Поэтому удалим эту строку с запросом(@tags = Tag.all if !@tags) и вместо этого списка тегов в селекторе реализуем асинхронный поиск по введенному тексту от юзера, при помощи ajax


# (Альтернатива serialize: jBuilder - урок 16)

# serialize/сериализатор это программа которая генерирует объект json (тут из коллекции объектов Руби)
# Бывают разные сеарилизаторы, например:
# https://github.com/jsonapi-serializer/jsonapi-serializer
# https://github.com/procore-oss/blueprinter?ref=procore-engineering-blog
# Тут используем 2й, тк он менее навороченый

# Добавим blueprinter в гемфаил
gem 'blueprinter'
# > bundle i

# Далее создаем дирректорию app/blueprints (название любое ??) и фаил tag_blueprint.rb в ней с классом содержащим описание того как нужно сериализовать наши теги в json (те как именно генерировать json с коллекцией тегов)
class TagBlueprint < Blueprinter::Base
  identifier :id # тоесть идентификатором в json будет id тега
  fields :title # значением будет title тега
end


# Нам понадобится пространство имен которое назовем api:

# Создадим новое простанство имен namespace :api и в нем маршрут для тегов по которому будут передаваться введеные пользователем символы
Rails.application.routes.draw do
  # ...
  namespace :api do
    resources :tags, only: :index
  end
  # не помещвем его в скоуп с локалями, тк от локалей он зависеть не будет
end

# Создадим пространство имен и контроллер в директории контроллеров controllers/api/tags_controller.rb с экшеном index, который будет возвращать объект json
module Api
  class TagsController < ApplicationController
    def index # GET '/api/tags.json?term=k'  # если ввели букву k
      tags = Tag.arel_table
      # arel_table - метод использует ARIAL, изначально есть в Рэилс, создает чтото что посзволяет удобнее писать сложные SQL запросы на Руби
      @tags = Tag.where(tags[:title].matches("%#{params[:term]}%"))
      # tags[:title] - тоесть названия тегов из Tag.arel_table
      # matches("%#{params[:term]}%")) - метод проверяет на LIKE соответсвие
      # params[:term] - то что пользователь вводит в селектор
      render json: TagBlueprint.render(@tags)
      # render json:  -  рендерим на страницу json
      # TagBlueprint.render(@tags) - через наш класс сериализатора Blueprint превращаем коллекцию тегов в json
      # не нужно представление api/tags/index.json тк это просто рендер json на страницу
      # http://localhost:5000/api/tags.json - можно посмотреть объект целиком (через паблик ??)
    end
    # Тоесть теперь теги для селектора мы берем из json который генерится каждый раз когда пользователь чтото вводит в селектор
  end
end

# Так же дополнительно можно добавить атрибуты классов и data в форму questions/_form.html.erb чтобы использовать такойже ассинхронный запрос и там на страницах questions/new.html.erb и questions/edit.html.erb
# Теперь в questions_controller.rb нам больше не нужен функционал для отображения тегов в селекторах для new и edit
class QuestionsController < ApplicationController
  # ...
  before_action :fetch_tags, only: %i[new edit] # удаляем
  # ...
  def fetch_tags # удаляем
    @tags = Tag.all
  end
end






















#
