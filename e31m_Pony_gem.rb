puts '                                    Pony gem. send email in Ruby'

# https://github.com/benprew/pony/
# https://www.rubydoc.info/gems/pony/1.12
# https://stackoverflow.com/questions/2068148/contact-form-in-ruby-sinatra-and-haml    по Синатре

# Pony - это экспресс-способ отправки электронной почты в Ruby при помощи функции mail(), которая может отправить электронное письмо с помощью одной команды. Это самая простая библиотека для отправки почты.

# gem install pony

require 'pony'  # подключение

# Pony использует /usr/sbin/sendmail для отправки почты, если она доступна, в противном случае он использует SMTP для локального хоста.
# Это можно переопределить, если указать опцию via:
Pony.mail(:to => 'you@example.com', :via => :smtp) # sends via SMTP
Pony.mail(:to => 'you@example.com', :via => :sendmail) # sends via sendmail


puts
# НА ПРИМЕРЕ ПРОГРАММЫ:
require 'pony'

my_mail = 'gigantkroker@gmail.com' # переменная с адресом почты отправителя(нашим)

puts "Введите пароль от вашей почты #{my_mail} для отправки письма:"
password = STDIN.gets.chomp  # lokflkbvmodiyvgy

puts "Кому отправить письмо?(укажите почту)"
send_to = STDIN.gets.chomp  # почта получателя

puts "Что написать в письме?"
body = STDIN.gets.chomp # текст письма

# В библиотеке pony есть класс Pony, в котором есть метод mail, который и позволяет нам отправлять письма. В метод mail нужно передать параметры в виде хэша:
Pony.mail(
  {
    :subject => 'привет из руби', # тема письма
    :body => body,                # содержание письма
    :to => send_to,               # адрес получателя
    :from => my_mail,             # адрес отправителя(тут наш)

    #                                                  Gmail
    # Техническая информация(работают только для отправки писем с помощью сервера Gmail(гуглпочты), поэтому если у вас почта у другого провайдера, вам нужно заменить этот блок другим кодом)
    :via => :smtp,
    :via_options => {
      :address => 'smtp.gmail.com',  # хост - сервер отправки
      :port => '587',                # порт
      # :enable_starttls_auto => true,
      # :tls => true,                 # если сервер работает в режиме TSL
      :user_name => my_mail,         # используем наш адрес почты как
      :password => password,         # пароль от почты отправителя(наш)
      :authentication => :plain,     # обычный тип авторизации
      :domain => 'gmail.com'
    }
  }
)
puts 'Письмо отправлено ... наверно' # для проверки что программа сработала и дошла до этой строки

# 535-5.7.8 Username and Password not accepted. Learn more at (Net::SMTPAuthenticationError)
# https://stackoverflow.com/questions/23137012/535-5-7-8-username-and-password-not-accepted
  # 1. зайдите в свою учетную запись Google и включите двухэтапную аутентификацию.
  # 2. Затем в строке «Поиск учетной записи Google» введите «Пароли приложений» и нажмите «Пароли приложений».
  # 3. Затем вам потребуется снова войти в систему.
  # 4. Выберите приложение и устройство, для которого вы хотите сгенерировать пароль приложения. В этом случае выберите «Почта», # 5. а затем «Другое», чтобы настроить имя устройства.
  # 6. Наконец, нажмите СОЗДАТЬ. Используйте его в качестве пароля учетной записи SMTP-AUTH вместо обычного пароля Gmail.
# Лучшее решение для тех, кто столкнулся с ошибкой «535-5.7.8 Имя пользователя и пароль не приняты» в управлении через веб-интерфейс при настройке SMTP на печатных машинах.

# Имя: Kroker, Фамилия: Gigant
# Имя пользователя: gigantkroker@gmail.com, Пароль: ruby_test_pony
# Пароль для компьютера Windows: lokflkbvmodiyvgy


#                                                 Для мэил почты
Pony.mail(
  {
    # тут тоже что и выше ...

    # Техническая информация(работают только для отправки писем с помощью сервера** mail.ru**, поэтому если у вас почта у другого провайдера, вам нужно заменить этот блок другим кодом)
    :via => :smtp,
    :via_options => {
      :address => 'smtp.mail.ru', # хост - сервер отправки
      :port => '465',             # порт
      :tls => true,               # если сервер работает в режиме TSL
      :user_name => my_mail,      # используем наш адрес почты как
      :password => password,      # введенный в консоли пароль
      :authentication => :plain   # обычный тип авторизации
    }
  }
)
# 535 5.7.0 NEOBHODIM parol prilozheniya https://help.mail.ru/mail/security/protection/external / Application password is REQUIRED (Net::SMTPAuthenticationError)
# Проблемы с какимто паролем для приложений(нахуй мэил почту  ? )








#
