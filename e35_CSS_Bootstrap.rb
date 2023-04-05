puts '                                               Sinatra + CSS'

# фаил стилей styles.css(название можно любое например main.css) создаем в папке public(например public/css/styles.css)
# (!!! Спросить\погуглить почему так и не считывает с диска)фаил стилей в папке public, нужно сохранять во время работы синатры для данного конкретного фаила .rb, либо после перезапуска синатры в другом каталоге с другими фаилами .rb а иначе она не воспримет изменения(похоже оставляет фамл гдето у себя в памяти)


puts
puts '                                                Bootstrap'

# https://getbootstrap.com/docs/5.3/getting-started/download/  (возможно инфа по совместимости с Руби)


# (команда из комментов к уроку(gem install sinatra-bootstrap))

# Подключение:

# Способ 1: CDN
# CDN - это сеть доставки контента(content delivery network). Это сервера(в разных локациях для скорости загрузки) хранящие необходимые фаилы

# Способ 2(лучше тк специальный для для синатры): https://github.com/bootstrap-ruby/sinatra-bootstrap(https://github.com/krdprog/rubyschool-notes/blob/master/one-by-one/lesson-21.md)
# В каталоге кторый нам нужен(например app) выполняем команды из ссылки:
# 1.  git clone https://github.com/bootstrap-ruby/sinatra-bootstrap.git
	#(клонируются все необходимые фаилы в каталоге sinatra-bootstrap в наш каталог)
# 2.  mv sinatra-bootstrap/ app
	#(app тут название каталога ? хз зачем это не делал)
# 3.  cd app
	#(меняем каталог если мы не в нем)
# 4.  bundle install
	#(!!!запускаем из каталога sinatra-bootstrap)
	#(bundle - переводится "связка/комплект/упаковка" bundle install устанавливаем пакет гемов(в том числн синатру) определенных версий(указаны в gemfile.lock фаиле), чтобы не было конфликтов с нашими гемами других версий которые используются)
# 5.  bundle exec ruby app.rb
	# (это способ запуска фаила app.rb(запускаем из каталога sinatra-bootstrap) с теми гемами что мы установили в bundle, а не с нашими гемами)
#(!!! bundle exec ruby app.rb не запускается и выдает какието ошибки но просто ruby app.rb заходит)
#( решение? https://github.com/rapid7/metasploit-framework/issues/14746 https://rubygems.org/gems/bundler)

# В итоге мы получаем заготовку с готовыми элементами кода для сайта который захотим делать далее будем дописывать что на нужно в фаил app.rb и в представления из views. Заходить на сайт бутстрепа и добавлять оттуда нужные нам элементы.










#
