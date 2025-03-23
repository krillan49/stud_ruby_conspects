puts '                                           Класс Time'

# Time - встроенный класс Ruby представляет дату и время. Это тонкий слой поверх системных функций даты и времени, предоставляемых операционной системой. Этот класс может быть неспособен в какой-то конкретной системе представлять даты до 1970 или после 2038 года.


# Time.new и Time.now которые являются синонимами, возвращают объект Time с текущей датой и временем, из которго можно извлечь их разные части при помощи методов
time1 = Time.new    #=> 2022-11-10 13:21:18 +0300
time2 = Time.now    #=> 2022-11-10 13:21:18 +0300
time1.class         #=> Time
time1.inspect       #=> 2022-11-10 13:21:18.9216593 +0300


# Мы можем использовать объект Time для получения различных компонентов даты и времени
time = Time.new
time.year    #=> 2022  # Year of the date
time.month   #=> 6     # Month of the date (1 to 12)
time.day     #=> 16    # Day of the month (1 to 31 )
time.wday    #=> 4     # Day of week(0-6): 0 is Sunday
time.yday    #=> 167   # 365: Day of year
time.hour    #=> 22    # 23: 24-hour clock
time.min     #=> 4     # 59
time.sec     #=> 10    # 59
time.usec    #=> 56202 # 999999: microseconds
time.zone    #=> RTZ 2 (����) # "UTC": timezone name

# получения всех компонентов массива в следующем формате: [sec, min, hour, day, month, year, wday, yday, isdst, zone]
time.to_a    #=> [55, 21, 22, 16, 6, 2022, 4, 167, false, "RTZ 2 (\xE7\xE8\xEC\xE0)"]

# Возвращает количество секунд с момента начала эпохи
time = Time.now.to_i #=> 1682870032
# Преобразование целого числа принимаемого за коллич секунд от начала эпохи в объект Time.
Time.at(time) #=> 2023-04-30 18:53:52 +0300
# Возвращает количество секунд и микросекунд с момента начала эпохи
time = Time.now.to_f #=> 1682870032.0273123
Time.at(time) #=> 2023-04-30 18:53:52 28639/1048576 +0300


puts
# Функции Time.utc, Time.gm и Time.local - функции для форматирования даты в стандартном формате следующим образом:
Time.local(2008, 7, 8)         #=> 2008-07-08 00:00:00 +0300   # July 8, 2008
Time.local(2008, 7, 8, 9, 10)  #=> 2008-07-08 09:10:00 +0300   # July 8, 2008, 09:10am, local time
Time.utc(2008, 7, 8, 9, 10)    #=> 2008-07-08 09:10:00 UTC     # July 8, 2008, 09:10 UTC
Time.gm(2008, 7, 8, 9, 10, 11) #=> 2008-07-08 09:10:11 UTC     # July 8, 2008, 09:10:11 GMT (same as UTC)

time = Time.new
values = time.to_a #=> [55, 21, 22, 16, 6, 2022, 4, 167, false, "RTZ 2 (\xE7\xE8\xEC\xE0)"]
Time.utc(*values) #=> 2022-06-16 22:23:34 UTC


puts
# Получить всю информацию, связанную с часовыми поясами и переходом на летнее время:
time = Time.new
time.zone       #=> "UTC": return the timezone
time.utc_offset #=> 0: UTC is 0 seconds offset from UTC
time.zone       #=> "PST" (or whatever your timezone is)
time.isdst      #=> false: If UTC does not have DST.
time.utc?       #=> true: if t is in UTC time zone
time.localtime  # Convert to local timezone.
time.gmtime     # Convert back to UTC.
time.getlocal   # Return a new Time object in local zone
time.getutc     # Return a new Time object in UTC


puts
# Арифметика со временем(отнимаются/прибавляются секунды):
now = Time.now         #=> 2022-06-16 22:46:54 +0300   # Current time
past = now - 10        #=> 2022-06-16 22:46:44 +0300   # 10 seconds ago.      # Time - number => Time
future = now + 10      #=> 2022-06-16 22:47:04 +0300   # 10 seconds from now  # Time + number => Time
diff = future - past   #=> 20.0                                               # Time - Time => number of seconds

"00:30:00" > "00:15:00" #=> true


puts
require 'time' # Для метода parse нужно подключить
t = Time.parse("06:30:00") #=> 2022-08-15 06:30:00 +0300
t.min #=> 30



puts '                                      Форматирование даты и времени'

# Существуют различные способы форматирования даты и времени. Например:
time = Time.new  #=> 2022-06-16 22:29:54.325225 +0300
# Изначально возвращает специальный объект

time.to_s        #=> 2022-06-16 22:29:54 +0300
time.ctime       #=> Thu Jun 16 22:29:54 2022
time.localtime   #=> 2022-06-16 22:29:54 +0300

# (?? потм все протестировать по кадому ключу, чтобы понять точно)
# strftime - метод преобразует время к обычной строке и может форматировать его, при помощи спец символов подстановки
time.strftime("%Y-%m-%d %H:%M:%S") #=> 2022-06-16 22:29:54
# Директивы(ключи) форматирования времени(используются с методом Time.strftime)
"%а" # Сокращенное название дня недели (Вс).
"%А" # Полное название дня недели (воскресенье).
"%b" # Сокращенное название месяца (Jan).
"%В" # Полное название месяца (январь).
"%с" # Предпочтительное локальное представление даты и времени.
"%d" # День месяца (от 01 до 31).
"%H" # Час суток, 24-часовой формат (00–23).
"%I" # Час дня, 12-часовой формат (от 01 до 12).
"%j" # День года (от 001 до 366).
"%m" # Месяц года (от 01 до 12).
"%M" # Минуты часа (от 00 до 59).
"%p" # Индикатор меридиана (AM или PM).
"%S" # Секунда минуты (от 00 до 60).
"%U" # Номер недели текущего года, начиная с первого воскресенья как первого дня первой недели (от 00 до 53).
"%W" # Номер недели текущего года, начиная с первого понедельника как первого дня первой недели (от 00 до 53).
"%w" # День недели (воскресенье 0, от 0 до 6).
"%x" # Предпочтительное представление только на дату, без времени.
"%X" # Предпочтительное представление только на время, без даты.
"%y" # Год без века (от 00 до 99).
"%Y" # Год с веком.
"%Z" # Название часового пояса.
"%%" # Буквальный символ %.



puts '                                                Класс Date'

# Класс Date https://ruby-doc.org/stdlib-3.0.2/libdoc/date/rdoc/Date.html
require 'date'

Date::DAYNAMES #=> ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
Date::MONTHNAMES #=> [nil, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

# Методы
birthday = Date.new(1990, 10, 16)
birthday.year          #=> 1990
birthday.month         #=> 10
birthday.day           #=> 16
birthday.wday          #=> 2  # Returns the day of week (0-6, Sunday is zero).
birthday.friday?       #=> false # день недели(тут пятница)
birthday.next_year(1)  # #<Date: 1991-10-16 ((2448546j,0s,0n),+0s,2299161j)>
birthday.next_month(2) # #<Date: 1990-12-16 ((2448242j,0s,0n),+0s,2299161j)>
birthday.next_day(50)  # #<Date: 1990-12-05 ((2448231j,0s,0n),+0s,2299161j)>

# Правильная ли дата?
Date.valid_date?(2001, 2, 3)        #=> true
Date.valid_date?(2001, 2, 29)       #=> false
Date.valid_date?(2001, 2, -1)       #=> true

# Отрицательные значения как индексы с конца например тут дней месяца
Date.new(2001, 2, -1) # #<Date: 2001-02-28 ((2451969j,0s,0n),+0s,2299161j)>
Date.new(2001, 2, -2) # #<Date: 2001-02-27 ((2451968j,0s,0n),+0s,2299161j)>
# число дней в данном месяце данного года
Date.new(2000, 2, -1).day #=> 29

# leap?(високосный)
Date.julian_leap?(1900)           #=> true
Date.gregorian_leap?(1900)        #=> false
Date.leap?(2000)                  #=> true     (gregorian)

# мат операции
(Date.new(2016, 1, 1) + 3106).to_s        #=> "2024-07-03"
Date.new(2022,11,4) - Date.new(2022,2,24) #=> (253/1)  дни  to_i=253

# Парсинг
Date.parse('2001-02-03')  #=> #<Date: 2001-02-03 ((2451944j,0s,0n),+0s,2299161j)>
Date._parse('2001-02-03') #=> {:year=>2001, :mon=>2, :mday=>3}



puts '                                               Разное'

# date -> time && time -> date
(date.to_time + 10**9).to_date












#
