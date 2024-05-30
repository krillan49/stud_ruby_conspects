puts '                                               Faker'

# (!! потом переписать его в отдельный фаил, тк это универсальный гем а не только для веба или Рэилс)

# https://github.com/faker-ruby/faker

# faker - это гем для генерации случайного текста. Имеет множество различных генераторов для обпределенного стиля(слэнга), длинны и других характеристик. Хорошо подходит для заполнения например статей при разработке блога, для применения в тестировании, так же может использоваться и в автотестах.

# gem 'faker' поместить в Gemfile для Рэилс или Синатры в разработку и тест(тк вряд ли понадобится в продакшене).
group :development, :test do
  gem 'faker', '~> 3'
end
# > bundle install

require 'faker' # подключаем(в Рэилс не надо)

Faker::Lorem # например генератор для текста "lorem ipsum ..."

# Примеры методов
Faker::Name.name                      #=> "Christophe Bartell"
Faker::Address.full_address           #=> "5479 William Way, East Sonnyhaven, LA 63637"
Faker::Markdown.emphasis              #=> "Quo qui aperiam. Amet corrupti distinctio. Sit quia *dolor.*"
Faker::TvShows::RuPaul.queen          #=> "Violet Chachki"
Faker::Alphanumeric.alpha(number: 10) #=> "zlvubkrwga"
Faker::ProgrammingLanguage.name       #=> "Ruby"


puts
puts '                                              db/seeds.rb'

# db/seeds.rb - этот фаил нужен для того чтобы писать скрипты, которые добавляют демоданные в приложение, так же эти скрипты можно писать в миграции, но правильнее всетаки в seeds.rb

# Сюда лучше всего добавить генераторы фэйкера, чтобы заполнить ими вопросы для askit/questions

# В db/seeds.rb напишем скрипт
30.times do # так мы сгенерируем 30 вопросов
  title = Faker::Hipster.sentence(word_count: 3)
  # Для заголовка генерируем название 3х слов(??)
  body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
  # Для тела нашего вопроса генерируем 5 предложений
  Question.create title: title, body: body
  # Создаем сущность со сгенерированными данными
end
# > rails db:seed       -  команда которая применит скрипт(если выдает пустую строку значит все успешно)













#
