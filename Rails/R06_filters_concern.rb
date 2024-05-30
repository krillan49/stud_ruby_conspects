puts '                                           before_action'

# before_action  -  метод который исполняет переданный в параметры метод контроллера, перед тем как запускается каждый экшен контроллера, так же указанный в параметрах (по умолчанию это все экшены)
# действие/метод запускаемый при помощи before_action, так же называется фильтр.
# (До Rails 5 у before_action был алиас before_filter, как и многие другие action-свойства включавшие в имени filter)

# В экшенах контроллера Questions, есть повторяющийся код @question = Question.find params[:id] пропишем его в отдельном методе и будем запускать при помощи before_action
class QuestionsController < ApplicationController
  before_action :set_question!, only: %i[destroy update]
  # set_question!  - имя метода(фильтра) который будет запускаться перед экшеном
  # only: %i[destroy update]   -  экшены перед которыми будет запускаться метод set_question! Если не указывать данный параметр, то будет выполнять метод перед всеми/каждым экшеном
  before_action :some1, except: %i[destroy update] # можно использовать несколько фильтров
  # except: %i[destroy update]  -  параметр означающий 'кроме', те кроме указынных экшенов(обратный смысл к only)
  before_action :some2, only: :update # only: :update - можно указать и без массива, если только 1 экшен

  # Если мы используем несколько фильтров то их порядок важен в том случае если данные из методов одних фильтров взаимодействуют с другими.

  # Получаем что все записи внутри методов ниже равноценны, перед каждом исполняется метод set_question! с кодом @question = Question.find params[:id] определяющим переменную экземпляра, которая теперь доступна в экшене
  def show
    @question = Question.find params[:id]  # тоже самое будет сделано ниже
  end
  def edit
    set_question! # before_action :set_question! работает так же, тоесть это оналог простого помещения оператора метода в его тело
    # ... какойто код ...
  end
  def update
    # @question = Question.find params[:id]  -  вызваается при помощи before_action :set_question!
  end
  def destroy
    # @question = Question.find params[:id]  -  вызваается при помощи before_action :set_question!
  end

  private

  def set_question! # метод который будет запускаться при помощи before_action, называем с восклиц знаком в конце, тк он может вернуть ошибку если не существует такой вопрос
    @question = Question.find params[:id] # Соотв когда метод сработает то переменная @question будет объявлена, получит значение и будет доступна в экшенах
    # find для этой цели лучше чем find_by, тк если пользователь введет адрес несуществующего вопроса, например /questions/266666, то сразу возникнет ошибка ActiveRecord::RecordNotFound в контроллере(в этом методе), а не потом ошибка в виде, соотв проще будет эту ошибку обработать
  end
end


puts
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


puts
puts '                                           concern'

# concerns - отдельные фаилы с модулями(имеющими дополнительные способности) содержащими методы, например обработчики ошибок, для контроллеров они создаются в controllers/conxerns/ если содержат методы, применяемые в контроллерах (чтоб не захламлять контроллеры ??)

# Создадим отдельный фаил controllers/concerns/error_handling.rb, который содержит модуль с необходимыми методами и обработаем ошибку из примера выше в нем (код там)

# А в материнский контроллер его просто подключим
class ApplicationController < ActionController::Base
  include ErrorHandling # подключаем наш модуль
end












#
