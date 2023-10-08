puts '                                          Scaffolding'

# Scaffolding - генерация модели, вида и контроллера одной командой

# scaffold - генератор создает одновременно модель, контроллер, экшены, маршруты, представления, тесты по REST resourses.

# То что все равно придется делать руками:
# 1. Нет валидации по умолчанию
# 2. Нет аутонтификации по умолчанию
# 3. Тесты по умолчанию только самые примитивные



# Сделаем мини-приложение микропостинг(сильно упрощенный блог):
# ---------------------# ---------------------
# |  users            |# |  microposts       |
# ---------------------# ---------------------
# id     integer       # id        integer
# name   string        # content   text
# email  string        # user_id   integer      # User --1--------*-- Micropost
# ---------------------# ---------------------


# > rails new toy_app
#  не забываем про ошибку таймзон на винде
# > bundle install


# Создадим модель, контроллер, экшены, маршруты, представления, тесты для сущности User
# > rails g scaffold User name:string email:string
# Запустим миграции(тут с правильным синтаксисом, с гемами из гемфаила а не упрощенным)
# > bundle exec rake db:migrate

# Пример экшена из users_controller.rb:
def create
  @user = User.new(user_params)

  respond_to do |format| # отвечает за возврат в зависимости от запроса, если запрос из браузера то возвращает html, а если запрос от JS то возвращает json
    if @user.save
      format.html { redirect_to user_url(@user), notice: "User was successfully created." }
      format.json { render :show, status: :created, location: @user }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end

# В маршрутаж изменим корневую страницу с приветсвия Рэилс на список юзеров users#index
root "users#index" # get '/' => 'users#index'


# Создадим модель, контроллер, экшены, маршруты, представления, тесты для сущности Micropost
# > rails g scaffold Micropost content:text user_id:integer
# > bundle exec rake db:migrate


# Добавим Валидацию в модель Micropost:
class Micropost < ApplicationRecord
  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true
end
# Добавим Валидацию в модель User:
class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
end
# По умолчанию будет проверять в контроллере и затем выведет список ошибок в автоматически созданном для этого в представлении коде


# Добавим ассоциации one-to-many между пользователем и микропостом.
# User --1--------*-- Micropost
# Добавим в модель User:
has_many :microposts
# Добавим в модель Micropost:
belongs_to :user


# Откроем rails console:
first_user = User.first
first_user.microposts                   # все посты этого юзера
first_user.microposts.count             # обратится к БД чтоб посчитать посты(те будет нагружать БД если много использований)
first_user.microposts.length            # прочитает то, что уже есть в памяти, без БД(не делает sql запрос)
micropost = first_user.microposts.first # первый микропост первого пользователя
micropost.user                          # получить пользователя микропоста













# 
