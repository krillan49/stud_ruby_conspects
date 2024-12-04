puts '                                 callbacks(функции обратного вызова)'

# https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html
# https://guides.rubyonrails.org/active_record_callbacks.html
# https://rusrails.ru/active-record-callbacks

# колбэки - это методы, которые будет выполняться, когда объект Active Record инициализируется, создается, сохраняется, обновляется, удаляется, проверяется на валидность или загружается из БД

# Для того, чтобы использовать доступные колбэки, их необходимо реализовать и зарегистрировать. Реализация может быть выполнена с помощью обычных методов, блоков и proc, или путем определения пользовательских объектов колбэков с использованием классов или модулей
class User < ApplicationRecord
  validates :username, :email, presence: true

  # 1. Колбэки с помощью специального макро-метода класса, который вызывает обычный метод для реализации
  before_validation :ensure_username_has_value
  # before_validation - колбэк, макро-метод класса, который вызывает метод перед каждой валидацией
  # ensure_username_has_value - имя нашего метода (ниже) который будет вызван

  # 2. Макро-методы класса также могут принимать блок вместо метода. Их следует использовать, если код внутри блока такой короткий, что помещается в одну строчку.
  before_validation do
    self.username = email if username.blank?
  end

  # 3. Можно передать в колбэк proc, который будут выполнен
  before_validation ->(user) { user.username = user.email if user.username.blank? }

  # 4. можно определить собственный объект колбэка (Ниже)
  before_validation AddUsername

  private # Считается хорошей практикой объявлять методы колбэков как private. Если их оставить public, они могут быть вызваны извне модели и нарушить принципы инкапсуляции объекта

  def ensure_username_has_value
    self.username = email if username.blank?
  end
end
# Класс создающий объект коллбека
class AddUsername
  def self.before_validation(record)
    record.username = record.email if record.username.blank?
  end
end


# Колбэки можно регистрировать для срабатывания только на определенных событиях жизненного цикла, с помощью опции :on, которая позволяет полностью контролировать, когда и в каком контексте будут вызываться колбэки.
before_validation :ensure_username_has_value, on: :create
after_validation :set_location, on: [ :create, :update ] # :on также принимает массив



puts '                                       Все доступные колбэки AR'

# Список всех доступных колбэков Active Record, перечисленных в том порядке, в котором они вызываются в течение соответствующих операций:


# 1. Создание объекта:
# before_validation
# after_validation
# before_save
# around_save
# before_create
# around_create
# after_create
# after_save
# after_commit / after_rollback

# 1.1. Валидационные колбэки - вызываются когда запись проверяется на валидность напрямую через методы valid? (или его псевдоним validate) или invalid?, или косвенно через методы create, update или save. Они выполняются до и после этапа валидации.
before_validation :titleize_name
after_validation :log_errors

# 1.2. Колбэки сохранения - вызываются когда запись передается (т.е. "сохраняется") в БД с помощью методов create, update или save. Они вызываются до, после и во время сохранения объекта.
before_save :hash_password
around_save :log_saving
after_save :update_cache

# 1.3. колбэки создания - вызываются когда запись впервые передается (т.е. "сохраняется") в базу данных. Другими словами, они срабатывают при сохранении новой записи с помощью методов create или save. Они вызываются до, после и во время создания объекта.
before_create :set_default_role
around_create :log_creation
after_create :send_welcome_email


# 2. Обновление объекта - вызываются всякий раз, когда существующая запись передается (т.е. "сохраняется") в базу данных. Они вызываются до, после и во время обновления объекта.
# before_validation
# after_validation
# before_save
# around_save
# before_update
# around_update
# after_update
# after_save
# after_commit / after_rollback
# Колбэк after_save вызывается как при создании, так и при обновлении записей. Однако он всегда выполняется после более специфичных колбэков after_create и after_update, независимо от порядка вызова макросов. Аналогично, колбэки before_save и around_save следуют тому же правилу: before_save запускается перед созданием/обновлением, а around_save — вокруг операций создания/обновления. Важно отметить, что колбэки сохранения всегда будут выполняться до/вокруг/после более специфических колбэков создания/обновления.

# 2.1. Колбэки обновления
before_update :check_role_change
around_update :log_updating
after_update :send_update_email

# 2.2. Комбинирование колбэков - Во многих случаях для достижения нужного поведения требуется комбинация колбэков. Например, вы можете захотеть отправить приветственное письмо после создания пользователя, но только если это новый пользователь, а не обновляемый. При обновлении информации о пользователе вы можете захотеть уведомить администратора, если были изменены важные данные. В этом случае вы можете использовать вместе колбэки after_create и after_update.
after_create :send_confirmation_email
after_update :notify_admin_if_critical_info_updated


# 3. Уничтожение объекта - Колбэки уничтожения вызываются всякий раз, когда запись уничтожается, но игнорируются при удалении записи. Они вызываются до, после и во время уничтожения объекта.
# before_destroy
# around_destroy
# after_destroy
# after_commit / after_rollback
before_destroy :check_admin_count
around_destroy :log_destroy_operation
after_destroy :notify_users


# 4. after_initialize и after_find - Всякий раз, когда возникает объект Active Record или непосредственно при использовании new, или когда запись загружается из базы данных, будет вызван колбэк after_initialize. Он может быть полезен, чтобы избежать необходимости напрямую переопределять метод Active Record initialize. У колбэков after_initialize и after_find нет пары before_*.
# При загрузке записи из базы данных, будет вызван колбэк after_find. after_find вызывается перед after_initialize, если они оба определены.
after_initialize do |user|
  Rails.logger.info("You have initialized an object!")
end
after_find do |user|
  Rails.logger.info("You have found an object!")
end



puts '                                      Методы активирующие колбэки'

# Методы, которые запускают соответсвующие колбэки по умолчанию:
# create, create!, destroy, destroy!, destroy_all, destroy_by, save, save!, save(validate: false), save!(validate: false), toggle!, touch, update_attribute, update_attribute!, update,update!, valid?, validate

# Дополнительно, колбэк after_find запускается следующими поисковыми методами:
# all, first, find, find_by, find_by!, find_by_*, find_by_*!, find_by_sql, last, sole, take
# Методы find_by_* и find_by_*! это динамические методы поиска, генерируемые автоматически для каждого атрибута.

# Колбэк after_initialize запускается всякий раз, когда инициализируется новый объект класса.



puts '                                          Условные колбэки'

# Возможно сделать вызов метода колбэка условным в зависимости от заданного предиката. Это осуществляется при использовании опций :if и :unless, которые могут принимать символ, Proc или массив.

# При использовании опции :if, колбэк не будет выполнен, если метод предиката возвратит false; при использовании опции :unless, колбэк не будет выполнен, если метод предиката возвратит true. Это самый распространенный вариант.
before_update :clear_reset_password_token, if: :password_digest_changed? # запустим метод через колбэк
# before_update - колбэк запускающий метод после прохождения валидаций, но до сохранения в БД (тут нового пароля)
# if: :password_digest_changed? - колбэк сработает только если пароль был изменен, метод password_digest_changed? создаст автоматически, по названию поля password_digest

before_save :normalize_card_number, if: ->(order) { order.paid_with_card? }
before_save :normalize_card_number, if: -> { paid_with_card? } # Так как proc вычисляется в контексте объекта, также возможно написать так

# Опции :if и :unless также принимают массив из proc или имен методов в виде символов:
before_save :filter_content, if: [:subject_to_parental_control?, :untrusted_author?]
before_save :filter_content, if: [:subject_to_parental_control?, -> { untrusted_author? }]

# В колбэках можно смешивать :if и :unless в одном выражении:
before_save :filter_content, if: -> { forum.parental_control? }, unless: -> { author.trusted? }



puts '                                           Пропуск колбэков'

# Как и в валидациях, возможно пропустить колбэки с помощью следующих методов вместо обычных create итд: decrement!, decrement_counter, delete, delete_all, delete_by, increment!, increment_counter, insert, insert!, insert_all, insert_all!, touch_all, update_column, update_columns, update_all, update_counters, upsert, upsert_all

# Например так колбеки на обновление почты не сработают:
user = User.find(1)
user.update_columns(email: 'new_email@example.com')



puts '                                            Колбэки связей'

# Колбэки связей похожи на обычные колбэки, но они вызываются событиями в жизненном цикле связанной коллекции. Существует четыре доступных колбэка связей:
# before_add
# after_add
# before_remove
# after_remove
# Можно определить колбэки связей, добавив опции к самой связи

# Автор может иметь множество книг, но прежде чем добавлять книгу в коллекцию автора, нужно убедиться, что автор не достиг своего лимита книг:
class Author < ApplicationRecord
  has_many :books, before_add: :check_limit

  private

  def check_limit
    if books.count >= 5
      errors.add(:base, "Cannot add more than 5 books for this author")
      throw(:abort)
    end
  end
end



puts '                                     Пример колбека для Gravatar'

# Не очень правильно что каждый раз при выводе аватарки при помощи граватара мы в декораторе постоянно пересчитываем хэш имэйла, тк на странице может быть куча этих аватарок. И так как хэш одной и той же строки всегда получается одинаковым, то лучше сохранять этот хэш в БД для каждого юзера(закэшировать)

# Создадим новую миграцию чтобы добавить поле для хэшей в таблицу users:
# > rails g migration add_gravatar_hash_to_users gravatar_hash:string
class AddGravatarHashToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :gravatar_hash, :string # прописалось автоматически тк правильный синтаксис при генерации
  end
end
# > rails db:migrate

# Хэш нам нужно будет генерировать и заносить в БД когда регистрируется новый пользователь, а так же когда пользователь меняет свой имэйл(тк хэшируется имэйл). Для этого нам и пригодятся функции обратного вызова
# Функции обратного вызова можно прописывать в моделях

# Пропишем колбэк в модели user.rb
class User < ApplicationRecord
  # ... аксессоры, ассоциации, валидации

  before_save :set_gravatar_hash, if: :email_changed?
  # before_save - колбэк, который выполняется каждый раз, когда запись сохраняется в БД (как новая так и апдэйт)
  # :set_gravatar_hash - метод(ниже) который будет исполнен колбэком (но можно прямо тут передать лямбду или процедуру)
  # if: - означет что для выполнения колбека существует условие
  # :email_changed? - условие выполнения колбэка, тут проверяется методом, который автоматически создает Рэилс, он проверяет, был ли изменен имэйл сущности

  # ... методы

  private

  def set_gravatar_hash
    return if email.blank? # выходим если нет имэйла
    hash = Digest::MD5.hexdigest email.strip.downcase # посчитаем хэш из имэйла так же как в декораторе
    self.gravatar_hash = hash # присваиваем в метод поля колонки текущей записи(юзера). Тоесть перед тем как сохранить юзера (новый или апдэйт), к нему в колонку gravatar_hash добавится это значение
  end
  # ...
end

# Теперь можем не считать в декораторе хэш и соотв удалить email_hash = Digest::MD5.hexdigest email.strip.downcase
class UserDecorator < ApplicationDecorator
  # ...
  def gravatar(size: 30, css_class: '')
    h.image_tag "https://www.gravatar.com/avatar/#{gravatar_hash}.jpg?s=#{size}", class: "rounded #{css_class}", alt: name_or_email
    # gravatar_hash - теперь просто используем значение взятое из свойства юзера (БД)
    # можно было бы сохранять не только хэш а весь URL, но малоли детали ссылки изменятся в новых версиях граватара
  end
end

# Но у нас в БД до добавления этого функционала уже могли быть юзеры и нам надо посчитать хэши их имэйлов и добавить в БД в соот колонку этих юзеров. Для этого воспользуемся db/seeds.rb, чтобы заполнить БД этими данными.
User.find_each do |u| # тоесть для каждого юзера проделаем:
  u.send(:set_gravatar_hash) # применим к юзерам метод модели set_gravatar_hash (через send чтобы обойти private)
  u.save                     # сохраняем юзера(обновляем его запись в БД)
end
# > rails db:seed














#
