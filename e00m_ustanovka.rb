puts '                                    Установка и настройка Ruby под windows'

# DevKit(нужен для установки гемов?) установка если до того установлена версия руби без девкита:
# https://rubyinstaller.org/downloads/

# https://vimeo.com/103270896   19й урок

# Настройка Руби под винду  -   https://putshello.wordpress.com/2014/08/03/installing-ruby-for-windows-the-right-way/ (проблемы с путнктами 7 и 9)

# 1. Установите Ruby с помощью установщика Ruby . Выберите свою версию. Я использую последнюю версию (2.0, когда пишу этот пост). Выберите свою операционную систему: 32 или 64 бит. В этом руководстве я использую x64-версию Ruby, установленную в C:\Ruby200-x64.

# 2. Убедитесь, что вы обновили переменную PATH, указывающую на: «C:\Ruby200-x64\bin» (без кавычек). Нажмите Win+R, введите cmd , затем введите irb . У вас должен быть irb на вашем пути. Введите ruby ​​-v , чтобы показать версию ruby. Примечание: если вы используете Far Commander или другие коммандеры, вам может потребоваться перезапустить это приложение.

# 3. Ruby установлен, пришло время установить гемы. Прежде чем вы сможете установить драгоценные камни, вам необходимо установить комплект разработчика. Перейдите на страницу загрузки установщика Ruby . Выберите комплект разработчика для своей версии Ruby и операционной системы. Распаковать комплект для разработки в C:\RubyDevKit

# 4. Смените каталог на C:\RubyDevKit с помощью вашего любимого файлового менеджера (у меня Far Commander) или через cmd и введите ruby ​​dk.rb init

# # 5. Откройте файл config.yml и добавьте следующую строку сразу после «—» (тройной дефис), если ее там еще нет:
# – c:/Ruby200-x64 (не копируйте и не вставляйте, просто введите дефис, пробел и затем введите твой путь)

# 6. Запустите установку ruby ​​dk.rb. Вот пример вывода:
# [ИНФОРМАЦИЯ] Обновление переопределения гем-уведомления для 'c:/Ruby200-x64'
# [ИНФОРМАЦИЯ] Установка 'c:/Ruby200-x64/lib/ruby/site_ruby/devkit.rb'

# 7. Теперь можно устанавливать гемы. Попробуйте установить hipchat gem: gem install hipchat . Если все в порядке, вы почти закончили. Попробуйте установить драгоценные камни .

# 8. Если у вас по-прежнему возникают ошибки при установке гемов, попробуйте
# gem update --system

# 9. Теперь вам нужно обновить ваши SSL-сертификаты. На данный момент у вас нет SSL-сертификатов, поэтому есть большое изменение, заключающееся в том, что некоторые из ваших драгоценных камней не будут работать (например, если они обращаются к серверу через https, например, хипчат). Теперь пришло время установить эти сертификаты. Запустите этот скрипт(ниже) , чтобы загрузить cacert.pem. Убедитесь, что вы добавили переменную SSL_CERT_FILE в свою среду, указывающую на загруженный файл cacert.pem.

# require 'net/http'
#
# ruby_install_dir = 'e:\programs\Ruby31-x64'
# cacert_file = "#{ruby_install_dir}\\cacert.pem"
#
# Net::HTTP.start("curl.haxx.se") do |http|
#   resp = http.get("/ca/cacert.pem")
#   if resp.code == "200"
#     open(cacert_file, "wb") { |file| file.write(resp.body) }
#     puts "\n\nA bundle of certificate authorities has been installed to"
#     puts "#{cacert_file}\n"
#     puts "* Please set SSL_CERT_FILE in your current command prompt session with:"
#     puts "     set SSL_CERT_FILE=#{cacert_file}"
#     puts "* To make this a permanent setting, add it to Environment Variables"
#     puts "  under Control Panel -> Advanced -> Environment Variables"
#   else
#     abort "\n\n>>>> A cacert.pem bundle could not be downloaded."
#   end
# end
