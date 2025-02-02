puts '                                        Тестирование API'

# При тестировании API отправлять запросы на реальный API не очень удобно, тк тесты обращающиеся к стороннему API могут работать медленно или ломаться если сторонний API будет недоступен, так же API может ограничивать количество запросов. Потому нужен функционал(заглушка), который будет симулировать ответ API на фэйковый запрос.

# Webmock - библиотека, которая позволяет создавать заглушки ответа от сервера, например с API, которые удобно использовать в тестах

# VCR - библиотека, которая при первом запуске тестов делает реальный запрос к серверу, затем запрос и ответ сохраняются в отдельный фаил который называется "кассета" и последующие вызовы тестов используют ее чтобы симулировать новые запросы.
# https://github.com/vcr/vcr



puts '                                             Webmock'

# https://github.com/bblimke/webmock

# Webmock - библиотека, которая позволяет создавать заглушки ответа от сервера, например с API, которые удобно использовать в тестах. Запрещает отправку реальных запросов в тестах и выдает на такое ошибку с описанием (можно настроить, чтобы разрешал)

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



puts '                                         Webmock: Тестирование API'

# Симитируем POST-запрос на API https://api.funtranslations.com/, задав предполагаемый ответ при помощи Webmock, чтобы протестировать метод из фаила api.rb, который посылает запрос и получает смешной перевод в стиле Мастера Йоды,

RSpec.describe 'translate' do
  it 'translates as yoda' do
    text = 'Master Obi Wan lost a planet' # данные для метода translate

    # Далее используем webmock заглушку симулирующую ответ от API на фэйковый запрос:

    # данные иммитирующие ответ сервера, которые мы как бы получим в ответ на запрос, соответсвующие данным, которые присылает обычно https://api.funtranslations.com/
    data = {
      success: { total: 1 },
      contents: {
        translated: 'A planet, master Obi Wan lost',
        text: text,
        translation: 'yoda'
      }
    }

    # stub_request - метод webmock который создает заглушку(? для метода вызываемого в этом тесте, который посылает запросы ?)
    stub_request(
      :post, 'https://api.funtranslations.com/translate/yoda.json'
      # параметры при которых заглушка будет работать, тоесть сработет только при пост-запросе на этот ЮРЛ
    )
    .with(body: { text: text })                      # данные которые отправляем "на сервер"
    .to_return(status: 200, body: JSON.dump(data))   # ответ, который "вернет" сервер в формате JSON

    # Используем метод, посылающий запрос, для которого сработает заглушка webmock, вместо реального запроса
    translation = translate(:yoda, text) # передаем эндпоинт и текст

    # Ну и собственно проверяем методы из класса Translation при помощи матчеров, вернутся ли нам ответы заданные для webmock
    expect(translation['contents']['translated']).to eq('A planet, master Obi Wan lost')
  end
end


# Если тест не пройдет Webmock даст развернутый ответ почему не прошел и посоветует исправления(на хедеры при проверке ему пофиг, если мы их явно не проверяем, так что можно игнорить совет добавить их)
#=>
# Failure/Error: translation = translate(:yoda, text)
#
#      WebMock::NetConnectNotAllowedError:
#        Real HTTP connections are disabled. Unregistered request: POST https://api.funtranslations.com/translate/yoda.json with body 'text=Master Obi Wan lost a planet' with headers {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v2.9.2'}
#
#        You can stub this request with the following snippet:
#
#        stub_request(:post, "https://api.funtranslations.com/translate/yoda.json").
#          with(
#            body: {"text"=>"Master Obi Wan lost a planet"},
#            headers: {
#           'Accept'=>'*/*',
#           'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
#           'Content-Type'=>'application/x-www-form-urlencoded',
#           'User-Agent'=>'Faraday v2.9.2'
#            }).
#          to_return(status: 200, body: "", headers: {})
#
#        registered request stubs:
#
#        stub_request(:post, "https://api.funtranslations.com/translate/yod.json").
#          with(
#            body: {"text"=>"Master Obi Wan lost a planet"})















#
