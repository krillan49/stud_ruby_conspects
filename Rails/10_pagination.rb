puts '                                           Pagination'

# Пагинация - разбитие данных, передаваемых в вид, на отдельные страницы

# Можно сделать как в ручную, так и при помощи гемов



puts '                                            Kaminari'

# https://github.com/kaminari/kaminari

# kaminari - гем для пагинации. Работает с БД через LIMIT и OFFSET

# Gemfile
gem 'kaminari', '~> 1.2'
# > bundle i


# По умолчанию в kaminari есть базовая конфигурация, которая задает все параметры пагинации, но их можно либо изменить применяя методы к коллекции сущностей, либо сгенерировать конфигурацию и отредактировать ее:
# > rails g kaminari:config  -  сгенерирует фаил конфигурации config/initializers/kaminari_config.rb, где можно редактировать параметры пагинации


# Разобьем по страницам в контроллера questions_controller.rb вывод вопросов в questions/index.html.erb
def index
  @questions = Question.order(created_at: :desc).page(params[:page]).per(10)
  # page - метод kaminari который будет разбивать вопросы по отдельным страницам(по умолчаниюпо 25 штук)
  # params[:page] - папаметр :page определяет какую страницу хочет запросить пользователь (При переключении страниц адрес меняется так /questions?page=2)
  # per(10) - необязательный метод изменяющий колличество вопросов на страниице(по умолчанию 25)
end
# Добавим в questions/index.html.erb специальный хэлпер kaminari - paginate для того чтобы переключаться по страницам. Этот хэлпер базовый, есть и другие с различными дополнитеотными параметрами

# Если всего вопросов будет меньше или равно числу на одной странице то ссылки пагинации не будут отображаться


# По умолчанию стили ссылок/кнопок переключения страниц довольно убогие, но у kaminari есть специальные опции для Бутстрапа(но вроде только 4й версии ??) поэтому можно добавить стили вручную, сгенерировав паршалы всех элементов пагинации и применив к ним стили бутстрапа из раздела pagination

# > rails g kaminari:views default  - генерируем паршалы kaminari(можно указать разные параметры вместо default)
# В первую очередь нас интересует главный паршал kaminary\_paginator.html.erb, стилезуем его и другие паршалы при помощи бутстрапа

# kaminary по умолчанию использует i18n (в скрытом фаиле похоже)



puts '                                              Pagy'

# https://ddnexus.github.io/pagy/
# https://github.com/ddnexus/pagy
# https://ddnexus.github.io/pagy/docs/migration-guide/   -  перейти с Каминари или других гемов

# pagy - гем для пагинации, он чуть сложнее kaminari но работает быстрее особенно для большого колличества данных. Так же его возможности по кастомизации больше. Так же он может работать с самыми разными данными, а не только с Актив Рекорд. Поодержка бутстрап 5 есть при помощи хэлпера.



# Мигрируем на Pagy с Kaminari (но похоже и по дефолту так можно)

# 0. Удалим папку каминари с паршалами и фаил каминари из конфига, запись из Gemfile, методы из контроллера и представлений.

# 1. Создаем конфигурационный фаил config/initializers/pagy.rb
# https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb   -  отсюда копируем весь код в config/initializers/pagy.rb
# Далее добавим в config/initializers/pagy.rb строку:
require 'pagy/extras/bootstrap' # Это специальные методы которые будут выводить пагинацию со стилями бутстрэп

# 2.  Gemfile
gem 'pagy', '~> 6.2'
# > bundle u

# 3. application_controller.rb - подключим методы для бэкэнда
class ApplicationController < ActionController::Base
  include Pagy::Backend
end

# 4. application_helper.rb - подключим методы для фронтэнда, чтобы выдавать навигацию на экран для пользователя
module ApplicationHelper
  include Pagy::Frontend
end

# 5. В экшенах контроллера questions_controller.rb применим синтаксис pagy
def index
  @pagy, @questions = pagy Question.order(created_at: :desc)
  # pagy - метод создает массив из 2х элементов, поэтому помещаем их в 2 переменные: @pagy(зарезервировано ??) и @questions
  # @pagy - содержит специальный объект с помощью которого будет отрисовываться навигация (кнопки переключения страниц)
  # @questions - вопросы уже разбитые по страницам
  # адрес при переключении страниц будет /questions?page=1
end
def show
  @answer = @question.answers.build
  @pagy, @answers = pagy @question.answers.order(created_at: :desc)
end
# контроллер answers_controller.rb
def create
  @answer = @question.answers.build answer_params

  if @answer.save
    flash[:success] = "Answer created!"
    redirect_to question_path(@question)
  else
    @pagy, @answers = pagy @question.answers.order(created_at: :desc)
    render 'questions/show'
  end
end

# 6. Добавим в questions/index.html.erb специальный хэлпер pagy  - pagy_bootstrap_nav для того чтобы переключаться по страницам и сразу со стилями Бутстрап.
pagy_bootstrap_nav @pagy # Этот метод для бутстрап, есть и другие со всякими параметрами
# Но по умолчанию разметка будет выдаваться в виде плэйн текста(теги будут отображаться а не обрабатываться), поэтому мы можем применить:
(pagy_bootstrap_nav @pagy).html_safe     # вар 1
raw (pagy_bootstrap_nav @pagy).html_safe # вар 2: функция raw
== pagy_bootstrap_nav @pagy              # вар 3: второе равно в кавычках вставки(алиас для raw) его и используем

# 7. Тк в pagy нет по умолчанию скрытия меню пагинации если всего одна страница, то сделаем это кастомно на примере questions/index.html.erb так же вынесем это в кастомный хэлпер pagination для удобства
module ApplicationHelper
  include Pagy::Frontend

  def pagination(obj)
    # obj - параметр принимающий @pagy
    raw(pagy_bootstrap_nav(obj)) if obj.pages > 1
    # raw - придется использовать его(потому что == это синтаксис только для вставки)
  end
end














#
