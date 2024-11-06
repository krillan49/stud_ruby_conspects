puts '                                          Scaffolding'

# Scaffolding - генерация модели, вида и контроллера одной командой

# scaffold - генератор создает одновременно модель, контроллер, экшены, маршруты, представления, тесты по REST resourses.

# То что все равно придется делать руками:
# 1. Нет валидации по умолчанию
# 2. Нет аутонтификации по умолчанию
# 3. Тесты по умолчанию только самые примитивные



# На примере сильно упрощенного блога из 2х моделей User 1 - * Micropost:

# Создадим модель, контроллер, экшены, маршруты, представления, тесты для сущности User
# > rails g scaffold User name:string email:string

# Создадим модель, контроллер, экшены, маршруты, представления, тесты для сущности Micropost
# > rails g scaffold Micropost content:text user_id:integer

# > bundle exec rake db:migrate

# Добавим ассоциации one-to-many между пользователем и микропостом User 1 - * Micropost и валидации:
class Micropost < ApplicationRecord
  belongs_to :user
  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true
end
class User < ApplicationRecord
  has_many :microposts
  validates :name, presence: true
  validates :email, presence: true
end
# По умолчанию выведет список ошибок в автоматически созданном для этого в представлении коде

# Пример экшена из users_controller.rb:
def create
  @user = User.new(user_params)

  respond_to do |format|
    if @user.save
      format.html { redirect_to user_url(@user), notice: "User was successfully created." }
      format.json { render :show, status: :created, location: @user }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end














#
