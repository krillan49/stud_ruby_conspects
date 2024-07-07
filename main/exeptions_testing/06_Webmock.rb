puts '                                        Тестирование API'

# При тестировании API отправлять запросы на реальный API не очень удобно, тк тесты обращающиеся к стороннему API могут работать медленно или ломаться если сторонний API будет недоступен, так же API может ограничивать количество запросов. Потому нужен функционал, который будет симулировать ответ API(заглушка симулирующая ответ) на фэйковый запрос.

# Webmock - библиотека, которая позволяет создавать заглушки ответа от сервера, например с API, которые удобно использовать в тестах

# VCR - библиотека, которая при первом запуске тестов делает реальный запрос к серверу, затем запрос и ответ сохраняются в отдельный фаил который называется "кассета" и последующие вызовы тестов используют ее чтобы симулировать новые запросы.
# https://github.com/vcr/vcr



puts '                                             Webmock'

# https://github.com/bblimke/webmock

# Webmock - библиотека, которая позволяет создавать заглушки ответа от сервера, например с API, которые удобно использовать в тестах. Запрещает отправку реальных запросов в тестах и выдает на такое ошибку с описанием (хотя можно настроить, чтобы разрешал)

# > gem install webmock

# Gemfile:
group :test do
  gem "webmock"
end

# Подключение для RSpec. Подключаем в spec/spec_helper:
require 'webmock/rspec'
# Подключение для Cucumber. Create a file features/support/webmock.rb with the following contents:
require 'webmock/cucumber'
# Подключение для MiniTest. Add the following code to test/test_helper:
require 'webmock/minitest'
# Подключение для Test::Unit. Add the following code to test/test_helper.rb
require 'webmock/test_unit'
# Подключение для Outside a test framework. You can also use WebMock outside a test framework:
require 'webmock'
include WebMock::API
WebMock.enable!


puts
puts '                                         Webmock: Тестирование API'

# Симитируем POST-запрос на API https://api.funtranslations.com/, чтобы получить смешной перевод в стиле Мастера Йоды, задав предполагаемый ответ при помощи Webmock, чтобы протестировать метод из фаила api.rb

RSpec.describe 'translate' do
  it 'translates as yoda' do
    text = 'Master Obi Wan lost a planet'
    # используем webmock заглушку симульрующую ответ от API на фэйковый запрос.
    data = { # данные имитирующие ответ сервера, которые мы как бы получим в ответ на запрос, соответсвующие данным, которые присылает обычно https://api.funtranslations.com/
      success: {total: 1},
      contents: {
        translated: 'A planet, master Obi Wan lost',
        text: text,
        translation: 'yoda'
      }
    }

    # stub_request - метод webmock который создает заглушку
    stub_request(
      :post, 'https://api.funtranslations.com/translate/yoda.json'
      # параметры при которых заглушка будет работать, тоесть сработет только при пост-запросе на этот ЮРЛ
    )
    .with(body: {text: text})  # данные которые отправляем "на сервер"
    .to_return(status: 200, body: JSON.dump(data)) # ответ, который "вернет" сервер

    # отправляем запрос который будет принимать webmock
    translation = translate(:yoda, text) # передаем эндпоинт и текст

    # Ну и собственно проверяем методы из класса Translation при помощи матчеров, вернутся ли нам ответы заданные для webmock
    expect(translation.translation).to eq('yoda')
  end
end















#
