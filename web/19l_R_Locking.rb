puts '                                            Locking(AR)'

# Locking - это временная защита записи в таблице БД от одновременного множественного доступа/изменения разными пользователями. Например 2 пользователя могут попытаться отредактировать одну и ту же запись с разницей в несколько секунд, чтобы защититься от этого и сохранить в БД только одно изменение и нужен locking

# https://api.rubyonrails.org/classes/ActiveRecord/Locking.html

# locking бывает 2х типов: optimistic и pessimistic


puts
puts '                                          Optimistic locking'

# https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html

# Optimistic locking - не запрещает множесвенный доступ на редактирование к одной и той же записи, но сохрангяет в БД изменения только первого по времени пользователя, а следующим выдает ошибку ActiveRecord::StaleObjectError. Например в своей игре 2 пользователя нажимают кнопку, но функционал для ответа на вопрос получает только тот кто 1й нажал.


# На примере:
# > rails new Locking -T --css bootstrap


# 1. Создадим модель с дополнительным полем lock_version:integer чтобы реализовать Optimistic locking (Работает с любой СУБД)
# > rails g model Item title lock_version:integer
# Так для модели Item будет по умолчанию реализован Optimistic locking
# > rails db:migrate
# Так же можно для примера работы создать экземпляр Item в seeds.rb:
item = Item.create title: 'Version 1'
puts item.inspect # чтобы при засеивании показало объект в консоли
# > rails db:seed
# Объект будет таким: #<Item id: 1, title: "Version 1", lock_version: 0, created_at: "2024-03- ... >

# 2. Создадим контроллер items_controller.rb
# > rails g controller items show edit update
class ItemsController < ApplicationController
  before_action :set_item!, except: [:index]

  def index
    @items = Item.all
  end

  def show; end

  def edit; end

  def update
    if @item.update item_params
      redirect_to item_path(@item)
    else
      render :edit
    end
  end

  private

  def set_item!
    @item = Item.find params[:id]
  end

  def item_params
    params.require(:item).permit(:title, :lock_version)
  end
end

# 3. Маршруты
Rails.application.routes.draw do
  resources :items, only: [:index, :show, :edit, :update]
  root "items#index"
end

# 4. Создадим представления
# items/_form.html.erb - форма с добавлением скрытого поля со значением lock_version
# items/index.html.erb, items/show.html.erb, items/edit.html.erb

# Изначально значение поля lock_version будет равно 0 при обновлении станет 1, при след  обновлении 2 итд, тоесть у пользователя который 1м обновляет, запись обновляется и значение поля увеличивается на 1, а у другого пользователя который примерно одновременно зашел на страницу и соотв не перезагружал ее после обновления записи, значение все еще останется на 1 меньше актуального и соответсвенно обновить не получится и выдаст ошибку ActiveRecord::StaleObjectError, тк объект уже устарел

# 5. Обработаем эту ошибку в экшене update, можно например просто редиректить с флэш-предупреждением
def update
  if @item.update item_params
    redirect_to item_path(@item)
  else
    render :edit
  end
rescue ActiveRecord::StaleObjectError
  redirect_to item_path(@item)
end

# Так же у пользователя не получится обновить запись, если он в консоли разработчика поменяет значение версии в скрытом поле, кроме случаев если он введео актуальное значение версии, тоесть угадает сколько раз ее сейчас изменили другие


puts
puts '                                          Pessimistic locking'

# https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html



















#
