puts '                                                RBENV'

# https://github.com/rbenv/rbenv


# ДЛЯ RBENV
# https://help.dreamhost.com/hc/en-us/articles/360001435926-Installing-OpenSSL-locally-under-your-username до 11 шага, затем
# RUBY_CONFIGURE_OPTS=--with-openssl-dir=$HOME/.openssl/openssl-1.1.1g (путь куда положили правильно написать) перед rbenv install (asdf install)
# Ну, у нас версия сейчас посвежее, то есть 3.1.2, но должно быть актуально.



# Убрать системный руби и поставит rbenv в качестве менеджера версий (там, баг странный ruby-build какой-то кривой ставится из апта/пакмана, поэтому нужно руками его ставить с гитхаба хз, исправили ли сейчас)
# sudo apt update && \
# sudo apt purge ruby-full -yqq && \
# sudo apt install git rbenv -yqq && \
# sudo apt purge ruby-build -yqq && \
# git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build && \
# exec $SHELL -l

# затем просто писать:
# rbenv install <версия>

# (хз зачем ??)
# sudo apt install libyaml -y













# 
