puts '                                            Kaminari'

# https://github.com/kaminari/kaminari

# kaminari - гем для пагинации. Работает с БД через LIMIT и OFFSET

# Gemfile
gem 'kaminari', '~> 1.2'
# > bundle i


# По умолчанию в kaminari есть базовая конфигурация, которая задает все параметры пагинации, но их можно либо изменить применяя методы к коллекции сущностей, либо сгенерировать конфигурацию и отредактировать ее:
# > rails g kaminari:config  -  сгенерирует фаил конфигурации config/initializers/kaminari_config.rb, где можно редактировать параметры пагинации


# Разобьем по страницам на примере AskIt questions/index.html.erb и соотв контроллера questions_controller.rb
def index
  @questions = Question.order(created_at: :desc).page(params[:page]).per(2)
  # page - метод kaminari который будет разбивать вопросы по отдельным страницам(по умолчаниюпо 25 штук)
  # params[:page] - папаметр :page определяет какую страницу хочет запросить пользователь
  # При переключении страниц адрес меняется так /questions?page=2
  # per(2) - необязательный метод изменяющий колличество вопросов на страниице(по умолчанию 25)
  # Если всего вопросов будет меньше или равно числу на одной странице то ссылки пагинации не будут отображаться
end
# Добавим в questions/index.html.erb специальный хэлпер kaminari - paginate для того чтобы переключаться по страницам
paginate @questions # Этот метод базовый, есть и другие со всякими параметрами


# По умолчанию стили ссылок/кнопок переключения страниц довольно убогие, у kaminari есть специальные опции для бутстрапа(но вроде только 4й версии ??) поэтому можно добавить стили вручную, сгенерировав паршалы всех элементов пагинации и применив к ним стили бутстрапа из раздела pagination

# > rails g kaminari:views default  - генерируем паршалы kaminari(можно указать разные параметры вместо default)
# В первую очередь нас интересует главный паршал kaminary\_paginator.html.erb, стилезем его и другие паршалы при помощи бутстрапа

# kaminary по умолчанию использует i18n (в скрытом фаиле похоже)


puts
puts '                                              Pagy'

# https://ddnexus.github.io/pagy/
# https://github.com/ddnexus/pagy
# https://ddnexus.github.io/pagy/docs/migration-guide/   -  перейти с Каминари или других гемов

# pagy - гем для пагинации, альтернатива для kaminari, он чуть сложнее но работает быстрее особенно для большого коллич данных. Так же его возможности по кастомизации больше. Так же он может работать с самыми разными данными, а не только с Актив Рекорд. Поодержка бутстрап 5 есть при помощи хэлпера.



# Мигрируем на Pagy с Kaminari, но похоже и по дефолту так можно

# 1. Создаем конфигурационный фаил config/initializers/pagy.rb
# https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb   -  отсюда копируем весь код в config/initializers/pagy.rb
# Далее добавим в config/initializers/pagy.rb строку:
require 'pagy/extras/bootstrap' # Это специальные методы которые будут выводить пагинацию со стилями бутстрэп

# 2. Gemfile - удалим каминари и добавим вместо него пэйджи
gem 'pagy', '~> 6.2'

# 3. В application_controller.rb подключим методы для бэкэнда
class ApplicationController < ActionController::Base
  include Pagy::Backend
end

# 4. В application_helper.rb подключим методы для фронтэнда, чтобы выдавать навигацию на экран для пользователя
module ApplicationHelper
  include Pagy::Frontend
end

# 5. Заменим в экшенах контроллера questions_controller.rb метод page(каминари) на синтаксис pagy
def index
  @pagy, @questions = pagy Question.order(created_at: :desc)
  # pagy - метод создает массив из 2х элементов, поэтому помещаем их в переменные @pagy(зарезервировано ??) и @questions(наше название). Эти элементы это:
  # @pagy - специальный объект с помощью которого будет отрисовываться навигация
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
# Добавим в questions/index.html.erb специальный хэлпер pagy  - pagy_bootstrap_nav для того чтобы переключаться по страницам и сразу со стилями бутстрап.
pagy_bootstrap_nav @pagy # Этот метод для бутстрап, есть и другие со всякими параметрами
# Но по умолчанию разметка будет выдаваться в виде плэйн текста(теги будуь отображаться а не выводиться), поэтому мы можем применить:
(pagy_bootstrap_nav @pagy).html_safe # вар 1
raw (pagy_bootstrap_nav @pagy).html_safe # вар 2: функция raw
== pagy_bootstrap_nav @pagy  # вар 3: второе равно в кавычках вставки(алиас для raw) его и используем

# 6. Обновим библиотеки
# > bundle u

# 7. Удалим папку каминари с паршалами и фаил каминари из конфига














#
