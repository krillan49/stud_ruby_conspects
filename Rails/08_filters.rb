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













#
