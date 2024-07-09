RSpec.describe FunTranslations::Error do # тоесть проверяем класс исключений
  include FunTranslations::Request # импортируем модуль, чтобы использовать его метод post для отправки запросов

  it 'handles error 400' do # проверим код ошибки 400
    # так же воспользуемся webmock для симуляции запроса и ответа
    data = {
      error: {
        code: 400, # часть тела ответа, которая вернется в JSON, тоесть сообщение о коде а не сам код
        message: 'Bad Request: text is missing.'
      }
    }
    stub_request(
      :post,
      'https://api.funtranslations.com/translate/yoda.json'
    ).to_return(
      status: 400, # сам HTTP error code который вернется в ответе
      body: JSON.dump(data)
    )
    expect do
      post(
        '/translate/yoda.json',
        test_client,
        text: nil
      )
    end.to raise_error(
      described_class::BadRequest,
      'Bad Request: text is missing.'
    )
  end

  it 'handles error 404' do
    data = {
      error: {
        code: 404,
        message: 'Not Found'
      }
    }
    stub_request(
      :post,
      'https://api.funtranslations.com/translate/fake.json'
    ).to_return(
      status: 404, # HTTP error code
      body: JSON.dump(data)
    )
    expect do
      post(
        '/translate/fake.json',
        test_client,
        text: ''
      )
    end.to raise_error(
      described_class::NotFound,
      'Not Found'
    )
  end

  it 'handles unknown error' do
    data = {
      error: {
        code: 430, # код от балды, которого нет в наших исключениях
        message: 'Unknown error'
      }
    }
    stub_request(
      :post,
      'https://api.funtranslations.com/translate/yoda.json'
    ).to_return(
      status: 430, # HTTP error code
      body: JSON.dump(data)
    )
    expect do
      post(
        '/translate/yoda.json',
        test_client,
        text: 'text'
      )
    end.to raise_error(described_class, 'Unknown error')
  end
end
