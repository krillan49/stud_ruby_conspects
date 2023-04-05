puts '                                           Дата и время'

# Класс Time представляет дату и время в Ruby. Это тонкий слой поверх системных функций даты и времени, предоставляемых операционной системой. Этот класс может быть неспособен в вашей системе представлять даты до 1970 или после 2038 года.


# Получение текущей даты и времени Time.new и Time.now которые являются синонимами
time1=Time.new #=> 2022-11-10 13:21:18 +0300
time1.class #=> Time
time1.inspect #=> 2022-11-10 13:21:18.9216593 +0300
time1.inspect.class #=> String
time2=Time.now #=> 2022-11-10 13:21:18 +0300


# Мы можем использовать объект Time для получения различных компонентов даты и времени
time=Time.new
"Current Time : " + time.inspect #=> Current Time : 2022-06-16 22:04:10.0562021 +0300
time.year    #=> 2022  # Year of the date
time.month   #=> 6     # Month of the date (1 to 12)
time.day     #=> 16    # Day of the date (1 to 31 )
time.wday    #=> 4     # Day of week(0-6): 0 is Sunday
time.yday    #=> 167   # 365: Day of year
time.hour    #=> 22    # 23: 24-hour clock
time.min     #=> 4     # 59
time.sec     #=> 10    # 59
time.usec    #=> 56202 # 999999: microseconds
time.zone    #=> RTZ 2 (����) # "UTC": timezone name

# получения всех компонентов массива в следующем формате: [sec,min,hour,day,month,year,wday,yday,isdst,zone]
time=Time.new
values=time.to_a #=> [55, 21, 22, 16, 6, 2022, 4, 167, false, "RTZ 2 (\xE7\xE8\xEC\xE0)"]

# Возвращает количество секунд с момента начала эпохи
time=Time.now.to_i #=> 1655407522
# Convert number of seconds into Time object.
Time.at(time) #=> 2022-06-16 22:25:22 +0300
# Returns second since epoch which includes microseconds
time=Time.now.to_f #=> 1655407522.1744266


puts
# Функции Time.utc, Time.gm и Time.local - функции для форматирования даты в стандартном формате следующим образом:
# July 8, 2008
Time.local(2008, 7, 8) #=> 2008-07-08 00:00:00 +0300
# July 8, 2008, 09:10am, local time
Time.local(2008, 7, 8, 9, 10) #=> 2008-07-08 09:10:00 +0300
# July 8, 2008, 09:10 UTC
Time.utc(2008, 7, 8, 9, 10) #=> 2008-07-08 09:10:00 UTC
# July 8, 2008, 09:10:11 GMT (same as UTC)
Time.gm(2008, 7, 8, 9, 10, 11) #=> 2008-07-08 09:10:11 UTC


time = Time.new
values = time.to_a
puts Time.utc(*values) #=> 2022-06-16 22:23:34 UTC


puts
# Вы можете использовать объект Time , чтобы получить всю информацию, связанную с часовыми поясами и переходом на летнее время, следующим образом:
time = Time.new
# Here is the interpretation
time.zone       # => "UTC": return the timezone
time.utc_offset # => 0: UTC is 0 seconds offset from UTC
time.zone       # => "PST" (or whatever your timezone is)
time.isdst      # => false: If UTC does not have DST.
time.utc?       # => true: if t is in UTC time zone
time.localtime  # Convert to local timezone.
time.gmtime     # Convert back to UTC.
time.getlocal   # Return a new Time object in local zone
time.getutc     # Return a new Time object in UTC


puts
# Арифметика со временем(отнимаются/прибавляются секунды): #Time-number=>Time; Time+number=>Time; Time-Time=>number of seconds
now= Time.now  #=> 2022-06-16 22:46:54 +0300        # Current time
past=now-10  #=> 2022-06-16 22:46:44 +0300      # 10 seconds ago.
future=now+10  #=> 2022-06-16 22:47:04 +0300    # 10 seconds from now
diff=future-past  #=> 20.0

"00:30:00" > "00:15:00" #=> true


puts
puts '                                          Форматирование даты и времени'

# Существуют различные способы форматирования даты и времени. Например:
time=Time.new #=> 2022-06-16 22:29:54.325225 +0300
time.to_s #=> 2022-06-16 22:29:54 +0300
time.ctime #=> Thu Jun 16 22:29:54 2022
time.localtime #=> 2022-06-16 22:29:54 +0300


puts time.strftime("%Y-%m-%d %H:%M:%S") #=> 2022-06-16 22:29:54
# Директивы форматирования времени. Эти директивы в следующей таблице используются с методом Time.strftime .
"%а" # 1	 Сокращенное название дня недели (Вс).
"%А" # 2	 Полное название дня недели (воскресенье).
"%b" # 3	 Сокращенное название месяца (Jan).
"%В" # 4	 Полное название месяца (январь).
"%с" # 5	 Предпочтительное локальное представление даты и времени.
"%d" # 6	 День месяца (от 01 до 31).
"%H" # 7	 Час суток, 24-часовой формат (00–23).
"%I" # 8	 Час дня, 12-часовой формат (от 01 до 12).
"%j" # 9	 День года (от 001 до 366).
"%m" # 10	 Месяц года (от 01 до 12).
"%M" # 11	 Минуты часа (от 00 до 59).
"%p" # 12	 Индикатор меридиана (AM или PM).
"%S" # 13	 Секунда минуты (от 00 до 60).
"%U" # 14	 Номер недели текущего года, начиная с первого воскресенья как первого дня первой недели (от 00 до 53).
"%W" # 15	 Номер недели текущего года, начиная с первого понедельника как первого дня первой недели (от 00 до 53).
"%w" # 16	 День недели (воскресенье 0, от 0 до 6).
"%x" # 17	 Предпочтительное представление только на дату, без времени.
"%X" # 18	 Предпочтительное представление только на время, без даты.
"%y" # 19	 Год без века (от 00 до 99).
"%Y" # 20	 Год с веком.
"%Z" # 21	 Название часового пояса.
"%%" # 22	 Буквальный символ %.


puts
# date -> time && time -> date
(date.to_time + 10**9).to_date

puts
require 'time'
t=Time.parse("06:30:00") #=> 2022-08-15 06:30:00 +0300
t.min #=> 30


puts
puts '                                                Класс Date'

# Класс Date https://ruby-doc.org/stdlib-3.0.2/libdoc/date/rdoc/Date.html
require 'date'

Date::DAYNAMES #=> ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
Date::MONTHNAMES #=> [nil, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
Date::MONTHNAMES[10] #=> "October"

# Методы
birthday=Date.new(1990, 10, 16)
birthday.year #=> 1990
birthday.month #=> 10
birthday.day #=> 16
birthday.wday #=> 2  # Returns the day of week (0-6, Sunday is zero).
birthday.friday? #=> false # день недели(тут пятница)
birthday.next_year(1) # #<Date: 1991-10-16 ((2448546j,0s,0n),+0s,2299161j)>
birthday.next_month(2) # #<Date: 1990-12-16 ((2448242j,0s,0n),+0s,2299161j)>
birthday.next_day(50) # #<Date: 1990-12-05 ((2448231j,0s,0n),+0s,2299161j)>

# Правильная ли дата?
Date.valid_date?(2001,2,3)        #=> true
Date.valid_date?(2001,2,29)       #=> false
Date.valid_date?(2001,2,-1)       #=> true

# leap?(високосный)
Date.julian_leap?(1900)           #=> true
Date.gregorian_leap?(1900)        #=> false
Date.leap?(2000)                  #=> true     (gregorian)

Date.new(year,month,-1).day #=> число дней в данном месяце данного года

# можно прибавить дни
(Date.new(2016,1,1)+3106).to_s #=> "2024-07-03"

# мат операции над объектами
Date.new(2022,11,4)-Date.new(2022,2,24) # (253/1)  дни  to_i=253

# Парсинг
Date.parse('2001-02-03') #=> #<Date: 2001-02-03 ((2451944j,0s,0n),+0s,2299161j)>
Date._parse('2001-02-03') #=> {:year=>2001, :mon=>2, :mday=>3}
Date._parse('2001-02-03').map{|k,v| v} #=> [2001, 2, 3]

# пример
require 'date'
def dayOfTheWeek(date)
  days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
	y = date.split("/")[2].to_i
  m = date.split("/")[1].to_i
  d = date.split("/")[0].to_i
  days[Date.new(y,m,d).wday]
end
p dayOfTheWeek("02/06/1940") #=> "Sunday"
