RSpec.describe FunTranslations::Client do # тестируем класс клиента FunTranslations::Client

  describe '#translate' do # тестируем основной метод translate
    it 'translates as yoda' do
      text = 'Master Obi Wan lost a planet'
      # Но мы не можем просто взять и вызвать этот метод, тк с бесплатным тарифным планом в час можно сделать всего лишь 5 запросов, что не позволит нормально тестировать, отправляя запросы на реальный API. Потому используем webmock заглушку симулирующую ответ от API на фэйковый запрос.
      translated = 'A planet, master Obi Wan lost'
      data = { # данные имитирующие ответ сервера, которые мы как бы получим в ответ на запрос, соответсвующие данным, которые присылает обычно https://api.funtranslations.com/
        success: {total: 1},
        contents: {
          translated: translated,
          text: text,
          translation: 'yoda'
        }
      }
      # stub_request - метод webmock который создает заглушку
      stub_request(
        :post, 'https://api.funtranslations.com/translate/yoda.json'
        # параметры при которых заглушка будет работать, тоесть сработет только при пост-запросе на этот ЮРЛ
      )
      .with(body: {text: text}) # данные которые отправляем "на сервер"
      .to_return(status: 200, body: JSON.dump(data)) # ответ, который "вернет" сервер

      # создаем клиент через метод test_client(?? хз зачем если он делает все тоже, просто чтобы не писать вручную 'FunTranslations.client token' ??) и отправляем запрос который будет принимать webmock
      translation = test_client.translate(:yoda, text) # передаем эндпоинт и текст

      # Ну и собственно проверяем методы из класса Translation при помощи матчеров, вернутся ли нам ответы заданные для webmock
      expect(translation.translated_text).to eq(translated)
      expect(translation.original_text).to eq(text)
      expect(translation.translation).to eq('yoda')
    end

    it 'translates as morse audio' do # протестируем случай, когда есть запрос на аудиофаил
      text = 'Welcome'
      audio = 'data:audio/wave;base64,UklGRjiBCQBXQVZFZm1' # закодированное аудио
      data = {
        success: {total: 1},
        contents: {
          translated: {audio: audio},
          text: text,
          translation: {
            source: 'english',
            destination: 'morse audio'
          }
        }
      }

      stub_request(
        :post,
        'https://api.funtranslations.com/translate/morse/audio.json'
      ).with(body: {text: text}).to_return(status: 200, body: JSON.dump(data))

      translation = test_client.translate 'morse/audio', text
      expect(translation.audio).to eq(audio)
      expect(translation.original_text).to eq(text)
      expect(translation.translation['destination']).to eq('morse audio')
    end

    it 'translates as yoda with token' do # протестируем случай, когда есть токен на платную версию
      text = 'Master Obi Wan lost a planet'
      translated = 'A planet, master Obi Wan lost'
      data = {
        success: {total: 1},
        contents: {
          translated: translated,
          text: text,
          translation: 'yoda'
        }
      }
      # Тут добавим заголовки, тк токен передается в них:
      stub_request(:post,'https://api.funtranslations.com/translate/yoda.json')
      .with(
        body: {text: text},
        headers: {
          'X-Funtranslations-Api-Secret' => 'my token',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'User-Agent' => "fun_translations gem/#{FunTranslations::VERSION}"
        }
      ).to_return(status: 200, body: JSON.dump(data))

      translation = test_client('my token').translate :yoda, text  # с передачей токена в клиент
      expect(translation.translated_text).to eq(translated)
      expect(translation.original_text).to eq(text)
      expect(translation.translation).to eq('yoda')
    end

  end
end












#
