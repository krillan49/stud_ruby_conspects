puts '                                         Sinatra(Ruby on Sinatra)'

# https://github.com/sinatra/sinatra   -   документация sinatra

# gem install sinatra   -   установка гема(если очень долго устанавливается отменям контрл+с и заново оно доустановит)
# gem install puma      -  также рекомендуется запустить, его Sinatra заберет при наличии.

# ruby app.rb        -  запуск сервера в текущем окне терминала.
# start ruby app.rb  -  запуск сервера в отдельном окне терминала.

require 'sinatra'  # подключение модуля sinatra в app.rb

# при каждом запросе синатра считывает фаил с диска, соотв не нужно чтото каждый раз перезагружать во время изменений, но это не касается главного фаила программы app.rb, если мы вносим изменения в нем то уже нужен перезапуск. Измененный код не вступит в силу, пока вы не перезапустите сервер.

# Чтобы иметь возможность менять фаилы erb не перезапуская Синатру нужно установить доп гем
# gem install sinatra-reloader            -   установка
# gem install sinatra-contrib             -   альтернативный вариант установки если 1й не работает
# sudo apt install ruby-sinatra-contrib   -   вариант для мака и линукс
require 'sinatra/reloader' # необходимо подключить в app.rb


# При запуске сервера Синатры возвращается отладочный вывод и программа не завершается. В отладочном выводе, в том числе, написан и необходимый порт на нашем компьютере(например 4567)
# http://localhost:4567/  -  адрес на который нужно зайти в браузере чтобы обратиться к этому запущенному серверу, после этого браузер обращается к написанному нами серверу и исполняет код. После чего в отладочном выводе появляется доп информация об этом.
# Ctrl+C - остановить работу сервера.

# localhost - это обозначение нашего компьютера
# обычно вебсайты работает по порту 80, тогда номер порта писать не нужно, но если порт другой то нужно

# Как работает сервер: запрос от браузера сперва идет на кэширующий прокси(nginx) от него на сервер синатры/рэилс, затем обратно по той же схеме. nginx - кэширует контент(например картинки), а к серверу синатры/рэилс обращается только за приложением.


puts
puts '                                         Обработчик GET-запросов'

# get - метод в Синатре, отвечающий за GET-обработчик URL-адреса, соответсвенно он обслуживает запрос браузера типа "get"(браузер хочет получить данные с сервера), он срабатывает на сервере запущенном Синатрой(тут локальном) когда пользователь загружает страницу(в данном случае с адреса '/'). Он сообщает: если пришел GET-запрос на корневую директорию '/', то выполни блок кода, заданный между do и end.

get '/' do # get - метод(запуск), он принимает 2 аргумента:
  # URL-адрес('/')
  # Блок код/лямбда(do...end); get('/', lambda)
  # '/' - тут слэш это общепринятое значение корня сайта те корневой сайт(нужен для локального сервера ??) корневая страница по адресу localhost:4567(переходя на нее в браузере мы запрашиваем выполнение метода get '/' на сервере)
  return 'Hi'  # Возвращает просто текст на корневую страницу в пустом html фаиле. return не обязателен.
end

# Далее можно добавлять при необходимости подстраницы например:
get '/contacts' do # подстраница по адресу localhost:4567/contacts(переходя на нее в браузере мы выполняем метод get '/contacts')
  'phone 1113333' # и возвращается данный текст в пустом html фаиле
end

# Можно писать в одну строку(похоже что никакой синтаксис с {} вместо do end не работает)
get '/' do 'ya Kroker' end
get '/' do erb 'ya Kroker' end
get '/' do erb :a_welcome end


puts
puts '                                            views view .erb'

# view - (вид/представление) - это HTML-страница в формате, позволяющем вставлять в нее рубикод, те относится к frontend(тому что загружается в браузер). Оно пошло из V аббревиатуры MVS(модель вид контроллер).

# views - имя каталога, в котором хранятся представления, Синатра находит виды из этого каталога автоматически. Если хранить в другом месте необходимо дополнительно задать место где искать виды, но структура с views предпочтительнее как стандарт.

# Создаем в каталоге views HTML-страницу с расширением .html.erb либо просто .erb (например index.erb) и с необходимым нам HTML-кодом внутри(например <h1>Hello</h1>)
# Далее подключим это представление в нашу программу через метод erb(как имя расширения), а имя фаила(a_index) в виде символа - его параметром
get '/' do # принимаем запрос браузера по адресу '/'
  erb :a_index  # метод erb обращается к фаилу(предварительно ищет его в каталоге views) a_index.erb и возвращает HTML-код из него браузеру
  # erb :index можно прочитать как erb(:index). erb - метод, который принимает в качестве аргумента :index
end
# теперь рубикод и HTML-разметка у нас в разных каталогах что довольно удобно


puts
puts '                                            Синтаксис erb'

# erb - это один из template(шаблон) engine(движек) те движек шаблонов, соотв есть и другие и для HTML и не только, их можно посмотреть(Available Template Languages): https://github.com/sinatra/sinatra

# Синтаксис erb в HTML-коде позволяет в специальных "кавычках"(<%= %>) кавычках вставлять любой рубикод в HTML:
# 1. <% любой_руби_код %>     -    Код Руби будет выполнен, но ничего не будет выводиться на странице.
# 2. <%= любой_руби_код %>    -    Будет выполнено и выводиться в месте, где стоит.


puts
puts '                                        Обработчик POST-запросов'

# post - метод обслуживает POST-запросы, те обрабатывает данные которые браузер отправил к нам на сервер, например логин и пароль со страницы

require 'sinatra'

get '/' do   # гет обработчик ...
  erb :a_index # ... возвращает страницу с формой, которая будет использована для пост запроса
end

# В сдучае если форма передает на GET(<form aсtion="GET"...), то параметры все равно есть в params[:чето], тоже касается запросов PUT, DELETE, хоть они и передаются по другому

post '/' do # в пути пишется тоже самое('/') что и в значении атрибута action в теге формы в .erb фаиле
  params[:aaa] # params - метод, позволяет обращаться к параметрам, этот метод работает как хэш, в котором: key - это значение атрибута 'name' поля в формате символа(тут :aaa), а value это то что пользователь ввел/выбрал в поле;

  # При помощи метода params мы можем присвоить введенные в пользователем в поле данные в переменную. В нашу переменную присваивается значение хэша, тоесть данные введенные в поле пользователем.

  login0 = params[:aaa] # локальная переменная может использоваться только в теле запроса, например для интерполяции ее значения в другую переменную или наполнения БД. Если поместить ее в представление, то выдаст ошибку, тк вызов локальной переменной которая не определена вызывает ошибку(тк локаотная переменная не переносится в представление)

  # Для того чтобы использовать переменную в представлении - ее нужно задавать с @:
  @login = params[:aaa] # Теперь значение переменнай @login можно вставить в представление при помощи <%=  %>.

  # Всё уже намного проще, просто в erb файле, вместо @login, можно писать сразу params[:aaa](из комментов к уроку 19)

  @password = params[:bbb] # аналогично для пароля

  erb :a_index # возвращаем вид, и если поместить в него наши переменные то отобразятся их значения
end
# теперь в нашей программе существуют 2 переменные(@login и @password) которые мы можем проверять


puts
puts '                                       Доступ по логину и паролю'

# Добавляем функциональность: обращение к разному виду/представлению в зависимости от правильности логина и пароля и вывод сообщения в случае неверного
post '/' do
  @login    = params[:aaa]
  @password = params[:bbb]

  if @login == 'admin' && @password == 'secret' # если условие срабатывает(введенные пароль и логин соответсвуют) то ...
    erb :a_welcome # ... возвращаем вид welcome в котором содержится ссылка на страницу contacts
    # для вида welcome нет своего адреса и гет-обработчика, соотв нельзя зайти случайно и получить админскую инфу
  elsif @login == 'admin' && @password == 'admin'
    @denied = 'Haha, nice try! <b>Access is denied!</b>' # можно задать другое значение переменной
    # можно передавать переменные содержащие HTML-тэги, которые будут функциональными в представлении
    erb :a_index
  else
    @denied = 'Access is denied' # если условие неверно появляется доп строка на странице(если в фаиле index есть соотв строка)
    erb :a_index # тк мы возвращаем вид index то переменная @denied должна быть в нем, чтобы отобразиться
  end
end

get '/contacts' do # адрес который будет открываться по ссылке из welcome.erb(<a href="/contacts">Contacts</a>). Тк ссылка активирует переход на URL адрес, соотв браузер посылает гет-запрос, соотв ему нужен и обработчик
  "Contacts: +7 000 000-00-00"
end


puts
puts '                              Одно представление для множества однотипных страниц'

# Если на сайте нужно сделать несколько страниц на которых особо ничего не происходит(например тех что просто запланированы или просто страницы особо ничего не содержащие) то можно обойтись одним новым представлением для всех
# Создаем вид message.erb в котором пишем такой код чтоб все отображанемое на странице передавалось только через переменные
get '/faq' do
  @title = 'FAQ'
  @message = 'test page1'
  erb :a_message
end
get '/something' do # В итоге мы создали 2 разные страницы за которые отвечает одно представление message.erb
  @title = 'Something'
  @message = 'test page2'
  erb :a_message
end
# Так же мы можем обобщить содержание этих страниц в отдельном методе если оно однотипное
def under_construction
  @title = 'Under construction'
  @message = 'This page is under construction'
  erb :a_message
end
get '/some' do
  under_construction
end
get '/other' do
  under_construction
end


puts
puts '                           Запись данных формы в фаил и вывод данных на страницу'

# сохраниение в фаил на примере barbershop
#(для сохранения фаила в маке и линуксе возможно придется его сперва создать с правами доступа при помощи команды chmod 666 users.txt)
require 'sinatra'

get '/' do
  erb :barbershop_index
end

post '/' do
  @user_name = params[:user_name]
  @phone     = params[:phone]
  @date_time = params[:date_time]

  @title = 'Thank you!'
  @message = "Dear #{@user_name}, we'll be waiting for you at #{@date_time}" # производим интерполяцию строк чтобы задать значение переменных в текст для вывода в представлении :barbershop_message

  f = File.open 'text/barbershop_users.txt', 'a' # создаем txt фаил для списка заявок
  f.write "User: #{@user_name}, phone: #{@phone}, date and time: #{@date_time}\n" # записываем данные из заявок
  f.close

  erb :barbershop_message
end

# Чтение из фаила в Синатре вариант 1(без использования erb фаила для этой страницы)
get '/result1' do
  send_file 'text/barbershop_users.txt' # посылаем фаил на страницу /result1 нашего сайта
  # erb :barbershop_result # html из этого вида не выводит. Видимо потому что фаил посылается на адрес а не в представление
  # Данным способом почемуто не отображаются данные введенные во время работы с сайтом если дополнительно не обновить страницу
end

# Чтение из фаила в синатру вариант 2
get '/result2' do
  @file = File.open('text/barbershop_users.txt',"r") # открываем фаил и помещаем в переменную, для того чтоб ее можно было использовать в представлении
  erb :barbershop_result
  # @file.close - придется перенести в erb, тк иначе метод возвращает этод код а не вид
end


puts
puts '                                             Папка public'

# Позволяет нам обеспечивать доступ дополнительных фаилов в веб(на наш сайт) просто по адресу, без дополнительных элементов кода. Аналогично views папка public автоматически воспринимается Синатрой в этом качестве. Если мы положим в эту папку какой либо фаил, то он будет доступен нам из корня сайта, например:
# localhost:4567/users.txt    -   по этому адресу получим содержание фаила users.txt, если он лежит в директории public
# В каталоге public можно создавать для удобства любое количество подкаталогов(например для css):
# localhost:4567/css/styles.css    -   получим содержание фаила styles.css, если он лежит в директории public/css

# Теперь для записи в этот фаил доступного через веб, достаточно изменить путь на ./public/users.txt (. в начале означает текущий каталог) и наша программа будет куда проще тк этот фаил после создания будет доступен по localhost:4567/users.txt
f = File.open './public/users.txt', 'a'  # меняем путь тут


puts
puts '                                             Layout.erb'

# layout.erb - это базовая страница/шаблон, имя зарезервировано. Он будет всегда использоваться Синатрой по умолчанию и добавлять параметр метода erb в точку <%= yield %>. В файле views/layout.erb можно сделать основной каркас страницы, разместить yield и уже из других erb подгружать информацию.

# Задаем аргументом метода erb(если хотим не использовать Layout нужно возвращать просто код без метода erb) необходимый html код или представление и он будет выводиться внутри вида layout.erb в точку <%= yield %>. Тоесть метод get вернет нам представление layout.erb c интегрированным в <%= yield %> аргументом метода erb
get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>" # просто строка с html кодом
end
get '/' do
	erb :a_welcome # код из вида a_welcome также помещается в точку <%= yield %>
end


# Сообщение об ошибке(пример вложенного в erb кода Ruby). В layout для нее есть код, проверяющий переменную.
get '/about' do
  @error = 'Какаято ошибка!!!' # Оппределяем переменную @error и в коде вида layout, она будет работать
  erb :barbershop_about
end


puts
puts '                                             Валидация'

# Валидация(validation) - обозначает проверку параметров. Например если отправлена форма с незаполненными полями:
get '/' do
  erb :barbershop_index
end

post '/' do
  @user_name = params[:user_name]
  @phone     = params[:phone]
  @date_time = params[:date_time]

  if @user_name != '' && @phone != '' && @date_time != '' # Пустая строка('') будет значением если ничего не введено в поле
    @title = 'Thank you!'
    @message = "Dear #{@user_name}, we'll be waiting for you at #{@date_time}"
    # Не добавляем @error = nil тк эта переменная в новом запросе снова не определена:
    # Во время нового запроса и контекст новый, данные между разными запросами не сохраняются(кроме как сохранений в сессиях или в базе) Иначе как запросы двух людей разделять
    erb :barbershop_message
  else
    @error = "You forgot enter some field. Please reapite"
    erb :barbershop_index
  end
end

# Для того чтобы пользователь не заполнял все поля заново, если какоето забыто, нужно поставить значение заполненных полей в аргумент value в html-элементе этого поля при помощи синтаксиса <%= ... %> добавив прямо в значение аргумента value переменную
post '/' do
  @user_name = params[:user_name]
	@phone     = params[:phone]
	@date_time = params[:date_time]
  @barber    = params[:barber]

  # хеш для удобства, значения повторяют значения атрибутов name
	hh = { user_name: 'Введите имя', phone: 'Введите телефон', date_time: 'Введите дату и время' }

	@error = hh.select{|key,_| params[key] == ''}.values.join(", ") # объединяем сообщения о незаполненных полях в строку и присваиваем в переменную, либо пустую строку если незаполненных значений нет

  return erb :barbershop_index if @error != '' # возвращаем вид в зависимости от того какое значение приняла переменная

  @message = "Dear #{@user_name}, we'll be waiting for you at #{@date_time}"
  erb :barbershop_message
end


puts
puts '                                     Отправка ответа на почту пользователя'

# отправка подтверждения на почту при помощи гема pony
require 'sinatra'
require 'pony'

get '/contacts' do
	erb :barbershop_contacts
end

post '/contacts' do
	@email        = params[:email]   # (например) VasiaPupkin@gmail.com
	@user_message = params[:user_message]

	hh = { email: 'Введите почту', user_message: 'Введите сообщение' }
	@error = hh.select{|k,_| params[k] == ''}.values.join(', ')

	if @error == ''
		@message2 = "<p style=\"color: green;\">Сообщение принято, ответ будет прислан на вашу почту по адресу #{@email}</p>"

	  Pony.mail(   # отправляем подтверждение на почту пользователя
		  {
		    :subject => 'Ваше сообщение принято',
		    :body => 'Ваше сообщение принято',
		    :to => @email, # используем переменную с почтой введенной пользователем в форму
		    :from => 'gigantkroker@gmail.com',

		    :via => :smtp,
		    :via_options => {
		      :address => 'smtp.gmail.com',
		      :port => '587',
		      :user_name => 'gigantkroker@gmail.com',
		      :password => 'lokflkbvmodiyvgy',
		      :authentication => :plain,
		      :domain => 'gmail.com'
		    }
		  }
		)
	end

	erb :barbershop_contacts
end


puts
puts '                                        configure + базы данных'

# configure - команда, которая запускается при инициализации приложений(каждый перезапуск фаила .rb) или при обновлении приложения/сохранении фаила. Соотв в ней удобно создавать или открывать необходимые фаилы, например базу данных.

# похоже переменные с @ работают только внутри метода и в .erb но не работают по всему .rb фаилу.
# в комментах для открытия и использования базы данных предлагали глобальную переменную с $(проверено - работает, но в чатике сказали что это плохая практика), но тут сделаем с локальной переменной и будем вызывать каждый раз объект базы данных

# пример с базой данных sqlite3(не забываем добавлять базы данных в гитигнор)
require 'sinatra'
require 'sqlite3'

configure do
	db = SQLite3::Database.new('barbershop.db') # создаем новое подключение к barbershop.db(либо саму эту БД если ее нет)
  db.execute 'CREATE TABLE IF NOT EXISTS "Users"
  ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "username" TEXT, "phone" TEXT, "datestamp" TEXT, "barber" TEXT)' # создаем в этой базе таблицу если она не создана.(кавычки в названии столбцов не обязательно)
  db.close
end

get '/' do
  erb :barbershop_index
end

post '/' do
  @user_name = params[:user_name]
	@phone     = params[:phone]
	@date_time = params[:date_time]
  @barber    = params[:barber]

  db = SQLite3::Database.new('barbershop.db') # тут приходится заново запускать БД
  db.execute 'INSERT INTO Users ( username, phone, datestamp, barber ) VALUES (?, ?, ?, ?)', [@user_name, @phone, @date_time, @barber] # записываем в базу данных данные введенные пользователем
  db.close

  erb :barbershop_index
end


puts
# Вывод из базы данных + выведение открытия/создания базы в отдельный метод

def get_db
	db = SQLite3::Database.new './DBS/barbershop.db' # открываем/создаем базу только при запуске метода и прописываем путь
	db.results_as_hash = true # выводим результаты в виде хэша
	db # возвращаем нашу открытую бд(нужно тк метод выше возвращает true)
end

configure do
	db = get_db() # вызываем метод и присваиваем БД в переменную
	db.execute 'CREATE TABLE IF NOT EXISTS "Users"
  ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "username" TEXT, "phone" TEXT, "datestamp" TEXT, "barber" TEXT)'
	db.close
end

get '/' do
  erb :barbershop_index
end

post '/' do
  @user_name = params[:user_name]
	@phone     = params[:phone]
	@date_time = params[:date_time]
  @barber    = params[:barber]

  db = get_db() # вызываем метод и присваиваем БД в переменную
  db.execute 'INSERT INTO Users ( username, phone, datestamp, barber ) VALUES (?, ?, ?, ?)', [@user_name, @phone, @date_time, @barber]
  db.close

  erb :barbershop_index
end

# Вариант вывода из БД 1. Который я сам сделал как ДЗ к уроку 26(грязный c html в основном фаиле).
get '/showusers' do # страница для вывода данных из бд
	@users = '' # для вывода данных воспользуемся переменными
	@columns = ''
	db = get_db()
	db.execute 'SELECT * FROM Users ORDER BY id DESC' do |row|
		@columns = '<th>'+row.keys.join('</th><th>')+'</th>' if @columns == '' # заполняем названия столбцов
		@users += '<tr><td>'+row.values.join('</td><td>')+'</td></tr>' # заполняем данные в столбцах
	end
	db.close
	erb :barbershop_showusers
end

# Вариант вывода из БД 2. Более чистый способ без манипуляций с html в фаиле rb, а только то что относится к логике
get '/showusers' do
	db = get_db()
	@results = db.execute 'SELECT * FROM Users ORDER BY id DESC' # сохраняем результаты всего запроса в переменную
	db.close
	erb :barbershop_showusers_b
end


puts
puts '                    before(в sinatra) + загрузка только уникальных значений в БД в configure'

require 'sinatra'
require 'sqlite3'

# дополнительная функция проверяющая существует ли уже парикмахер в таблице Barbers
def is_barber_exists?(db, name) # принимает обьект БД и имя парикмахера
  db.execute('SELECT * FROM Barbers WHERE name=?', [name]).size > 0 # если длинна массива массивов строк запроса, в котором содержится имя проверяемого парикмахера > 0 тогда вернется true иначе false
end
# дополнительная функция(seed(наполнить) - устоявшееся название для фукций заполнения, тут для заполнения БД)
def seed_db(db, barbers) # принимает БД и массив парикмахеров
  barbers.each do |barber| # проверяем каждого парикмахера в массиве
    if !is_barber_exists?(db, barber) # если парикмахер не существует в таблице Barbers(метод возвращает false)
      db.execute 'INSERT INTO Barbers (name) VALUES (?)', [barber] # тогда добавляем его в таблицу, так у нас не будут дублироваться парикмахеры в таблице
    end
  end
end

def get_db
	db = SQLite3::Database.new './DBS/barbershop.db'
	db.results_as_hash = true
	db
end

configure do
	db = get_db()
  db.execute 'CREATE TABLE IF NOT EXISTS "Users"
  ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "username" TEXT, "phone" TEXT, "datestamp" TEXT, "barber" TEXT, "color" TEXT)'

  # создаем 2ю таблицу для парикмахеров для селектора в форме
  db.execute 'CREATE TABLE IF NOT EXISTS "Barbers" ( "id" INTEGER PRIMARY KEY AUTOINCREMENT, "name" TEXT )'

  seed_db(db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']) # вызываем метод с параметрами: объект БД и списком парикмахеров в виде массива(миграция для заполнения таблицы ? тк добавит только тех которых нет в нашей таблице изначально, те это способ добавить новых парикмахеров)

  db.close # закрываем только после обработки функции
end

# before (в sinatra) - каждый раз исполняет код в теле метода before перед(в теле обработчика??) любым запросом(get/post/...) - соотв код(напр переменные) из before будет доступен во всех обработчиках и соотв представлениях ими возвращамых. Удобно если один и тот же код необходимо использовать в нескольких запросах и возвращаемых ими представлениях
# Для Барбершоп у нас есть 2 обработчика корневой страницы(get '/' и post '/') оба возвращают barbershop_index в котором есть селектор со значениями из БД из таблицы парикмахеров соотв и там и там в коде будет нужна переменная @barbers, соотв если не присвоить ее в какомто запрсе может быть ошибка и удобнее присвоить ее в before чем 2 раза - в каждом обрабочике.
before do
  db = get_db()
	@barbers = db.execute('SELECT * FROM Barbers') # Теперь эта переменная будет доступна во всех представлениях
	db.close
end

get '/' do
  # теперь переменная @barbers с результатом запроса из before сможет работать тут
  erb :barbershop_index
end

post '/' do
  # теперь переменная @barbers с результатом запроса из before сможет работать тут

  @user_name = params[:user_name]
	@phone     = params[:phone]
	@date_time = params[:date_time]
  @barber    = params[:barber]
  @color     = params[:color]

	hh = { user_name: 'Введите имя', phone: 'Введите телефон', date_time: 'Введите дату и время' }
	@error = hh.select{|key,_| params[key] == ''}.values.join(", ")

  return erb :barbershop_index if @error != ''

  db = get_db()
  db.execute 'INSERT INTO Users ( username, phone, datestamp, barber, color ) VALUES (?, ?, ?, ?, ?)', [@user_name, @phone, @date_time, @barber, @color]
  db.close

  @message = "Dear #{@user_name}, we'll be waiting for you at #{@date_time}"
  erb :barbershop_message
end


puts
# (На примере программы leprosorium)
# before для инициализации базы данных для каждого обработчика и каждого представления.
# redirect to '/' - перенаправление на другую страницу
require 'sinatra'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new './DBS/leprosorium.db'  # присваиваем базу данных в переменную с @ чтобы она работала в видах и обработчиках - чтобы не писать init_db каждый раз, а только в before. Тк не получится использовать локальную переменную, тк метод возвращает(втч и before) последнее значение и его пришлось бы присваивать в переменную каждый раз, а @переменные достаточно определить в теле метода и они будут работать в области вызвавшей метод.
	@db.results_as_hash = true
end

before do
	init_db # теперь база данных присвоенная в переменную @db будет доступна для каждого метода обработчика(теперь нам не нужно в каждом обработчике писать init_db)
end

configure do
	init_db  # тут соотв тоже используем @db(тк before не работает в configure)
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts
	(id INTEGER PRIMARY KEY AUTOINCREMENT, created_date DATE, author TEXT, content TEXT)'
  # Вторая таблица для след раздела(Универсальный обработчик. Прием параметра из ссылки)
  @db.execute 'CREATE TABLE IF NOT EXISTS Comments
	(id INTEGER PRIMARY KEY AUTOINCREMENT, created_date DATE, content TEXT, post_id INTEGER)'
end

get '/' do
  # Теперь и тут нам доступна база данных @db из before соотв не нужно дополнительно вызывать init_db
	@results = @db.execute 'SELECT * FROM Posts ORDER BY id DESC'
	erb :leprosorium_index
end

get '/new' do
	erb :leprosorium_new
end

post '/new' do
	content = params[:content]
  author  = params[:author]

	if content.size <= 0
		@error = 'Введите текст'
		return erb :leprosorium_new
	end

  # Теперь и тут нам доступна база данных @db из before соотв не нужно дополнительно вызывать init_db
  @db.execute 'INSERT INTO Posts
	(content, created_date, author) VALUES (?, datetime(), ?)', [content, author]

	redirect to '/'    # перенаправляет нас на другую (тут главную) страницу после обработки запроса
end


puts
puts '                                             redirect/redirect to'

# redirect - метод отправляет HTTP-заголовок для перенаправления клиента на заданный URL-адрес, передаваемый аргумент должен быть полным URL-адресом с хостом (например http://example.com/path, не просто /path).
# to - метод преобразует путь в полный URL-адрес вашего приложения Sinatra, позволяя использовать полученный URL-адрес в файлах redirect. Например, to('/path')станет http://yoursinatraapp/path.

# Метод redirect to в Синатре используется для перенаправления пользователя на другую страницу. Когда метод вызывается, Синатра отправляет HTTP-заголовок Location с указанием нового местоположения и статус кодом 302 (Found).
# Для использования метода redirect to необходимо иметь объект запроса (request) и объект ответа (response). Пример:
get '/' do
  redirect to '/about' #=> переходим на URL .../about(как по ссылке), соотв далее как будто браузер посылает гет-запрос с адреса '/about' ...
end
get '/about' do # ... соответсвенно этот обработчик принимает гет запрос от redirect to '/about'
  "Это страница о нас"
end
# В этом примере при переходе на главную страницу пользователь будет автоматически перенаправлен на страницу "/about". Если метод не получит аргумента, то он будет перенаправлять на главную страницу ("/").

# Метод redirect to не сохраняет при переходе переменные экземпляра из материнского обработчика, поэтому например для @error нужно возвращать представление.


puts
puts '                            Универсальный обработчик. Прием параметра из ссылки'

# (На примере продожения программы leprosorium)
# Чтобы автоматически вставлять элемент адреса в адрес нужно воспользоваться параметром чтобы использовать один обработчик для однотипных страниц, а иначе пришлось бы делать множество отдельных обработчиков(например для каждого поста в блоге)

# (get запрос приходит из представления leprosorium_index по сформированной там ссылке)
get '/details/:post_id' do # добавляем в адрес :id(название любое) теперь Синатра будет знать что это идентификатор, соответсвенно данный обработчик становится универсальным для любых(не только цифры) значений :id. Теперь соответсвенно при переходе на адрес /details/некое_значение (не важно на адрес этот перешли ссылкой или мы просто пишем значение в адресной строке наугад) будет открыта эта страница.
  post_id = params[:post_id] # метод params так же может возвращать параметр(тут цифру) по элементу из URL адреса в обработчике(тут :post_id). Например если адрес /details/6 то тут в переменную post_id присвоится значение 6

  results = @db.execute 'SELECT * FROM Posts WHERE id = ?', [post_id]
	@row = results[0]  # у нас внешний массив results состоит из одного элемента(массива/хэша) тк id в таблице уникален

  # запрос для комментариев для поста чтобы отобразить их на странице поста
  @comments = @db.execute 'SELECT * FROM Comments WHERE post_id = ? ORDER BY id', [post_id]

  erb :leprosorium_details
end

post '/details/:post_id' do # универсальный пост обработчик(тут обрабатывает POST-запросы с URL формы /details/:post_id, которые мы генерируем в leprosorium_details выводя post_id из колонки в таблице постов из БД)
  post_id = params[:post_id] # получаем айди аналогично

  content = params[:content] # получаем данные(комментарий) из формы

  if content.size <= 0 # валидация
		@error = 'Введите текст комментария'
    # тут придется для валидации снова повторить код из гет обработчика, тк эти переменные используются в виде(непонятно где лучше это прописать в отдельный метод или в before(но похоже что слишком лучше его не захламлять))
    @row = (@db.execute 'SELECT * FROM Posts WHERE id = ?', [post_id])[0] # в массиве 1 элемент
    @comments = @db.execute 'SELECT * FROM Comments WHERE post_id = ? ORDER BY id', [post_id]
		return erb :leprosorium_details # возвращаем вид на тот же адрес
	end

  @db.execute('INSERT INTO Comments
	(content, created_date, post_id) VALUES (?, datetime(), ?)', [content, post_id]) # post_id для того чтобы знать к какому посту коментарий, тк id это просто порядок комментариев к разным постам

  redirect to ('/details/' + post_id)  # перенаправляем на страницу поста(get '/details/:post_id') чтоб открыть leprosorium_details без сохраненных в value переменных и для избежания повторной отправки формы(PRG)
end















#
