puts '                                          Декораторы. Draper'

# Хэлперы лежат в глобальном пространстве имен, поэтому не всегда стоит их использовать, а можно воспользоваться декораторами

# Декораторы нужны для того, чтобы добавлять к нашим объектам дополнительные методы, которые содержат функционал по отображению именно этого конкретного объекта. Они живут не в глобальном пространстве имен, а только для тех конкрктных объектов(а не всех объектов модели), для которых мы их назначим

# ?? Декоратор это управляющая прослойка/фильтр над моделью ??

# draper - гем декоратор
# https://github.com/drapergem/draper
gem 'draper', '~> 4.0'
# > bundle install

# Сгенерируем базовый декоратор от которого будут наследовать остальные декораторы:
# > rails generate draper:install
# app/decorators/application_decorator.rb - создалась директория и материнский декоратор
class ApplicationDecorator < Draper::Decorator
end



puts '                                   Генерация декоратора для User'

# Сделаем метод экземпляра в декораторе чтобы, если юзер не введет имя при регистрации, то будет использоваться его преобразованный email, а если введет то name.


# 1. Сгенерируем декоратор для User(в нем мы и будем прописывать логику отображения имени)
# > rails generate decorator User
# app/decorators/user_decorator.rb
class UserDecorator < ApplicationDecorator
  delegate_all # это(создано при генерации) нужно чтобы делегировать неизвестные методы(втч изначальные методы, например name email) в модель. Тоесть если задекорированый объект вызовет метод которого нет в декораторе, то этот метод он получит от модели. Тоесть это чтото вроде super ??

  # Создадим метод, который будет выполнять метод name если имя есть у объекта иначе вернет распарсеный email
  def name_or_email
    return name if name.present? # если имя есть то просто его выведем
    email.split('@')[0] # если имени нет, то сделаем его из имэила, взяв строку до символа @
  end
end
# Естественно в своих декораторах мы можем дополнительно прописать всякий другой функционал


# 2. Задекорируем текущего юзера(сделаем юзера способным вызывать методы декоратора) прямо в методе в application_controller.rb(или в соответсвующем консерне authentication.rb) те в том месте где его находим/определяем
def current_user
  @current_user ||= User.find_by(id: session[:user_id]).decorate if session[:user_id].present?
  # decorate - метод который делает объект декорируемым(?? переключает обработку методов от модели в декоратор ??)
end


# 3. Теперь мы можем использовать наш метод декоратора name_or_email на юзере в _menu.html.erb


# 4. В users_controller.rb в экшен create тоже стоит добавить наш метод name_or_email вместо name
def create
  @user = User.new user_params
  if @user.save
    session[:user_id] = @user.id
    flash[:success] = "Welcome to the app, #{current_user.name_or_email}!" # можно было бы и задекорировать @user, но удобнее использовать current_user, тк тут он уже доступен тк пользователь зарегистрирован и впущен в систему
    redirect_to root_path
  else
    render :new
  end
end



puts '                             Декорация объектов с пагинацией (Draper и Pagy)'

# Сгенерируем декораторы для вопроса и ответа для того чтобы поместить в них методы для форматирования даты из моделей question.rb и answer.rb:

# > rails generate decorator Question
# app/decorators/question_decorator.rb
class QuestionDecorator < ApplicationDecorator
  delegate_all
  def formatted_created_at # перемещаем этот метод из модели question.rb сюда. Тк это относится к логике отображения а не к валидации и тому подобному, то корректнее держать это в декораторе
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
# > rails generate decorator Answer
# app/decorators/answer_decorator.rb
class AnswerDecorator < ApplicationDecorator
  delegate_all
  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end

# Далее просто задекорируем объекты в экшенах контроллера questions, чтобы все работало
def index
  @pagy, @questions = pagy Question.order(created_at: :desc)#.decorate  - так делать нельзя тк произойдет конфликт decorate с pagy изза чего в пагинации будет отображаться только 1 страница
  @questions = @questions.decorate # задекорируем объект вопросов отдельно(так не будет конфликта с pagy).
end
def show
  @question = @question.decorate # добавим эту строку - предварительно задекорируем
  @answer = @question.answers.build
  @pagy, @answers = pagy @question.answers.order(created_at: :desc)
  @answers = @answers.decorate # декорируем answers тут в экшенe show questions(тк ответ обрабатывается в нем)
end
# Так же задекорируем объекты в экшенах контроллера answers, чтобы все работало
def create
  @answer = @question.answers.build answer_params
  if @answer.save
    flash[:success] = 'Answer created!'
    redirect_to question_path(@question)
  else
    @question = @question.decorate # добавим эту строку - предварительно задекорируем
    @pagy, @answers = pagy @question.answers.order created_at: :desc
    @answers = @answers.decorate # декорируем answers
    render 'questions/show'
  end
end



puts '                           Декорация объекта вызванного от метода ассоциации'

# Декорация сущьности, вызванной от метода ассоциации (question.user, answer.user) в OneToMany -> User 1 - * Some

# Модели:
class User < ApplicationRecord
  has_many :questions, dependent: :destroy # User.find(1).questions
  has_many :answers, dependent: :destroy   # User.find(1).answers
end
class Question < ApplicationRecord
  belongs_to :user   # Question.find(1).user
end
class Answer < ApplicationRecord
  belongs_to :user   # Question.find(1).user
end

# Задекорируем ассоциации для user (question.user, answer.user) при помощи спец синтаксиса прямо в декораторах вопросав и ответов, тк будем в представлениях применять к юзеру вызванному при помощи методов ассоциаций(взятому из таблицы) метод name_or_email(question.user.name_or_email, answer.user.name_or_email) и нам нужно чтобы юзер любого вопроса или ответа декорировался
class QuestionDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user # синтаксис автоматически декорирует ассоциацию юзера, получинную от вопроса
end
class AnswerDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user # синтаксис автоматически декорирует ассоциацию юзера, получинную от ответа
end



puts '                       Отображение аватаров юзера при помощи декораторов и Gravatar'

# Покачто упрощенная реализация через Gravatar, без загрузки в БД

# https://docs.gravatar.com/general/images/
# Gravatar - это сторонний сервис(сайт) глобальных аватаров, те для привязки аватара к имэйлу, чтобы автоматически использовать его на других сайтах
# Нужно зарегаться на сайте граватара, загрузить туда аватарку и привязать ее к имэйлу, далее при использовании этого имэйла на других сайтах, если они поддерживают Gravatar, будет отображаться данная аватарка
# Gravatar хэширует имэил пользователя и добавляет хэш к адресу ссылки, ведущему к аватарке, например так:
# https://gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50 и потом аватар на нашем сайте можно применить, например через тег картинки <img src="https://gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50" />. Удобно что можно настраивать размер. Если пользователь не использует граватар, то будет аватар по умолчанию

# 1. Создадим метод граватара в декораторе юзера user_decorator.rb
class UserDecorator < ApplicationDecorator
  # ...
  def gravatar(size: 30, css_class: '')
    # size - опция размера картинки, по умолчанию установлена в атрибутах
    # css_class - можем так же применить сразу стили, по умолчанию нет
    email_hash = Digest::MD5.hexdigest email.strip.downcase # генерируем хэш на основе имэйла пользователя. Дополнительно обрезаем пробелы и помещаем в нижний регистр - это требования граватара
    h.image_tag "https://www.gravatar.com/avatar/#{email_hash}.jpg?s=#{size}", class: "rounded #{css_class}", alt: name_or_email
    # h - объект префикса, обозначает что мы хотим использовать хэлпер Рэилс (?? это для граватара или декоратора надо ??)
    # image_tag - хэлпер для генерации тега <img ...>
    # email_hash - помещаем сгенерированный выше хэш в адрес изображения
  end
end

# 2. Применим в _quesion.html.erb метод gravatar к объекту юзера, а так же в shared/_menu.html.erb рядом с именем текущего юзера
# Далее можно применить тоже самое на всех страницах, где мы отображам зависимые от юзера сущьности: questions/show.html.erb, answers/_answer.html.erb














#
