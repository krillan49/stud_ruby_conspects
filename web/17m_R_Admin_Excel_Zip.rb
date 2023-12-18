puts '                    Админ. Импорт/экспорт Excel, архивы ZIP, сервисные объекты'

# (На примере AskIt) Создадим функционал, который позволит администратору сайта выгружать(скачивать) информацию о пользователях в формате Excel а именно xlsx, по отдельным Excel фаилам для каждого пользователя и чтобы все эти фаилы вместе помещались в один архив ZIP, чтобы можно было загрузить этот архив и работать с фаилами в нем.

# Будем использовать Excel-фаилы именно с расширением xlsx, тк с ними работать намного проще чем с фаилами с расширениями xls


puts
puts '                                   namespace (для администратора)'

# Namespace - пространство имен, которое можно объявить в маршрутах и использовать создавая дополнительные поддиректории в controllers и views

# Удобно что мы впоследствии можем легко ограничить доступ к URLам администратора другим пользователем на уровне маршрутов и к экшенам тк будем использовать отдельный контроллеры в поддирректории


# 1. Создадим отдельные маршруты в namespace для администратора
Rails.application.routes.draw do
  # ...
  namespace :admin do # создаем namespace с именем :admin и внутри создаем маршруты только для админа(отдельные директории контроллеров и представлений admin/чето)
    resources :users, only: %i[index create]
  end
  # ...
end
# Посмотрим как выглядят эти маршруты:
# admin_users_path	   GET	     /admin/users(.:format)	   admin/users#index
#                      POST	     /admin/users(.:format)	   admin/users#create
# тоесть это отдельные URLы и нужен отдельный контроллер useres_controller.rb в поддирректоррии admin


# 2. Создадим в controllers новую поддиректорию admin и отдельный контроллер controllers/admin/useres_controller.rb в ней (дублирование имени контроллера допустимо тк он в отдельной подпапке, те в отдельном пространстве имен)
module Admin # создаем в модуле
  class UsersController < ApplicationController
    before_action :require_authentication

    def index
      @pagy, @users = pagy User.order(created_at: :desc)
      # возвращает/рендерит admin/users/index.html.erb
    end
  end
end


# 3. Создадим так же поддирректорию admin и в представлениях, в ней отдельную users с видом admin/users/index.html.erb который будет содержать таблицу с пользователями. А так же паршал admin/users/_user.html.erb для этого вида.


puts
puts '                            Обработка запросов разных форматов на примере zip'

# /admin/users(.:format)  - format в маршруте обозначает то что мы можем запрашивать данные с этого маршрута в разном формате, по умолчинию мы запрашиваем данные в формате html, поэтому в ответ на запрос из представления генерируется html-страница. Но с такого маршрута мы можем запросить данные в любом другом формате, если наше приложение может на этот формат отвечать(тоесть есть под него функционал в контроллере и видах)


# 1. Добавим в Gemfile гем который позволяет работать с архивами zip
gem 'rubyzip', '~> 2' # https://github.com/rubyzip/rubyzip
# > bundle i


# 2. Добавим в admin/users/index.html.erb новую ссылку(кнопку) которая будет выгружать для пользователя zip архив


# 3. Научим наше приложение правильно отвечать на разные запрошенные форматы (тут zip). Для этого дополним контроллер controllers/admin/useres_controller.rb:
module Admin
  class UsersController < ApplicationController
    def index
      respond_to do |format|
        # respond_to метод принимающий в блоке все форматы на которые мы хотим отвечать и код как мы будем отвечать
        # format - объект к которому мы применим метод формата и правила по которым будем его обрабатывать

        format.html do # формат html, пишем тоже что пишем в контроллере по умолчанию, тк это формат по умолчанию
          @pagy, @users = pagy User.order(created_at: :desc)
          # так же как и всегда по умолчанию рендерит admin/users/index.html.erb
        end

        format.zip { respond_with_zipped_users } # формат zip, опишем его обработку в отдельном методе ниже
      end
    end

    private

    def respond_with_zipped_users # в консерн можно не переносить, тк использовать будем только тут
      # Сгенерируем zip-фаил в котором будут находиться фаилы Excel:
      compressed_filestream = Zip::OutputStream.write_buffer do |zos|
        # OutputStream - специальный объект, который является временным архивом (нигде у нас на диске храниться не будет), который мы будем пересылать пользователю, в ответ на его запрос.
        User.order(created_at: :desc).each do |user| # так мы создадим Excel фаил для каждого пользователя из запроса
          zos.put_next_entry "user_#{user.id}.xlsx" # указываем имена фаилов(с расширением xlsx), которые поместим в архив
          zos.print render_to_string(
            # print - метод который записывает фаил (тут сгенерированный в render_to_string) в архив
            # render_to_string(...) - метод который генерирует Excel-фаил, данный рендер будет происходит просто в памяти и делать некую строку
            layout: false, handlers: [:axlsx], formats: [:xlsx], template: 'admin/users/user', locals: { user: user }
            # layout: false - тк никакой лэйаут нам не нужен, а только голый фаил Excel
            # handlers: [:axlsx] - обработчик шаблона который мы будем использовать (как erb в some.html.erb)
            # formats: [:xlsx] - формат самого фаила (как html в some.html.erb)
            # template: 'admin/users/user' - шаблон/представление который мы хотим рендерить (user.xlsx.axlsx) для генерации данного Excel-фаила
            # locals: { user: user } - локальная переменная которую передаем в шаблон/вид, которая содержит объект юзера из праметра user запроса User.order...
          )
        end
      end
      compressed_filestream.rewind # нужно "перемотать" созданный фаил архива, тк по время записи "индексы" сместились в конец фаила (какаято непонятная фигня)
      send_data compressed_filestream.read, filename: 'users.zip'
      # send_data - стандартный метод Рэилс, который пересылает фаилы пользователю
      # compressed_filestream.read - параметр метода send_data - фаил архива который передаем с методом read(читать)
      # filename: 'users.zip' - имя передаваемого фаила архива
    end
  end
end


puts
puts '                     Способ создания xlsx фаилов. axlsx.xlsx шаблоны и их редактирование'

# https://www.sitepoint.com/generate-excel-spreadsheets-rails-axlsx-gem/  - статья Круковского по работе с Excel в Рэилс

# Excel-фаилы xlsx которые мы генерируем выше в контроллере controllers/admin/useres_controller.rb, лучше всего генерировать при помощи мощных гемов caxlsx и caxlsx_rails. Но эти гемы могут только записывать/создавать новые Excel-фаилы, а читать и парсить не могут
# https://github.com/caxlsx
# https://github.com/caxlsx/caxlsx
# https://github.com/caxlsx/caxlsx_rails
gem 'caxlsx', '~> 4'
gem 'caxlsx_rails', '~> 0.6'  # подгем для правильной работы с представлениями Рэилс
# > bundle i


# Создадим xlsx.axlsx шаблон/представление при помощи которого будем генерировать Excel-фаилы xlsx. Создадим его в той же директории где лежат html-представления vievs/admin/users/user.xlsx.axlsx
# Содержание фаила рассмотрим тут так в самом фаиле нет подсветки:

wb = xlsx_package.workbook # создаем новый рабочий документ в Excel

s = wb.styles # создаем стили для визуала яцеек таблицы Excel
# https://github.com/caxlsx - тут можно посмотреть стили и примеры, втч графики

highlight_cell = s.add_style(bg_color: 'EFC376') # создаем новый стиль(имя переменной любое) с цветом фона
right_cell = s.add_style(border: Axlsx::STYLE_THIN_BORDER, alignment: { horizontal: :right }) # создаем стиль сразу с двумя ситлями, гораницей ячеек и выравниваем контента в ячейке по правому краю
date_cell = s.add_style(format_code: 'yyyy-mm-dd') # создаем стиль с форматом даты

wb.add_worksheet(name: 'User') do |sheet| # добавляем новый лист с именем 'User'
  sheet.add_row ['ID', user.id], style: [nil, highlight_cell]
  # sheet.add_row - добавляет на этом листе новый ряд таблицы Excel
  # ['ID', user.id] - каждый элемент массива это ячейка в стоке таблицы Excel
  # style: [nil, highlight_cell] - применяем стиле, в массиве к 1й ячейке не применяем стили потому nil, а во второй применяем стили созданные за переменной highlight_cell
  # style: highlight_cell - если без массива, тогда стиль применится ко всем ячейкам
  sheet.add_row ['Name', user.name], style: [nil, right_cell]
  sheet.add_row ['Email', user.email], style: [nil, right_cell]
  sheet.add_row ['Created at', user.created_at], style: [nil, date_cell]
  sheet.add_row ['Updated at', user.updated_at], style: [nil, date_cell]
end














#
