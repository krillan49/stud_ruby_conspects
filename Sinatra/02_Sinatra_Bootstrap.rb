puts '                                           Sinatra + CSS'

# фаил стилей styles.css(название можно любое) создаем в папке public(например public/css/styles.css)



puts '                                          sinatra-bootstrap'

# Можно подключить и обычным способом, через CDN(сеть доставки контента/content delivery network). Это сервера(в разных локациях для скорости загрузки) хранящие необходимые фаилы

# https://getbootstrap.com/docs/5.3/getting-started/download/  (возможно инфа по совместимости с Руби)


# Обычная установка гема:
# > gem install sinatra-bootstrap


# Установка с Гитхаба
# https://github.com/bootstrap-ruby/sinatra-bootstrap
# Клонируем репозиторий sinatra-bootstrap(Можно его потом переименовать как нам нужно):
# > git clone https://github.com/bootstrap-ruby/sinatra-bootstrap.git
# Из каталога получившегося каркаса приложения:
# > bundle install
# Запуск с нужными версиями гемов:
# > bundle exec ruby app.rb

#(!!! bundle exec ruby app.rb не запускается и выдает какието ошибки но просто ruby app.rb заходит)
#( решение? https://github.com/rapid7/metasploit-framework/issues/14746 https://rubygems.org/gems/bundler)

# В итоге мы получаем заготовку с готовыми элементами кода для сайта который захотим делать.










#
