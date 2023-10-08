puts '                                           Отправка e-mail'

# У отправки имэила(Transactional emails) непростая структура. Для отправки необходимо обратиться к серверу и нужно гдето его взять.
# Transactional emails - имэйлы которые реагируют на определенные события в нашем сайте(напр пользователь написал коммент)

# SMTP-сервер. Где его взять:
# 1. администратор нашей компании - лучший вариант, не нужно ебаться
# 2. хостинг - (плохой варик)большой процент попадания в спам. если мы отправляем много сообщений, хостинг может послать нах
# 3. gmail - надо включить options, есть ограничения по количесву писем в день, иначе лавочку закроет

# postmarkapp (платно) - для Transactional emails, но через него нельзя делать почтовую рассылку. Письма должны быть с кнопкой Unsubscribe, чтобы не попасть в черный список. Не использует ActionMailer::Base из Рэиллс, тк сервер не SMTP(хотя может) а через данный сайт.


# bulk email messaging - для рассылки

# Если перепутать Transactional emails и bulk email, то IP адрес может попасть в черный список


# https://postmarkapp.com/developer/user-guide/sending-email/sending-with-api
# https://github.com/wildbit/postmark-gem
# https://github.com/wildbit/postmark-rails
# http://rusrails.ru/action-mailer-basics
# https://www.youtube.com/watch?v=FNOhpAWbiKA
# https://github.com/mikel/mail
