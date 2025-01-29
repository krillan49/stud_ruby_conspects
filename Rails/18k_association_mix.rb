puts '                     (1-to-many) + (many-to-many) между 2мя одними и теми же таблицами'

# Можно установить две разные связи между одними и теми же таблицами/моделями (тут users и podcasts / User и Podcast): одну связь "один ко многим" и другую связь "многие ко многим", тоесть "один пользователь может иметь много подкастов" и "многие пользователи могут подписываться на многие подкасты"


# 1. Связь "1 User to many Podcast" - все стандартно:

# $ rails generate model User name:string
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.timestamps
    end
  end
end
# $ rails generate model Podcast title:string user:references
class CreatePodcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :podcasts do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
# $ rails db:migrate

class User < ApplicationRecord
  has_many :podcasts
end
class Podcast < ApplicationRecord
  belongs_to :user
end


# 2. Связь "many User to many Podcast"

# Тут эта связь означает, что многие пользователи могут подписываться на многие подкасты. Для реализации этой связи понадобится промежуточная таблица (например, subscriptions), которая будет хранить пары user_id и podcast_id.

# Миграция для создания таблицы subscriptions:
# $ rails generate migration CreateSubscriptions user:references podcast:references
class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :podcast, null: false, foreign_key: true
      t.timestamps
    end
    # Добавим индекс и уникальность:
    add_index :subscriptions, [:user_id, :podcast_id], unique: true
  end
end
# $ rails db:migrate

# Создадим модель для промежуточной таблицы:
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :podcast
end

# В модели User добавим ассоциации и дополнительные методы для подписки на подкаст:
class User < ApplicationRecord
  has_many :podcasts           # Один пользователь может иметь много подкастов
  has_many :subscriptions      # Связь с промежуточной таблицей подписок
  has_many :subscribed_podcasts, through: :subscriptions, source: :podcast # Подкасты на которые подписан юзер

  # Метод для подписки на подкаст(?? чето сомнительный не проще ли писать в контроллере)
  def subscribe_to_podcast(podcast)
    subscriptions.create(podcast: podcast)
  end

  # Метод для отписки от подкаста(?? чето сомнительный не проще ли писать в контроллере)
  def unsubscribe_from_podcast(podcast)
    subscriptions.find_by(podcast: podcast)&.destroy
  end
end

# В модели Podcast добавим ассоциации и дополнительный метод для колличества подписчиков подкаста:
class Podcast < ApplicationRecord
  belongs_to :user             # Каждый подкаст принадлежит одному пользователю
  has_many :subscriptions      # Связь с промежуточной таблицей подписок
  has_many :subscribers, through: :subscriptions, source: :user # Подписчики подкаста

  # Метод для получения всех подписчиков подкаста(?? чето сомнительный не проще ли писать subscribers.count)
  def subscriber_count
    subscribers.count
  end
end


# 3. Методы ассоциаций:
user = User.find(user_id)
podcast = Podcast.find(podcast_id)

# все подкасты, созданные пользователем:
user.podcasts

# все пользователи, подписанные на подкаст:
podcast.subscribers
# все подкасты, на которые подписан пользователь:
user.subscribed_podcasts

# подписаться на подкаст:
user.subscribe_to_podcast(podcast)
# отписаться от подкаста:
user.unsubscribe_from_podcast(podcast)
# количество подписчиков у подкаста:
podcast.subscriber_count


# Теперь:
# • Один пользователь может иметь много подкастов (User has_many Podcasts).
# • Один подкаст принадлежит одному пользователю (Podcast belongs_to User).
# • Многие пользователи могут подписываться на многие подкасты (User has_many subscribed_podcasts through subscriptions).
# • Многие подкасты могут иметь многих подписчиков (Podcast has_many subscribers through subscriptions).
# • Есть методы для управления подписками и получения связанных данных.



puts '                       Контроллер, маршруты и представление Subscription(подписки/лайков)'

# 1. Контроллер subscriptions_controller.rb (тут с турбофрэймами):
class SubscriptionsController < ApplicationController
  before_action :set_podcast!

  def create # подписываемся на подкаст, создавая экземпляр Subscription с айдишниками
    subscription = current_user.subscriptions.create(podcast: @podcast)
    respond_to do |format|
      if subscription.save
        flash[:notice] = "Your subscription was successfully created."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("podcast_frame", partial: "podcasts/podcast", locals: { podcast: @podcast }),
            turbo_stream.append("flash", partial: "shared/flash", locals: { message: notice })
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("podcast_frame", partial: "podcasts/podcast", locals: { podcast: @podcast }),
            turbo_stream.replace("alert", partial: "shared/errors", locals: { resource: @podcast })
          ]
        end
      end
      format.html { redirect_to @podcast, notice: notice }
    end
  end

  def destroy # отписываемся, удаляя экземпляр Subscription с айдишниками
    subscription = current_user.subscriptions.find_by(podcast: @podcast)
    respond_to do |format|
      if subscription&.destroy
        flash[:notice] = "Your subscription was successfully deleted."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("podcast_frame", partial: "podcasts/podcast", locals: { podcast: @podcast }),
            turbo_stream.append("flash", partial: "shared/flash", locals: { message: notice })
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("podcast_frame", partial: "podcasts/podcast", locals: { podcast: @podcast }),
            turbo_stream.replace("alert", partial: "shared/errors", locals: { resource: @podcast })
          ]
        end
      end
      format.html { redirect_to @podcast, notice: notice }
    end
  end

  private

  def set_podcast!
    @podcast = Podcast.find_by(id: params[:podcast_id])
  end
end


# 2. Маршруты вложенные в подкасты, чтобы сразу приходило айди подкаста config/routes.rb:
resources :podcasts do
  resources :subscriptions, only: [:create, :destroy]
end


# 3. Кнопка лайка/подписки например, в впредставлении show.html.erb подкаста:
if current_user && current_user.subscriptions.exists?(podcast: @podcast)
  button_to 'Отписаться', podcast_subscription_path(@podcast, 1), method: :delete#, remote: true
  # podcast_subscription_path(@podcast, 1) - тут 1 костыль, тк хэлпер требует айдишшник сущьности, но нам он не нужен тк удаляем от айдишника current_user и подкаста
elsif current_user
  button_to 'Подписаться', podcast_subscriptions_path(@podcast), method: :post#, remote: true
end


# Опционально: Ответ на AJAX-запросы
# Если вы используете `remote: true`, вам может понадобиться обработка ответов на JavaScript. Создайте соответствующие файлы JavaScript для обработки успешных/неуспешных запросов.



puts '                                Еще варики про конфликты(?непонятно?)'

# В Rails могут возникнуть конфликты с именами методов хелперов (helpers), если вы используете одинаковые названия для ассоциаций.

# Рассмотрим ваш случай подробнее:

# 1. Ассоциация "1 ко многим" между `User` и `Podcast`:
class User < ApplicationRecord
  has_many :podcasts
end
class Podcast < ApplicationRecord
  belongs_to :user
end
# Здесь для получения всех подкастов, связанных с пользователем, вы можете использовать метод `podcasts` на объекте `User`.

# 2. Ассоциация "многие ко многим" с использованием промежуточной таблицы. Например, предположим, что у нас также есть модель `Category`, и мы хотим связать `User` с `Podcast` через `Category`:
class User < ApplicationRecord
  has_many :user_categories
  has_many :categories, through: :user_categories
end
class Podcast < ApplicationRecord
  has_many :podcast_categories
  has_many :categories, through: :podcast_categories
end
class Category < ApplicationRecord
  has_many :user_categories
  has_many :users, through: :user_categories
  has_many :podcast_categories
  has_many :podcasts, through: :podcast_categories
end
# Тут, для получения категорий, связанных с пользователем, вы можете использовать метод `categories` на объекте `User`.

### Возможные конфликты:
# Если у вас есть методы с одинаковыми названиями в рамках одной модели, это может привести к путанице. Например, если у вас есть метод `podcasts` для "одного ко многим" и метод `podcasts` для "многих ко многим", это вызовет конфликт.

### Решения:

# 1. Избегать конфликтов через переименование: Если вы понимаете, что у вас могут возникнуть конфликты с именами, вы можете переименовать ассоциации для большей ясности.
class User < ApplicationRecord
  has_many :user_podcasts, class_name: 'Podcast', foreign_key: 'user_id'
  has_many :podcasts, through: :user_podcasts
end

# 2. Использование отдельных методов для получения: Например, можно создать метод, который будет возвращать определенные подкасты в зависимости от ассоциации:
class User < ApplicationRecord
  has_many :podcasts
  has_many :categories, through: :user_categories

  def user_podcasts
    podcasts # методы для получения подкастов, связанного с пользователем
  end

  def associated_podcasts
    # способы получения всех подкастов через другие ассоциации
  end
end
# Таким образом, адекватное именование и четкая организация кода помогут избежать конфликтов и путаницы.















#
