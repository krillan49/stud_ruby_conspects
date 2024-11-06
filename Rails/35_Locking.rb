puts '                                            Locking(AR)'

# https://api.rubyonrails.org/classes/ActiveRecord/Locking.html

# ActiveRecord::Locking

# Locking - это временная защита записи в таблице БД от одновременного множественного доступа/изменения разными пользователями. Например 2 пользователя могут попытаться отредактировать одну и ту же запись с разницей в несколько секунд (соответсвенно 2й не в курсе редации от 1го), чтобы защититься от этого и сохранить в БД только одно изменение и нужен locking

# locking бывает 2х типов: optimistic и pessimistic



puts '                                          Optimistic locking'

# https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html

# ActiveRecord::Locking::Optimistic

# Optimistic locking - не запрещает множесвенный доступ на редактирование к одной и той же записи, но сохрангяет в БД изменения только первого по времени пользователя, а следующим выдает ошибку ActiveRecord::StaleObjectError.

# Пример: в Cвоей игре два пользователя нажимают кнопку, но функционал для ответа на вопрос получает только тот кто 1й нажал.


# На примере приложения https://github.com/krillan49/Locking_Kruk:
# > rails new Locking -T --css bootstrap


# 1. Создадим модель с дополнительным полем lock_version:integer чтобы реализовать Optimistic locking (Работает с любой СУБД). Так для модели Item будет по умолчанию реализован Optimistic locking
# > rails g model Item title lock_version:integer
# > rails db:migrate
# schema.rb:
create_table "items", force: :cascade do |t|
  t.string "title"
  t.integer "lock_version"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
end
# Так же можно, для примера работы, создать экземпляр Item в seeds.rb:
item = Item.create title: 'Version 1'
puts item.inspect # чтобы при засеивании показало объект в консоли
# > rails db:seed
# Объект будет таким: #<Item id: 1, title: "Version 1", lock_version: 0, created_at: "2024-03- ... >

# Изначально значение поля lock_version будет равно 0, а при обновлении станет 1, при следующем обновлении станет 2 итд. Тоесть при каждом обновлении записи значение в поле lock_version будет увеличиваться на 1. При этом если контроллер получает на обновление записть, значение lock_version которого не соответсвует актуальному, то запись обновлена не будет и вернет пользователю ошибку ActiveRecord::StaleObjectError. Тоесть у пользователя который 1м обновляет, запись обновляется и значение поля lock_version увеличивается на 1, а у другого пользователя, который почти одновременно зашел на страницу, но позже и соответсвенно не перезагружал ее после обновления записи, значение все еще останется старым, на 1 меньше нового актуального

# 2. Создадим представления
# items/index.html.erb, items/show.html.erb, items/edit.html.erb
# items/_form.html.erb - форма с добавлением скрытого поля со значением lock_version
# У пользователя не получится обновить запись, кроме случаев если он через консоль разработчика введет актуальное значение версии, тоесть угадает сколько раз ее сейчас изменили другие

# 3. Создадим контроллер items_controller.rb
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
  rescue ActiveRecord::StaleObjectError # Обработаем ошибку
    # Тут можно еще добавить и флэш-сообщение об ошибке
    redirect_to item_path(@item)
  end

  private

  def set_item!
    @item = Item.find params[:id]
  end

  def item_params
    params.require(:item).permit(:title, :lock_version)
  end
end

# 4. Маршруты
Rails.application.routes.draw do
  resources :items, only: [:index, :show, :edit, :update]
  root "items#index"
end



puts '                                          Pessimistic locking'

# https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html

# ActiveRecord::Locking::Pessimistic

# Pessimistic locking - обеспечивает поддержку блокировки на уровне строк с использованием SELECT… FOR UPDATE и других типов блокировки(которые мы можем выбрать) используемыми конкретными СУБД. Тоесть не нужны никакие дополнительные колонки в таблице. Так же есть возможность разрешить множественно обновлять запись поочередно, подождав некоторое время.
# Подходит например для того чтобы изменить какое-то значение, предполагающее изменение многими пользователями, например добавить сумму на счет или изменить что-то в статистике в зависимости от действий пользователя.

# Есть различия при работе с разными БД:
# dev.mysql.com/doc/refman/en/innodb-locking-reads.html                                # MySQL
# www.postgresql.org/docs/current/interactive/sql-select.html#SQL-FOR-UPDATE-SHARE     # PostgreSQL
# FOR UPDATE - запрет на обновление(!!! Похоже нет в SQLite 3)

# Можем навесить лок на какую-то запись в БД при помощи метода lock
Account.lock.find(1) # SELECT * FROM accounts WHERE id=1 FOR UPDATE


# Варианты применения:

# 1. Вызываем метод lock('SQL-код лока конкретной СУБД'), чтобы использовать собственное предложение блокировки, специфичное для разных СУБД, например «LOCK IN SHARE MODE» или «FOR UPDATE NOWAIT»:
Account.transaction do # Необходимо обернуть все в блок транзакции, в рамках транзакции мы можем навешивать локи на записи и только когда вся транзакция полностью отработает, то лок будет автоматически снят
  shugo = Account.lock("FOR UPDATE NOWAIT").find_by(name: "shugo")
  #=> SELECT * FROM accounts WHERE name = 'shugo' LIMIT 1 FOR UPDATE NOWAIT
  # тоесть мы закрываем эту запись(find_by(name: "shugo")) от изменения другими пользователями(FOR UPDATE) и эти пользователи не могут ждать своей очереди, пока лок будет снят и сразу получают ошибку(NOWAIT). По умолчанию, например в PostgreSQL, следующий пользователь ждет своей очереди и потом может обновлять.
  # лок использованный в транзакции(Account.transaction) будет висеть пока она не завершится и попытки изменить эту же запись в другой транзакции приведут к вызову ошибки
  yuko = Account.lock("FOR UPDATE NOWAIT").find_by(name: "yuko")
  shugo.balance -= 100 # изменяем значение некого поля
  shugo.save!
  yuko.balance += 100  # изменяем значение некого поля
  yuko.save!
end

# 2. Можно использовать ActiveRecord::Base#lock! метод для блокировки одной записи по идентификатору. Это может быть лучше, если не нужно блокировать каждую строку:
Account.transaction do
  # SELECT * FROM accounts WHERE ...
  accounts = Account.where(...)
  account1 = accounts.detect { |account| ... }
  account2 = accounts.detect { |account| ... }
  # SELECT * FROM accounts WHERE id=? FOR UPDATE
  account1.lock! # применяем лок к выбранной записи
  account2.lock!
  account1.balance -= 100
  account1.save!
  account2.balance += 100
  account2.save!
end

# 3. Можно начать транзакцию и получить блокировку сразу, вызвав with_lock блок, который по умолчанию навесит лок на заранее подготовленную запись:
account = Account.first
account.with_lock do # Блок вызывается из транзакции, объект(тут account) уже залочен
  account.balance -= 100
  account.save!
end


# На примере приложения https://github.com/krillan49/Locking_Kruk:

# 1. Модель и миграция такие же но без дополнительного поля
# > rails g model Item2 title
# > rails db:migrate
item2 = Item2.create title: 'Version 1' # в seeds.rb
# > rails db:seed

# 2. Представления все такиеже, только в паршале формы нет скрытого поля

# 3a. Временный локинг, на время обработки, следующие пользователи ждут своей очереди:
# Контроллер такойже но изменим экшен update:
class Item2sController < ApplicationController
  before_action :set_item!, except: [:index]

  # ...

  def update
    result = nil # переменная для условия прохождения валидации

    @item.with_lock do # устанавливает лок для редактируемого объекта при помощи with_lock
      @item.title = params[:item2][:title] # обновляем значение поля
      result = @item.save # сохраняем
      sleep 10 # ждем 10 секунд перед закрытием транзакции, во время которых другой пользователь будет ждать свою очередь
    end

    if result
      redirect_to item2_path(@item)
    else
      render :edit
    end
  end

  # ...

  def item_params
    params.require(:item2).permit(:title) # естественно никакого доп поля
  end
end
# PostgreSQL - первый пользователь совершит обновление, пройдут 10 секунд и тогда завершится его транзакция и изменения отправленные 2м пользователем начнут обрабатываться, тоесть начнется другая транзакция и тоже обновят запись через 10 секунд
# (!!! SQLite 3 - работет не так как задумано просто выдаст 2му пользователю ошибку SQLite3::BusyException: database is locked)

# 3б. Локинг полный для следующих пользователей вызывает ошибку, тоесть сработает точно так же как и Optimistic:
# Контроллер такойже но изменим экшен update:
class Item2sController < ApplicationController
  before_action :set_item!, except: [:index, :update] # добавим в исключения update, тк экземпляр @item больше не нужен

  # ...

  def update
    result = nil

    Item2.transaction do # начинаем транзакцию при помощи Item2.transaction
      @item = Item2.lock('FOR UPDATE NOWAIT').find params[:id] # ищем и блокируем объект c PostgreSQL настройкой NOWAIT, тоесть запретим ожидание следующему пользователю и выдаем ему ошибку
      @item.title = params[:item2][:title]
      result = @item.save
      sleep 10
    end

    if result
      redirect_to item2_path(@item)
    else
      render :edit
    end
  end

  # ...
end


# ?? Потом проверить Pessimistic locking с PostgreSQL















#
