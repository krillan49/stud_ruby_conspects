puts '                                                 Vargant'

# ! Вагрантом пользовались только для разработки для воспроизводства производственной среды. docker - решение, одинаковое и для промышленного развертывания и для разработки. Он круче, вокруг него экосистема на порядок сильнее (в том числе коммерческая), он нативен на linux без виртуальных машин. Как только Docker получил популярность, про вагрант - все сразу забыли. Но если нужно оперировать виртуалками с операционными системами отличными от linux, вагрант может быть полезен.

# Виртуальная машина на линуксе(для запуска на любой системе) - туда установятся(bootstrap.sh - просто похожее название) Руби, Рэилс, СУБД и еще много всякого что нужно

# поставить виртуал бокс и Vargant и установить рэилс дев бокс по инструкции

# https://github.com/rails/rails-dev-box   # rails-dev-box  -  способ настройки среды
# https://www.virtualbox.org/
# https://www.vagrantup.com/    # Vargant

# host $ git clone https://github.com/rails/rails-dev-box.git
# host $ cd rails-dev-box
# host $ vagrant up
# (vagrant up - будет создана виртуальная машина с линуксом)

# host $ vagrant ssh
# Welcome to Ubuntu 22.10 (GNU/Linux 5.19.0-21-generic x86_64)
# ...
# vagrant@rails-dev-box:~$
# (входим в консоль виртуальной машины)

# Создастся виртуальная машина Линукс и когда мы зайдем в браузере на порт 3000 то его запустит виртуальная машина


puts
puts '                                               virtualbox'

# https://www.virtualbox.org/wiki/Downloads

# https://ubuntu.com/download/desktop


puts
puts '                                   Docker(отредактировать из Docker.txt)'


















#
