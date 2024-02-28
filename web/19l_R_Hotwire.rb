puts '                                              Hotwire'

# https://hotwired.dev/

# Hotwire - фрэймворк, состоящий из комбинации фрэймворков Turbo и Stimulus(для фронтэнд)


puts
puts '                                               Turbo'

# https://turbo.hotwired.dev/

# Turbo - фрэймворк, который позволяет разбивать веб-страницы на отдельные независимые контексты и обновлять/перерисовывать необходимые части веб страниц, не перерисовывая всю страницу. Тоесть добавляет ассинхронную функциональность страницам, что ускорять работу приложения.
# Является частью фрэймворка Hotwire.
# Появился как продолжение идеи turbolinks, но намного более мощный.


puts
puts '                                Миграция на Turbo в существующем проекте'

# https://github.com/hotwired/turbo-rails    - доки гема turbo-rails


# 1. Установки:

# Gemfile:
gem 'turbo-rails', '~> 2.0'
# > bundle i

# Установим turbo в проект
# > rails turbo:install
# добавилось в packege.json:
"@hotwired/turbo-rails": "^8.0.2"
# добавилось в app/javascript/application.js:
import "@hotwired/turbo-rails"

# Для работы turbo нужен redis. Соотв предварительно нужно установить в систему redis на никс или Memurai на виндоус
# > rails turbo:install:redis
# config/cable.yml - появился данный фаил (Switch development cable to use redis)
gem "redis", "~> 4.0" # В Gemfile раскоментировался этот гем


# 2. Изменим настройки для js вручную:

# В app/javascript/application.js - уберем все что связано с turbolinks и ujs (код там)

# В packege.json в блоке "dependencies" тоже уберем все что связано с turbolinks и ujs
"dependencies": {
  "@hotwired/turbo-rails": "^8.0.2",
  "@popperjs/core": "^2.11.8",
  # "@rails/ujs": "^6.0.0",             # удаляем ujs
  "autoprefixer": "^10.4.16",
  "bootstrap": "^5.3.2",
  "bootstrap-icons": "^1.11.1",
  "esbuild": "^0.20.0",
  "nodemon": "^3.0.1",
  "postcss": "^8.4.31",
  "postcss-cli": "^10.1.0",
  "sass": "^1.69.3",
  "tom-select": "^2.3.1",
  # "turbolinks": "^5.2.0"              # удаляем турболинкс
}
# > yarn install


# 3. Изменим скрипты использовавшие turbolinks (у нас это только ТомСелект) на использование turbo
# Так же исправим ошибку рендера при непройденной валидации при создании/редактировании вопроса - не перерендеривает дропдаун томселекта
# app/javascript/scripts/select.js (код там)


# 4. В видах приложения изменим link_to delete-ссылки, тк они связаны с js и turbo
" link_to t('global.button.delete'), question_path(question), class: 'btn btn-danger',
data: {method: :delete, confirm: t('global.dialog.you_sure')} "
# Такая ссылка уже не сработает, тк она шлет метод GET а в turbo нужно чтобы слало метод DELETE, потому вместо удаления просто откроется данный вопрос
# Поменяем все data опции в link_to delete-ссылках, добавив им прфикс turbo_
" link_to t('global.button.delete'), question_path(question), class: 'btn btn-danger',
data: {turbo_method: :delete, turbo_confirm: t('global.dialog.you_sure') "
# Альтернативный вариант использовать хэлпер button_to вместо link_to

# (?? У меня не было, возможно устарело ??) Если при удалении хэлпером link_to в консоли прописывается ошибка =>
# DELETE FROM "questions" WHERE "questions"."id" = ?  [["id", 20]]    # эта строка красная потому легко найти
# Completed 302 Found in 781ms (ActiveRecord: 77.7ms | Allocations: 6344)
#       Если далее написано:
# Started DELETE "/en/questions" for ....
# ActionController::RoutingError ....
#
# Started GET "/en/questions" for ::1 at 2024-02-21 18:07:50 +0300
# Processing by QuestionsController#index as TURBO_STREAM
# Это значит что при редиректе шлет глагол того запроса который был до этого, тоесть DELETE, потом возникает ошибка и только потом редиректит нормально на GET, иногда это может привести к серьезным проблемам, поэтому лучше это исправить
# Для решения можно либо использовать хэлпер button_to вместо link_to, либо в контроллерах в экшенах destroy дописать опцмю к редиректу, которая изменит код состояния(302) редиректа на другой:
def destroy
  @answer.destroy
  flash[:success] = t '.success'
  redirect_to question_path(@question), status: :see_other
  # status: :see_other - меняем код состояния, так же можно например написать - status: 303
end


# 5. При непройденной валидации создания/редактирования сущьности, например вопроса, сообщение об ошибке не отображается, например при создании в консоли отобразится:
# Started POST "/en/questions" for ::1 at 2024-02-21 18:36:10 +0300
# Processing by QuestionsController#create as TURBO_STREAM
# Тоесть теперь тут TURBO_STREAM вместо HTML, потому придется модифицировать рендер страницы использующий метод render в контроллерах в экшенах create и update, чтобы ошибки нормально обрабатывались и отображались
def update
  if @user.update user_params
    flash[:success] = t '.success'
    redirect_to new_session_path
  else
    render :edit, status: :unprocessable_entity
    # status: :unprocessable_entity - добавляем код состояния, который поможет правильно рендерить ошибки валидации
  end
end


puts
puts '                                              Turbo Frames'

# Турбо фрэймы позволяют разделить веб-страницу на несколько логических блоков/областей и по необходимости их обновлять каждый отдельно, не перезагружая всю страницу, тоесть обновлять страницу частично


# 1. Динамическое отображение формы при создании вопросов:
# Например на questions(turbo)/index.html.erb есть кнопка/ссылка нового вопроса, которая осуществляет переход на страницу с формой, но при помощи turbo frames без всякого дополнительного JS-скрипта можно отобразить эту форму на этой же странице, чтобы она отрисовывалась по нажатию кнопки.
# а. questions(turbo)/index.html.erb - изменим кнопку вызова формы, чтобы она помещала форму на страницу
# b. questions(turbo)/_form.html.erb - изменим парщал формы, обернув форму в тубофрэйм-тег с тем же айди
# Теперь без перезагрузки страницы index.html.erb мы подгружаем в нее форму из _form.html.erb


# 2. Сделаем так чтоб при создании нового вопроса вместо редиректа на index.html.erb, происходила подгрузка разметки этого вопроса к списку всех вопросов без перезагрузки всей страницы
# а. questions_controller.rb - изменим экшен create добавив в него формат для турбо стрима
def create
  @question = current_user.questions.build question_params
  if @question.save
    respond_to do |format|
      # Оставим обычный html формат, вдруг турбо-стрим не сработает, например у пользователя отключены скрипты
      format.html do
        flash[:success] = t('.success')
        redirect_to questions_path
      end
      # Добавим формат turbo_stream, это тот формат в котором принимаем форму, что была обернута в турбострим-тег
      format.turbo_stream do
        @question = @question.decorate # декорируем сразу, тк только что созданный вопрос сразу добавится на страницу
        flash.now[:success] = t('.success') # flash.now - чтобы при перезагрузке страницы флэш-сообщение не отобразилось еще раз
      end
    end
  else
    render :new#, status: :unprocessable_entity   - теперь тут менять статус необязательно, тк мы используем турбофрэйм
  end
end
# b. questions(turbo)/create.turbo_stream.erb  - создадим это специальное представление, которое будет рендериться по умолчанию в ответ на формат turbo_stream, код из которого будет дорисовывать на текущую страницу нужные элементы
# c. questions(turbo)/index.html.erb - создадим элемент/турбофрэйм-тег в который будет помещен вопрос из create.turbo_stream.erb
# Теперь при создании вопроса, он сразу появляется в списке вопросов без перезагрузки страницы


# 3. При создании вопроса при помощи турбо стрима не отображается флэш-сообщение, сделаем возмоность отображения флэша тоже динамически
# a. layouts/application(turbo).html.erb - вынесем блок с отображением флэш-сообщений в отдельный паршал shared/_flash.html.erb, обернем рендер паршала в блок с айдишником 'flash' в который будет добавлено флэш сообщение
# b. helpers/application_helper.rb - напишем хэлпер(можно было бы просто написать код на странице), который будет динамически добавлять флэш в application(turbo).html.erb в тег с айдишником "flash"
def prepend_flash
  turbo_stream.prepend 'flash', partial: 'shared/flash' # тоесть вернем это в application(turbo).html.erb
  # prepend - метод для turbo_stream, который при помощи JS возьмет HTML(отрендереный паршал shared/_flash.html.erb) и поместит его в элемент(тут обычный div) с указанным id='flash'
  # Помимо метода prepend, есть еще методы replace или апдейт, которые можно использовать если не хотим иметь много флэш сообщений на странице(тк в случае с prepend, если например мы подряд динамически делаем несколько действий, то все флэш сообщения будут отображаться одно над другим), чтобы можно было скрывать флэш нажатием крестика, по времени итд
end
# c. questions(turbo)/create.turbo_stream.erb - добавим вызов хэлпера, тоесть используем его


# ?? Почему для формы вопроса используем turbo-frame тег в лэйауте обычный div - тк тут хотим чтобы тег появлялся только при турбо стриме, а там в любом случае ??
# ?? Потому не оборачивем в турбофрэйм тут паршал, а для вопроса оборачиваем, тк тут отображаем все содержимое, а там паршал рендерится в new.html.erb разметка из которого нам не нужна ??


# 4. Динамическое редактирование вопросов, тоесть чтобы при нажатии кнопки "Edit" появлялась форма редактирования в точке вопроса, вместо него(саму форму никак менять не нужно, тк там мы уже добавили турбофрэйм в пункте 1) и потом вопрос на странице динамически обновился
# a. questions(turbo)/_question.html.erb - обернем каждый вопрос в турбофрэйм, айди для которого будет браться от айди вопроса
# b. questions_controller.rb - изменим экшен update добавив в него формат для турбо стрима
def update
  if @question.update question_params
    respond_to do |format|
      format.html do
        flash[:success] = t('.success')
        redirect_to questions_path
      end
      format.turbo_stream do
        @question = @question.decorate
        flash.now[:success] = t('.success')
      end
    end
  else
    render :edit, status: :unprocessable_entity
  end
end
# c. questions(turbo)/update.turbo_stream.erb  - создадим специальное представление, которое будет рендериться в ответ на формат turbo_stream экшена update. Но в отличие от создания используем там метод replace а не prepend, чтобы заменить существующий вопрос с по соответсвующему айди


# 5. Динамическое удаление вопросов, при нажатии кнопки "Delete" вопрос на странице динамически удалялся без перезагрузки страницы. Кнопку удаления изменять не нужно, такая как есть подходит.
# a. questions_controller.rb - изменим экшен destroy добавив в него формат для турбо стрима
def destroy
  @question.destroy
  respond_to do |format|
    format.html do
      flash[:success] = t('.success')
      redirect_to questions_path, status: :see_other
    end
    format.turbo_stream { flash.now[:success] = t('.success') }
  end
end
# b. questions(turbo)/destroy.turbo_stream.erb  - создадим специальное представление, которое будет рендериться в ответ на формат turbo_stream экшена destroy. Используем там метод remove, чтобы убрать со страницы существующий вопрос с по соответсвующему айди


# 6. На странице всех вопросов, через паршал _question.html.erb рендарятся теги для конкретного вопроса в паршале _tag.html.erb, в ссылке которая активирует доп функционал поиска других вопросов с тем же тегом, при нажатии на который должна перезагружаться вся страница с соответсвующими вопросами. Но при нажатии на ссылку ничего не происходит, тк она находится в турбо-фрэйме, а наш функционал должен обновлять не отдельный фрэйм а всю страницу.
# a. tags/_tag.html.erb - изменим код, чтобы ссылка отправляла запрос на обновление всей страницы, а не туробо-фрэйма, в котором находится


# 7. Можно поместить в дополнительный фрэйм и все вопросы с пагинацией, чтобы при переключении страницы пагинатором, обновлялся только блок вопросов, а не контент выше (заголовок итд).
# a. questions(turbo)/index.html.erb - обернем вывод всех вопросов и пагинацию в еще один фрэйм(фрэйм во фрэйме норм работает)
# b. questions_controller.rb - добавим опцию для создания айдишника на кнопках пагинатора
def index
  @tags = Tag.where(id: params[:tag_ids]) if params[:tag_ids]
  @pagy, @questions = pagy Question.all_by_tags(@tags), link_extra: 'data-turbo-frame="pagination_pagy"'
  # link_extra - опция pagy, которая добавляет аттрибут (тут кнопкам пагинатора)
  # data-turbo-frame="pagination_pagy" - собственно атрибут, указывающий на айди турбофрэйм-тега
  @questions = @questions.decorate
end


# 8. Исправим ссылку на вопрос на странице всех вопросов. На странице вопроса, добавим тот же рендер вопроса, что и на странице всех вопросов, вместо отдельного кода, тк так заодно будет работать турбофрэйм вызывающий форму редактирования.
# a. questions(turbo)/_question.html.erb - исправим чтобы ссылка работала и переходила на другую страницу show.html.erb вместо попытки обновления фрэйма
# b. questions(turbo)/show.html.erb - уберем отдельную разметку для вопроса и добавим вместо нее рендер _question.html.erb, тк так добавится и турбофрэйм тег, соотв контроллеры при нажатии кнопок редактирования и удаления будут отвечать на формат турбофрэйма, соотв на эту же страницу show.html.erb будет подгружаться форма
# Правда будет минус при удалении, тк вопрос исчезнет динамически, а мы все еще останемся на его странице, для устранения проблемы можно например использовать другой паршал без кнопки удаления, либо чтобы делался редирект после удаления


# 9. Добавим динамическое добавление, редактирование и удаление ответов на странице questions(turbo)/show.html.erb:
# a. questions(turbo)/show.html.erb - обернем весь контент ответов в турбофрэйм тег с айди 'answers', тк будем сюда дописывать новые ответы которые будут создаваться динамически
# b. answers(turbo)/_form.html.erb - обернем пашал формы ответов в ткрбофрэйм тег с айди ответа
# c. answers(turbo)/_answer.html.erb - обернем паршал ответа в турбофрэйм-ткг с айди от конкретного овета, заодно удалим лишние опции с dom_id
# d. answers_controller.rb - добавим обработку формата турбострима в экшены create, update и destroy
class AnswersController < ApplicationController
  # ...

  def create
    @answer = @question.answers.build answer_create_params
    if @answer.save
      respond_to do |format|
        format.html do
          flash[:success] = t '.success'
          redirect_to question_path(@question)
        end
        format.turbo_stream do
          @answer = @answer.decorate
          flash.now[:success] = t '.success'
        end
      end
    else
      load_question_answers(do_render: true)
    end
  end

  def update
    if @answer.update answer_update_params
      respond_to do |format|
        format.html do
          flash[:success] = t '.success'
          redirect_to question_path(@question, anchor: dom_id(@answer))
        end
        format.turbo_stream do
          @answer = @answer.decorate
          flash.now[:success] = t '.success'
        end
      end
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    respond_to do |format|
      format.html do
        flash[:success] = t '.success'
        redirect_to question_path(@question), status: :see_other
      end
      format.turbo_stream { flash.now[:success] = t('.success') }
    end
  end

  # ...
end
# e. Создадим специальные представления возвращаемые обработчиком формата turbo_stream:
# answers(turbo)/create.turbo_stream.erb - динамически добваляет ответ в турбофрэйм с айди "answers" на show.html.erb
# answers(turbo)/update.turbo_stream.erb - динамически заменяет ответ на новый
# answers(turbo)/destroy.turbo_stream.erb - удалим ответ по его айди, как у одного из турбофреймов в который обернут _answer.html.erb















#
