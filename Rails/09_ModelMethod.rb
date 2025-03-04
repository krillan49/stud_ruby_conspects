puts '                                       Методы экземпляра модели'

# Можем использовать везде где они доступны(модели, контроллеры итд)

# new_record? - проверяет новая ли запись, те экземпляр модели созданный через new но не заполненный
User.find(params[:id]).new_record? #=> false
User.new.new_record?               #=> true

# update (self.update) - метод обновления сущности(метод экземпляра модели обновляющий запись в БД)
update password_reset_token: digest(SecureRandom.urlsafe_base64), password_reset_token_sent_at: Time.current
# password_reset_token:                      - имя колонки в таблице в которой обновляем значение
# digest(SecureRandom.urlsafe_base64)        - значение, тут хэш-токен, сгенерированный методом digest
# password_reset_token_sent_at: Time.current - имя и значение для еще одной котонки



puts '                                            Ассоциации'

# !! Потом дополнить

class Comment < ApplicationRecord
  belongs_to :article # модель создалась с ассоциацией article. Тоесть комментарии принадлежат статье. Можно добавлять вручную если в генераторе не указать article:references
  # Comment.find(id).article - теперь можно обращаться от любого коммента к статье которой он пренадлежит через метод article
end

class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  # :comments - добавим ассоциацию comments, тоесть статья связывается с комментами (множественное число).
  # Article.find(id).comments - теперь можно обращаться от любой статьи к коллекции (массив) принадлежащих ей комментов через метод comments
  # dependent: :destroy  - параметр который и позволит нам удалять статьи у которых созданы принадлежащие им комменты (сначала удаляет комменты а потом саму статью)
end



puts '                                  Кастомный метод экземпляра модели'

# Метод экземпляра созданный в классе модели, может быть вызван от экземпляров этой модели(сущностей), например в представлениях

class Question < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  # Кастомный метод экземпляра модели, тут для кастомного форматирования дат. Пример использования в questions/show.html.erb
  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
    # created_at - стандартный инстанс метод сущности возвращающий из соответсвующего поля таблицы дату создания
  end
end



puts '                                       Виды способов update'

# https://davidverhasselt.com/set-attributes-in-activerecord/

# Возможным способы назначения атрибута или обновления записи: update_attribute, update, update_column, update_columns etc. Например, они отличается в таких аспектах, как запуск валидаций, касание updated_at объекта или запуск обратных вызовов.



puts '                                           update_column'

# ?? В чем оличие от update хз ??

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


puts '                                 update_attribute и update_attributes'

# Оба эти метода обновят объект без необходимости явного указания ActiveRecord выполнить обновление.

# Разница между ними в том, что update_attribute использует save(false), тогда как update_attributes использует save, что тоже самое, что save(true).
# save(perform_validation = true) - если perform_validation значение равно false, то он обходит (правильнее будет сказать пропускает) все проверки, связанные с save.

# Также стоит отметить, что при использовании update_attribute обновляемый атрибут не обязательно должен быть в белом списке для attr_accessible, в отличие от  update_attributes, который обновляет только attr_accessible атрибуты.


# 1. update_attribute - обновляет один отдельный атрибут объекта и сохраняет запись без вызова обычной проверки на основе модели. Это особенно полезно для булевых флагов в существующих записях. update_attribute не обходит стороной обратные вызовы.
obj = Model.find_by_id(params[:id])
obj.update_attribute(:only_one_field, 'Some Value')

# Исходный код метода update_attribute vendor/rails/activerecord/lib/active_record/base.rb, line 2614:
def update_attribute(name, value)
  send(name.to_s + '=', value)
  save(false)
end


# 2. update_attributes - обновляет несколько или все атрибуты из переданного хеша, проходит проверку на основе модели и сохраняет запись. Если объект недействителен(если проверка не пройдена), сохранение не удастся и будет возвращено false, тоесть запись не обновляется.
obj = Model.find_by_id(params[:id])
obj.update_attributes(field1: 'value', field2: 'value2', field3: 'value3')
# или если вы получаете все поля в хэше, скажем, params[:user] здесь используйте просто
obj.update_attributes(params[:user])

# Исходный код метода update_attributes vendor/rails/activerecord/lib/active_record/base.rb, line 2621:
def update_attributes(attributes)
  self.attributes = attributes
  save
end



puts '                               Статический Метод модели - scope синтаксис'

# Различия между scope и обычным статическим методом модели в том, что scope всегда возвращает relation(?? AR-результат запроса к БД ??), а обычный метод класса может вернуть nil, поэтому для обычного метода класса могут быть нужны дополнительные проверки проверки или использовать &.

# scope - удобный инструмент, но реализация скрыта, что может привести к проблемам при использовании со сложной логикой. Поэтому, при простой логике - scope, при сложной - обычный метод класса. Хотя scope тоже может содержать сложную логику, тк может быть расширен модулями scope.extended

# При помои scope удобно прописывать сложные SQL запросы, чтобы вызывать в котроллере эти скоупы и не засирать его кодом запросов


# На примере(ManyToMany) функционала поиска вопросов по тегу в tags/_tag.html.erb (рендерится в _question, который в свою очередь рендерится в _index). Тоесть в параметрах может придти дополнительная часть с наименованием индексорв тегов, тогда нужно вывести только вопросы с этими тегами, а может и нет, тогда выводим все вопросы

# questions_controller.rb
def index # GET '/questions' или GET '/questions?tag_ids=1'
  @tags = Tag.where(id: params[:tag_ids]) if params[:tag_ids] # либо тег с айди, совпадающим с переданным, либо nil
  # params[:tag_ids] - айди тега (?tag_ids=1) переданный из _tag.html.erb при помощи questions_path(tag_ids: tag)
  @pagy, @questions = pagy Question.all_by_tags(@tags)
  # all_by_tags(@tags) - статический метод модели(код ниже), передаем в него тег из запроса - выбирает только те вопросы, которые имеют этот тег, id которого мы получили из params[:tag_ids], если же id не было передано то выбираем все вопросы
  @questions = @questions.decorate
end

# В модели question.rb добавим метод класса при помощи синтаксиса scope
class Question < ApplicationRecord
  # ...
  scope :all_by_tags, ->(tags) do
  # scope :all_by_tags  - это в Рэилс по сути тоже самое что и def self.all_by_tags, тоесть метод класса модели, но так мы понимаем, что этот метод выбирает определенные записи из БД по неким критериям
  # ->(tags) do ... end - далее метод принимает лямбду с параметором(коллекция @tags из index)
    questions = includes(:user) # тоесть Question.includes(:user) тк вызываем один статический метод в другом
    if tags # если тег передан
      questions = questions.joins(:tags).where(tags: tags).preload(:tags) # то джойним запрос с таблицой тегов и выбираем вопросы у которых есть тег как в переданном параметре
    else # если переменная tags возвращает nil
      questions = questions.includes(:question_tags, :tags)
    end
    questions.order(created_at: :desc) # возвращаем отсортированную коллекцию
  end
end



puts '                                          Опции валидаций'

validates :password, confirmation: true, allow_blank: true, length: {minimum: 8, maximum: 70}
# confirmation: true - значение поля :password должно совпадать со значением в поле :password_confirmation
# allow_blank: true  - можно оставить поле пустым



puts '                             Виртуальный атрибут модели. Кастомные валидации'

# (?? Отличия validate от validates - validate для проверки кастомного метода, а validates для проверки атрибута ??)

# Виртуальный атрибут - это атрибут модели, для которого не существует поля в таблице. Нужен например если нужно проверить какието дополнительные данные переданные через форму, которые в отличие от остальных не нужно заносить в БД

class User < ApplicationRecord
  attr_accessor :old_password # добавим новый виртуальный атрибут в модель, тк будем присваивать в него данные из формы

  validate :correct_old_password, on: :update, if: -> { password.present? }
  # :correct_old_password        - наш кастомный метод валидации
  # on: :update                  - валидация будет происходить только при обновлении записи, тоесть если сущность проверяеттся из экшена update
  # if: -> { password.present? } - условие с лямбдой, без выполнения которого валидация проводиться не будет

  private

  def correct_old_password
    return if old_password == 'qwerty123456' # если соответсвует ничего не делаем
    errors.add :old_password, 'is incorrect' # вызываем ошибку валидации с сообщением если значение в поле неправильное
  end
end



puts '                                          Consern для модели'

# Consern-ы для модели это модули, которые хранятся в директории app/models/conserns отдельными фаилами. Они нужны чтобы выносить код например по определенным задачам или повторяющиеся в разных моделях валидации в отдельные нэймспэйсы, чтобы модели не были громоздскими и чтобы какой-то функционал можно было переиспользовать в разных моделях, не повторяя код

# 1. Создаем необходимые консерны в директории app/models/conserns
module SomeMethods # консерн это модуль
  extend ActiveSupport::Concern # подключаем функционал консернов

  included do # в блоке included будет то что мы хотим подключить в модели
    def meth1 # например методы
      # ... какойто фунуционал ...
    end
    # ... еще какието методы ...
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
