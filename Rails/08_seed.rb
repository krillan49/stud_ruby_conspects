puts '                                            db/seeds.rb'

# db/seeds.rb - этот фаил нужен для того чтобы писать скрипты, которые добавляют данные в БД. Так же эти скрипты можно писать в миграции, но правильнее в seeds.rb

# Дает возможность изменить какие-то записи в БД или заполнить БД начальными данными при деплое, например админской ролью для стартового админа или данными для проверки работы приложения

# Использовать скрипт db/seeds.rb:
# > rails db:seed



puts '                                          Примеры скриптов'

# Если в db/seeds.rb уже есть код прошлых скриптов, когда мы хотим написать новые, то стоит их удалить или закомментировать, чтобы они не отработали повторно вместе с новым скриптом


# 1. Скрипт создания сущности/строки Item в БД
# db/seeds.rb:
item = Item.create title: 'Version 1' # собственно создаем сущьность
puts item.inspect                     # можно при засеивании отобразить какой-то вывод в консоли
# Далее выполняется команда для запуска скрипта, чтобы загрузить данные в БД:
# > rails db:seed
# Если выдает пустую строку(кроме нашего кастомного вывода) значит все данные загружены успешно:=


# 2. Скрипт, чтобы добавить начальных пользователей и роли(если они хранятся в БД)
# db/seeds.rb:
User.create(email: "admin@mail.ru", username: "admin", password: '123456', password_confirmation: '123456', admin: true)
# > rake db:seed


# 3. Скрипт, чтобы добавить/изменить что-то в уже существующих записях
# db/seeds:
User.find_each do |u| # тоесть итерируем каждого юзера:
  u.send(:set_gravatar_hash) # применим к юзерам метод модели set_gravatar_hash (через send чтобы обойти private)
  u.save                     # сохраняем юзера(обновляем его запись в БД)
end
# > rails db:seed



puts '                             Пример скрипта с очисткой БД перед заполнением'

# Скрипт очищает БД и создает 1 продавца и 1 приглашенного им через кабинет и приглашение менеджера


# db/seeds:
require 'securerandom' # для генерации токенов

puts  "Очистка данных..." # ?? чтобы выделять в логах и было видно что создается и после чего ошибки ??

CabinetAccess.delete_all
Invitation.delete_all
Manager.delete_all
Cabinet.delete_all
Seller.delete_all

# Сброс последовательностей ID (PostgreSQL) ??ключи и индексы, которые не удаляютмя и так??
%w[cabinet_accesses invitations managers cabinets sellers].each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

puts "Создание продавца..."

seller = Seller.create!(
  email: "seller@example.com",
  password: "123456",
  password_confirmation: "123456",
  name: "Kroker",
  phone: "+79991234567"
)

puts "Создание кабинета..."

cabinet = Cabinet.create!(
  name: "Главный кабинет",
  wb_api_token: SecureRandom.hex(16),
  seller: seller
)

puts "Создание приглашения..."

manager_email = "manager@example.com"

invitation = Invitation.create!(
  email: manager_email,
  token: SecureRandom.hex(10),
  cabinet: cabinet,
  seller: seller,
  role: "admin"
)

puts "Создание менеджера..."

manager = Manager.create!(
  email: manager_email,
  password: "123456",
  password_confirmation: "123456",
  name: "Gonzik",
  phone: "+79997654321"
)

puts "Привязка менеджера к кабинету..."

CabinetAccess.find_or_create_by!(
  manager: manager,
  cabinet: cabinet,
  invitation: invitation
)

puts "Готово!"
puts "  Seller: #{seller.email}"
puts "  Cabinet: #{cabinet.name}"
puts "  Manager: #{manager.email}"



puts '                                               Faker'

# https://github.com/faker-ruby/faker

# faker - гем для генерации случайного текста. Имеет множество различных генераторов для определенного стиля(слэнга), длинны и других характеристик. Хорошо подходит для заполнения например статей при разработке блога, для применения в тестировании, так же может использоваться и в автотестах.

# Gemfile:
group :development, :test do
  gem 'faker', '~> 3'
end
# > bundle install

# В db/seeds.rb добавим генераторы фэйкера, чтобы заполнить ими вопросы для askit/questions
30.times do # сгенерируем 30 вопросов
  title = Faker::Hipster.sentence(word_count: 3)
  # Для заголовка генерируем название 3х слов(?? Или от 1 до 3х слов)
  body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
  # Для тела нашего вопроса генерируем 5 предложений
  Question.create title: title, body: body
  # Создаем сущность со сгенерированными данными
end
# > rails db:seed
















#
