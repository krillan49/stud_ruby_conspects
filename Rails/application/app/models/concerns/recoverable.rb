module Recoverable
  extend ActiveSupport::Concern

  included do
    before_update :clear_reset_password_token, if: :password_digest_changed? # запустим метод через колбэк
    # before_update - колбэк запускающий метод после прохождения валидаций, но до сохранения в БД (тут нового пароля)
    # if: :password_digest_changed? - колбэк сработает только если пароль был изменен, метод password_digest_changed? создаст автоматически, по названию поля password_digest

    def set_password_reset_token
      update password_reset_token: digest(SecureRandom.urlsafe_base64), password_reset_token_sent_at: Time.current
      # update (или тоже самое self.update) - тоесть метод обновления юзера(метод экземпляра модели обновляющий запись в БД ??)
      # password_reset_token: - тоесть обновляем значение поля токена сброса пароля
      # digest(SecureRandom.urlsafe_base64) - используем метод написанный ранее в модели user.rb, чтобы сгенерировать хэш-токен
      # password_reset_token_sent_at: Time.current - тоесть обновляем время создания токена на текущее время в текущей временной зоне (временная зона настраивается в config/application.rb)
    end

    def clear_reset_password_token # очистим поля токена сброса пароля и метки времени, после смены пароля
      self.password_reset_token = nil
      self.password_reset_token_sent_at = nil
    end

    def password_reset_period_valid?
      password_reset_token_sent_at.present? && Time.current - password_reset_token_sent_at <= 60.minutes # Тоесть если поле password_reset_token_sent_at существует и прошло не более часа с момента создания токена(соесть срок действия токена у нас будет 1 час), и соотв отправки пользователю письма со ссылкой
      # minutes - метод Рэилс для чисел
    end
  end
end














#
