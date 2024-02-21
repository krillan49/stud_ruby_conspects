puts '                                              Hotwire'

# https://hotwired.dev/

# Hotwire - фрэймворк, состоящий из комбинации фрэймворков Turbo и Stimulus(для фронтэнд)


puts
puts '                                               Turbo'

# https://turbo.hotwired.dev/

# Turbo - фрэймворк, являеющийся частью фрэймворка Hotwire. Появился как продолжение идеи turbolinks, но намного более мощный и он позволяет ускорять работу приложения, тк позволяет разбивать веб-страницы на отдельные независимые контексты и обновлять/перерисовывать необходимые части веб страниц, не перерисовывая всю страницу.


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

# Тк для работы turbo нужен redis. Соотв предварительно нужно установить в систему redis на никс или Memurai на виндоус
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
  # status: :see_other - меняем код состояния, так же можно например status: 303
end


# 5. При непройденной валидации создания/редактирования сущьности, например вопроса, сообщение об ошибке не отображается, например при создании в консоле отобразится:
# Started POST "/en/questions" for ::1 at 2024-02-21 18:36:10 +0300
# Processing by QuestionsController#create as TURBO_STREAM
# Тоесть теперь тут TURBO_STREAM вместо HTML, это то что и должно быть, но придется модифицировать рендер страницы использующий метод render в контроллерах в экшенах create и update, чтобы ошибки нормально обрабатывались и отображались
def update
  if @user.update user_params
    flash[:success] = t '.success'
    redirect_to new_session_path
  else
    render :edit, status: :unprocessable_entity
    # status: :unprocessable_entity - добавляем код состояния, который поможет правильно рендерить ошибки валидации
  end
end





















#
