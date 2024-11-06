puts '                                 callbacks(функции обратного вызова)'

# https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html
# https://guides.rubyonrails.org/active_record_callbacks.html

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



puts '                                               Еще колбэки'

# Пример из models/conserns/concerns/recoverable.rb
before_update :clear_reset_password_token, if: :password_digest_changed? # запустим метод через колбэк
# before_update - колбэк запускающий метод после прохождения валидаций, но до сохранения в БД (тут нового пароля)
# if: :password_digest_changed? - колбэк сработает только если пароль был изменен, метод password_digest_changed? создаст автоматически, по названию поля password_digest

















#
