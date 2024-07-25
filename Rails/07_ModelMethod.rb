puts '                                          Опции валидаций'

validates :password, confirmation: true, allow_blank: true, length: {minimum: 8, maximum: 70}
# confirmation: true - значит, что значение поля :password должно совпадать со значением в поле :password_confirmation
# allow_blank: true - можно оставить поле пустым



puts '                                  Кастомный метод экземпляра модели'

# Метод экземпляра созданный в классе модели, может быть использован объектами этой модели, тоесть сущьностями

# Создадим в модели метод, который сможем применять к объекту сущьности, например в представлениях, тут для кастомного форматирования дат
class Question < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  # Создадим наш метод экземпляра
  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
    # created_at - стандартный инстанс метод сущьности возвращающий из соотв поля таблицы дату создания
  end
end
# Пример использования в questions/show.html.erb



puts '                                           update_column'

# update_column - метод экземпляра позволяющий изменить значение строки в таблице определенной колонке прямо из модели

class User < ApplicationRecord
  def add_or_change_nane
    update_column :name, 'Vasya'
    # update_column - метод помещающий чтото в колонку таблицы
    # :name - имя столбца в который помещаем
    # 'Vasya' - значение которое помещаем
  end

  def delete_name
    update_column :name, nil
  end
end



puts '                               Статический Метод модели - scope синтаксис'

# Различия между scope и обычным методом класса модели в том, что scope всегда возвращает relation, а обычный метод класса может вернуть nil, поэтому для обычного метода класса нужны доп проверки или использовать &.
# scope удобный инструмент, но реализация скрыта, что может привести к проблемам при использовании со сложной логикой. Поэтому, при простой логике - scope, при сложной - метод класса. Хотя scope тоже может содержать сложную логику, тк может быть расширен модулями scope.extended


# На примере(ManyToMany) функционала поиска вопросов по тегу в tags/_tag.html.erb (рендерится в _question, который в свою очередь рендерится в _index). Тоесть в параметрах может придти дополнительная часть с наименованием индексорв тегов, тогда нужно вывести только вопросы с этими тегами, а может и нет, тогда выводим все вопросы

# questions_controller.rb
def index # GET '/questions' или GET '/questions?tag_ids=1'
  @tags = Tag.where(id: params[:tag_ids]) if params[:tag_ids] # либо тег с айди с совпадающим с переданным либо nil
  # params[:tag_ids] - айди тега (?tag_ids=1) переданный из _tag.html.erb при помощи questions_path(tag_ids: tag)
  @pagy, @questions = pagy Question.all_by_tags(@tags)
  # all_by_tags(@tags) - статический метод модели(код ниже), передаем в него тег из запроса - выбирает только те вопросы, которые имеют тот тег, id которого мы получили из params[:tag_ids], если же id не было передано то выбираем все вопросы
  @questions = @questions.decorate
end

# В модели question.rb добавим метод класса при помощи синтаксиса scope
class Question < ApplicationRecord
  # ...
  scope :all_by_tags, ->(tags) do
  # scope :all_by_tags - это в Рэилс по сути тоже самое что и def self.all_by_tags, тоесть метод класса модели, но так мы понимаем, что этот метод выбирает определенные записи из БД по неким критериям
  # ->(tags) do ... end - далее метод принимает лямбду с параметором(коллекция @tags из index)
    questions = includes(:user) # тоесть Question.includes(:user) тк вызываем один статический метод в другом
    if tags # если тег передан
      questions = questions.joins(:tags).where(tags: tags).preload(:tags) # то джойним запрос с таблицой тегов и выбираем вопросы у которых есть тег как в переданном параметре
    else # если тег == nil
      questions = questions.includes(:question_tags, :tags)
    end
    questions.order(created_at: :desc) # возвращаем отсортированную коллекцию
  end
end



puts '                             Виртуальный атрибут модели. Кастомные валидации'

# (?? Отличия validate от validates - validate для проверки кастомного метода, а validates для проверки атрибута ??)

# Виртуальный атрибут - это атрибут модели, для которого не существует поля в таблице. Нужен например если нужно проверить какието дополнительные данные переданные через форму, которые в отличие от остальных не нужно заносить в БД

class User < ApplicationRecord
  attr_accessor :old_password # добавим новый виртуальный атрибут в модель, тк будем присваивать в него данные из формы

  validate :correct_old_password, on: :update, if: -> { password.present? }
  # :correct_old_password - наш кастомный метод валидации
  # on: :update - валидация будет происходить только при обновлении записи, тоесть если сущность проверяеттся из экшена update
  # if: -> { password.present? } - условие с лямбдой, без выполнения которого валидация проводиться не будет

  private

  def correct_old_password
    return if old_password == 'qwerty123456' # если соответсвует ничего не делаем
    errors.add :old_password, 'is incorrect' # вызываем ошибку валидации с сообщением если значение в поле неправильное
  end
end



puts '                                          Consern для модели'

# Consern-ы для модели это модули, которые хранятся в директории app/models/conserns отдельными фаилами. Они нужны чтобы выносить код например по определенным задачам или повторяющиеся в рвзных моделях валидации в отдельные нэймспэйсы, чтобы модели не были громоздскими и чтобы какой-то функционал можно было использовать в разных моделях, не повторяя код

# 1. Создаем необходимые консерны в директории app/models/conserns
module SomeMethods # консерн это модуль
  extend ActiveSupport::Concern # подключаем функционал консернов

  included do # в блоке included будет то что мы хотим подключить в модели
    def meth1 # например методы
      # какойто фунуционал
    end
    # еще какието методы
  end
end

# В другой консерн поместим, например общие для нескольких моделей валидации
module SomeValidations
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy
  end
end

# Теперь можем подключить консерны и использовать их функционал в любых моделях
class Answer < ApplicationRecord
  include SomeMethod      # подключаем консерны в модель, теперь весь их функционал работает в модели
  include SomeValidations
  # ...
end

class Question < ApplicationRecord
  include SomeValidations # подключаем консерны в модель
  # ...
end














#
