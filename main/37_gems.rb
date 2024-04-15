puts '                                        Gem. Std-lib. RubyGems'

# В других языках gem’ы называются библиотеками (library) или пакетами (package).

# Std-lib (стандартные библиотеки) - входят в базовую комплектацию Руби
# Gems (пользовательские библиотеки) -  те что пишут сами пользователи

require 'gemname' # загрузка гема в память с вашего диска (установленные gem’ы не загружаются по-умолчанию, для быстродействия)
# require - требовать

# RubyGems - прграмма для работы с библиотеками в Ruby. Она устанавливается вместе с Ruby. Так же автоматически устанавливается несколькр основных библиотек.

# gem -v        проверить версию RubyGems
# gem update --system      обновить RubyGems до последней версии(помогает избежать некоторых ошибок)


puts
puts '                                           Установка gem’ов'

# https://rubygems.org/gems     большинство(все?) гемы хранятся тут, отсюда и качаются командой gem install, сюда надо хостить и собственные гемы чтобы их могли юзать
# https://www.ruby-toolbox.com/    база данных о всех необходимые гемы, лучше всего смотреть информацию о гемах тут


# Для установки gem’а используется команда gem, которая является частью пакета языка руби (также как и irb и ruby).
# Гемы устанавливаются в специальные директории Руби выделенные для библиотек

# > gem install gemname  -  скачивание из интернета и установка гема
# > gem list  -  список всех установленных гемов


# Пример установки на gem’е Cowsay
# > gem install cowsay  #(Windows)
# $ gem install cowsay  #(Linux, Mac)
# запуск > cowsay "какой-то текст"


puts
puts '                                              Разные Std-lib'

# 1. ipaddr
require 'ipaddr'

# Проверка корректности айпи ipv4(от 0.0.0.0 до 255.255.255.255)
IPAddr.new('0.0.0.0').ipv4? #=> true
IPAddr.new('255.255.255.255').ipv4? #=> true
IPAddr.new('0.0.0.1000').ipv4? #=> invalid address:  (IPAddr::InvalidAddressError)


# 2. digest
require 'digest'

# Хэширование MD%5(https://ruby-doc.org/stdlib-3.0.0/libdoc/digest/rdoc/Digest/MD5.html)
Digest::MD5.hexdigest('12345') #=> "827ccb0eea8a706c4c34a16891f84e7b"   # хэширование
# Взлом MD5 перебором для 5значных пинкодов состоящих только из цифр
hashmd5 = "827ccb0eea8a706c4c34a16891f84e7b"
('00000'..'99999').find{|pin| Digest::MD5.hexdigest(pin) == hashmd5} #=> "12345"

# Хэширование SHA2 https://ruby-doc.org/stdlib-2.4.0/libdoc/digest/rdoc/Digest/SHA2.html
hashsha2 = Digest::SHA2.hexdigest('code') #=> '5694d08a2e53ffcae0c3103e5ad6f6076abd960eb1f8a56577040bc1028f702b'
# Взлом SHA2 перебором
('a'..'zzzzz').find{|code| Digest::SHA2.hexdigest(code) == hashsha2} #=> "code"


puts
puts '                                          Gemfile и Gemfile.lock'

# В Rails(или еще гдето), достаточно поместить gem в специальный список (Gemfile), и все gem’ы из этого списка будут загружены в память автоматически.

# Gemfile - (название именно такое без расширений) это фаил с инструкциями по установке гемов необходимых для приложения


# Пример содержания фаила Gemfile(в данном случае для приложения на Синатре с ActiveRecord)
source "https://rubygems.org"

gem "sinatra"
gem "sinatra-contrib"  # этот гем содержит sinatra-reloader(на самом деле это тоже разработческий гем и соотв можно поместить в group :development и его тоже)
gem "sqlite3"
gem "activerecord"
gem "sinatra-activerecord"
gem "rake"

group :development do # означает, что когда мы зальем приложение на хостинг, будет понятно что этот гем нужен исключительно для разработки, а не для работы приложения, поэтому в продакшен режиме он будет пропущен
  gem "tux"
end

# bundle install  - установка(из активной директории в которой лежит Gemfile) (может немного тупить) Устанавливает те гемы из Gemfile которых у нас нет, сообщает о тех что уже есть.

# После установки в фаиле Gemfile.lock (Нужно создать заранее??) появятся записи. Они нужны для того чтоб в нашем приложении не было конфликта различных версий гемов (в этом фаиле были внесены и залочены определенные версии гемов)

# > bundle install      - устанавливает гемы, указанные в Gemfile проекта, учитывая указанные версии
# > bundle i            - тоже самое что и bundle install
# > bundle              - тоже самое что и bundle install, раньше этого не было
# > bundle update
# > bundle outdated     - проверить какие библиотеки в нашем приложении можно обновить
# > bundle out          - алиас для outdated
# > bundle exec some    - запускает что либо(тут some) с набором именно тех гемов что есть в гемфаиле














#
