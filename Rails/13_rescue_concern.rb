puts '                            rescue_from(обработка ошибок в контроллере)'

# rescue_from - метод, который перехватывает, спасает и передает обработку исключения в заданный метод контроллера

# application_controller.rb  - код исправления ошибок корректнее добавлять в главный контроллер ??
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :notfound
  # rescue_from                   -  метод спасает ошибку и исполняет метод ее обработки
  # ActiveRecord::RecordNotFound  -  параметр, имя ошибки которую хотим обработать, тут если пользователь введет адрес несуществующего вопроса, например /questions/266666
  # with: :notfound               - параметр-хеш, с именем метода, который обрабатывает, спаченную ошибку

  private

  def notfound(exception)  # создадим метод который обрабатывает ошибку
    # exception - параметр принимает саму ошибку

    logger.warn exception # (не обязательно) запишем ошибку в журнал событий

    render file: 'public/404.html', status: :not_found, layout: false # рэндерим/возвращаем HTML-фаил с сообщением для ошибки
    # file:               -  ключ означает что рендерим фаил
    # 'public/404.html'   -  рендерим фаил 404.html из директории public. Фаилы из директории public не проходят через Рэилс приложения, те вставок на Руби иметь не могут, это просто обычные статические HTML-фаилы, которые сгенерированы приложением, при желании можно его модифицировать вручную.
    # layout: false       -  опция выводит HTML-фаилы без интеграции его в layout
  end
end
# Теперь при возникновении ошибки ActiveRecord::RecordNotFound в любых контроллерах, пользователю будет возвращаться 404.html



puts '                                              concern'

# concern - отдельныq фаил с модулем(имеющим дополнительные способности), содержит методы, которые мы хотим использовать в класасах контроллеров, моделей итд, чтобы не захламлять ими сами эти классы. В самих модулях-консернах нужно подключить дополнительный функционал при помощи extend ActiveSupport::Concern
# controllers/conсerns/ - директория где создаются concern-ы для контроллеров, которые содержат методы, применяемые в контроллерах
# models/conсerns/      - директория где создаются concern-ы для моделей, которые содержат методы, применяемые в моделях


# controllers/concerns/error_handling.rb - создадим это отдельный фаил, который содержит модуль с необходимыми методами и (код там) обработаем ошибку при помощи rescue_from. А в материнский контроллер его подключим этот консерн
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
# questions_controller.rb
def show
  # почти тот же повторяющийся код
  @question = @question.decorate
  @answer = @question.answers.build # разница тут (создаем для генерации URL в форме questions#show)
  @pagy, @answers = pagy @question.answers.order(created_at: :desc)
  @answers = @answers.decorate
end
# Вынесем повторяющийся код в консерн questions_answers.rb и подключим его для отдельных контроллеров:
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
    load_question_answers # вызываем метод консерна, не передавая параметр, тоесть будет nil ?
  end
end















#
