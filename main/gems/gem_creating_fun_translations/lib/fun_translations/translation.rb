module FunTranslations
  class Translation
    # методы которыц будет вызывать пользователь, для просмотра данных ответа
    attr_reader :translated_text, :original_text, :translation#, :audio, :speed, :tone

    def initialize(raw_translation) # raw_translation - хэш вида: {"translated": "Force be with you my padawan!", "text": "Hello my padawan!",  "translation": "yoda" } принятый в методе translate класа Client
      # if raw_translation.respond_to?(:key?) && raw_translation['translated'].key?('audio')
      #   @audio = raw_translation['translated']['audio']
      # else
        @translated_text = raw_translation['translated']
      # end
      @original_text = raw_translation['text']
      @translation = raw_translation['translation']
      # @speed = raw_translation['speed']
      # @tone = raw_translation['tone']
    end
  end
end
