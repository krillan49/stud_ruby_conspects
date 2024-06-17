module FunTranslations
  class Translation
    # методы которые будет вызывать пользователь, для просмотра данных ответа
    attr_reader :translated_text, :original_text, :translation, :audio, :speed, :tone

    def initialize(raw_translation) # raw_translation - хэш вида: {"translated": "Force be with you my padawan!", "text": "Hello my padawan!",  "translation": "yoda" } принятый в методе translate класа Client
      if raw_translation['translated'].respond_to?(:key?) && raw_translation['translated'].key?('audio') # проверяем содержит ли ответ аудио(закодированное), тк тогда в разделе 'translated' будет не текст перевода, а ключ аудио('audio'), так же дополнительно в основном жеше есть ключи настроек аудио('speed', 'tone')
        @audio = raw_translation['translated']['audio'] # и если это аудио то создаем соотв переменную
        @speed = raw_translation['speed'] # настройка скорости аудио
        @tone = raw_translation['tone'] # тон аудио в герцах
      else
        @translated_text = raw_translation['translated'] # а если теккст то создаем переменную с ним
      end
      @original_text = raw_translation['text']
      @translation = raw_translation['translation']
    end
  end
end
