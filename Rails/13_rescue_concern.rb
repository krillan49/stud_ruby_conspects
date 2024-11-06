puts '                            rescue_from(обработка ошибок в контроллере)'

# Исправим ошимбку ActiveRecord::RecordNotFound если пользователь введет адрес несуществующего вопроса, например /questions/266666

# Добавим код для обработки ошибки в главный контроллер application_controller.rb
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :notfound
  # rescue_from  -  метод спасает ошибку и исполняет метод ее обработки
  # ActiveRecord::RecordNotFound  -  параметр, имя ошибки которую хотим обработать
  # with: :notfound  - параметр-хеш, метод который обрабатывает ошибку

  private

  def notfound(exception)  # создадим метод который обрабатывает ошибку
    # exception - параметр принимает саму ошибку
    logger.warn exception # (не обязательно) запишем ошибку в журнал событий

    render file: 'public/404.html', status: :not_found, layout: false # рэндерим/возвращаем HTML-фаил с сообщением для ошибки
    # file:  -  ключ означает что рендерим фаил
    # 'public/404.html'   -  рендерим фаил 404.html из директории public. Фаилы из директории public не проходят через Рэилс приложения, те вставок на Руби иметь не могут, это просто обычные статические HTML-фаилы, которые сгенерированы приложением, при желании можно его модифицировать вручную.
    # layout: false   -  опция выводит HTML-фаилы без интеграции его в layout
  end
end
# Теперь при возникновении ошибки ActiveRecord::RecordNotFound в любых контроллерах, пользователю будет возвращаться 404.html



puts '                                           concern'

# concerns - отдельные фаилы с модулями(имеющими дополнительные способности) содержащими методы, например обработчики ошибок, для контроллеров они создаются в controllers/conxerns/ если содержат методы, применяемые в контроллерах (чтоб не захламлять контроллеры)

# Создадим отдельный фаил controllers/concerns/error_handling.rb, который содержит модуль с необходимыми методами и обработаем ошибку из примера выше в нем (код там)

# А в материнский контроллер его просто подключим
class ApplicationController < ActionController::Base
  include ErrorHandling # подключаем наш модуль
end



# (OneToMany) вынесем повторяющийся код из экшенов контроллеров вопросов и ответов в отдельный метод нового консерна questions_answers.rb, тк далее он будет еще и в 3м контроллере
# answers_controller.rb
def create
  @answer = @question.answers.build answer_create_params # разница тут
  if @answer.save
    flash[:success] = t '.success'
    redirect_to question_path(@question)
  else
    # далее наш повторяющийся код для выноса в метод консерна:
    @question = @question.decorate
    @pagy, @answers = pagy @question.answers.order(created_at: :desc)
    @answers = @answers.decorate
    render 'questions/show' # разница тут
  end
end
# questions_controller.rb почти тот же повторяющийся код
def show
  @question = @question.decorate
  @answer = @question.answers.build # разница тут (создаем для генерации URL в форме questions#show)
  @pagy, @answers = pagy @question.answers.order(created_at: :desc)
  @answers = @answers.decorate
end
# Заменим на
class AnswersController < ApplicationController
  include QuestionsAnswers # подключаем консерн
  # ...

  def create
    @answer = @question.answers.build answer_create_params
    if @answer.save
      flash[:success] = t '.success'
      redirect_to question_path(@question)
    else
      load_question_answers(do_render: true) # вызываем метод консерна с параметром true для render 'questions/show'
    end
  end
end
class QuestionsController < ApplicationController
  include QuestionsAnswers # подключаем консерн
  # ...

  def show
    load_question_answers # вызываем метод консерна
  end

  # ...
end















#
