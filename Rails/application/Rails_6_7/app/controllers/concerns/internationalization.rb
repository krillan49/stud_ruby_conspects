module Internationalization
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale

    private

    def switch_locale(&action)
      locale = locale_from_url || locale_from_headers || I18n.default_locale
      # locale_from_headers - метод взятия локали из заголовков запрса
      response.set_header 'Content-Language', locale # отправим заголовок ответа
      I18n.with_locale locale, &action
    end

    def locale_from_url
      locale = params[:locale]
      return locale if I18n.available_locales.map(&:to_s).include?(locale)
    end

    def default_url_options
      { locale: I18n.locale }
    end

    # Добавим методы проверки из заголовков предпочитаемой локали из браузера
    # Adapted from https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/locale.rb (ссылка что заимствовали чужой код)
    def locale_from_headers
      header = request.env['HTTP_ACCEPT_LANGUAGE'] # все локали предпочитаемые пользователем
      return if header.nil?
      locales = parse_header header
      # parse_header - метод ниже чтобы распарсить заголовки с локалями предпочитаемые пользователем
      return if locales.empty?
      return locales.last unless I18n.enforce_available_locales
      detect_from_available locales
    end

    def parse_header(header)
      header.gsub(/\s+/, '').split(',').map do |language_tag|
        locale, quality = language_tag.split(/;q=/i)
        quality = quality ? quality.to_f : 1.0
        [locale, quality]
      end.reject do |(locale, quality)|
        locale == '*' || quality.zero?
      end.sort_by do |(_, quality)|
        quality
      end.map(&:first)
    end

    def detect_from_available(locales)
      locales.reverse.find { |l| I18n.available_locales.any? { |al| match?(al, l) } }
      I18n.available_locales.find { |al| match?(al, locale) } if locale
    end

    def match?(str1, str2)
      str1.to_s.casecmp(str2.to_s).zero?
    end
  end
end
















#
