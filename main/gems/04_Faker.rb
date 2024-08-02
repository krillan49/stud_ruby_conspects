puts '                                               Faker'

# https://github.com/faker-ruby/faker

# faker - это гем для генерации случайного текста. Имеет множество различных генераторов для обпределенного стиля(слэнга), длинны и других характеристик. Хорошо подходит для заполнения например статей при разработке блога, для применения в тестировании, так же может использоваться и в автотестах.

# gem 'faker' поместить в Gemfile подключается в разработку и тест(тк вряд ли понадобится в продакшене).
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


# Пример применения:
title = Faker::Hipster.sentence(word_count: 3)
# Для заголовка генерируем название 3х слов(??)
body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
# Для тела нашего вопроса генерируем 5 предложений














#
