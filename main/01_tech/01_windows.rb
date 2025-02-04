puts '                                   Установка и настройка Ruby под windows'

# Руби - интерпритируемый язык.

# https://putshello.wordpress.com/2014/08/03/installing-ruby-for-windows-the-right-way/
# https://hackware.ru/?p=10817  правильная установка Руби и окружения(DevKit)

# https://www.youtube.com/watch?v=lhRAK_bwaeo&list=PLWlFXymvoaJ-td0fgYNj3fCnCVDTDClRg          - установка в самом начале


# https://rubyinstaller.org/downloads/   - установка интерпритатора Руби под виндоус, лкчше выбрать стабильную версию с WITH DEVKIT выделенную жирным

# DevKit - комплект разработчика. Без msys (aka devkit) не будут компилироваться многие библиотеки

# Установка Ruby с помощью установщика Ruby:
# 1. Все настройки можно оставить по умолчанию, но в конце галочка рядом с "Run 'ridk install' ..." должна стоять, но лучше ставим все галочки(разве что можно не ставить галочку документации во втором окне). Ставим галочку run reader install
# 2. Далее откроется окно терминала, в нем по очереди вводим все предложенные цифры(хотя 2ю не обязательно) + энтер(по очереди):
#     а. Вводим цифру 1 и нажимаем Enter - пойдет базовая установка
#     б. Вводим цифру 2 и нажимаем Enter - пойдет обновление (если какието ошибки - пофиг)
#     в. Вводим цифру 3 и нажимаем Enter

# Убедитесь, что вы обновили переменную PATH, указывающую на: C:\Ruby200-x64\bin (если установили руби в C:\Ruby200-x64). Нажмите Win+R, введите cmd , затем введите irb. У вас должен быть irb на вашем пути. Введите ruby ​​-v , чтобы показать версию ruby. Примечание: если вы используете Far Commander или другие коммандеры, вам может потребоваться перезапустить это приложение.

# Далее прямо в основной директории Руби например C:\Ruby31-x64 можно создать папку например PROJECTS для наших rb фаилов



puts '                                    Установка DevKit, если его нет'

# Если до того была установлена версия без DevKit, то прежде чем вы сможете установить гемы, необходимо установить комплект разработчика DevKit. Перейдите на страницу загрузки установщика Ruby. Выберите комплект разработчика для своей версии Ruby и операционной системы. Распаковать комплект для разработки в C:\RubyDevKit

# 1. Смените каталог на C:\RubyDevKit и введите
# > ruby ​​dk.rb init

# 2. Откройте файл config.yml и добавьте следующую строку сразу после «—» (тройной дефис), если ее там еще нет:
# – c:/Ruby200-x64 (не копируйте и не вставляйте, просто введите дефис, пробел и затем введите твой путь)

# 3. Установка ruby ​​dk.rb. Пример вывода:
# [ИНФОРМАЦИЯ] Обновление переопределения гем-уведомления для 'c:/Ruby200-x64'
# [ИНФОРМАЦИЯ] Установка 'c:/Ruby200-x64/lib/ruby/site_ruby/devkit.rb'

# > gem update --system                 # обновить RubyGems до последней версии(помогает избежать некоторых ошибок)



puts '                                   Установка, обновление SSL-сертификатов'

# Если у вас нет SSL-сертификатов, то некоторые из гемов не будут работать (например, если они обращаются к серверу через https, например, хипчат).

# Чтобы обновить/установить ваши SSL-сертификаты - запустите этот скрипт(ниже), чтобы загрузить cacert.pem. Убедитесь, что вы добавили переменную SSL_CERT_FILE в свою среду, указывающую на загруженный файл cacert.pem.

require 'net/http'

def ssl_add # метод просто чтобы не запустить случайно
  ruby_install_dir = 'e:\programs\Ruby31-x64'
  cacert_file = "#{ruby_install_dir}\\cacert.pem"

  Net::HTTP.start("curl.haxx.se") do |http|
    resp = http.get("/ca/cacert.pem")
    if resp.code == "200"
      open(cacert_file, "wb") { |file| file.write(resp.body) }
      puts "\n\nA bundle of certificate authorities has been installed to"
      puts "#{cacert_file}\n"
      puts "* Please set SSL_CERT_FILE in your current command prompt session with:"
      puts "     set SSL_CERT_FILE=#{cacert_file}"
      puts "* To make this a permanent setting, add it to Environment Variables"
      puts "  under Control Panel -> Advanced -> Environment Variables"
    else
      abort "\n\n>>>> A cacert.pem bundle could not be downloaded."
    end
  end
end

















#
