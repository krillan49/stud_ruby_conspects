puts '                                            Locking(AR)'

# Locking - это временная защита записи в таблице БД от одновременного множественного доступа/изменения разными пользователями. Например 2 пользователя могут попытаться отредактировать одну и ту же запись с разницей в несколько секунд, чтобы защититься от этого и сохранить в БД только одно изменение и нужен locking

# https://api.rubyonrails.org/classes/ActiveRecord/Locking.html

# locking бывает 2х типов: optimistic и pessimistic


puts
puts '                                         Optimistic locking'

# https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html

# Optimistic locking - не запрещает множесвенный доступ на редактирование к одной и той же записи, но сохрангяет в БД изменения только первого по времени пользователя, а следующим выдает ошибку ActiveRecord::StaleObjectError. Например в своей игре 2 пользователя нажимают кнопку, но функционал для ответа на вопрос получает только тот кто 1й нажал.


puts
puts '                                         Pessimistic locking'

# https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html
