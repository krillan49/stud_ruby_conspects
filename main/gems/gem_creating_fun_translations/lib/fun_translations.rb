# Подгружаем все неоходимые зависимости
require 'faraday'
require 'json'
require 'zeitwerk'


# Тут можно было бы подгружать все фаилы исходного кода отдельно, например:
# require_relative 'fun_translations/request'
# require_relative ...

# Но если влом писать кучу require огромным столбцом, то можно воспользоваться гемом zeitwerk, он безопасен даже для многопоточных программ, кроме того это официально используемое решение для Рэилс:
loader = Zeitwerk::Loader.for_gem # создаем загрузчик zeitwerk-а Loader и используем метод for_gem, который подгрузит сюда все фаилы из директории lib(? или fun_translations ?). Так же подключает все фаилы директори lib и друг в друга.
# Для корректной работы гема, все фаилы и директории из директории lib должны следовать приниципу именования:
# модуль и директория должна иметь название как главный фаил куда все подгружаем, фаил в котором находятся клаcс модуль или константа обернутые в главный модуль, называется соотв как этот клаcс модуль или константа
# В доках есть описание необходимой фаиловой структуры, для корректной работы гема, например:
# lib/my_gem.rb         -> MyGem
# lib/my_gem/foo.rb     -> MyGem::Foo
# lib/my_gem/bar_baz.rb -> MyGem::BarBaz
# lib/my_gem/woo/zoo.rb -> MyGem::Woo::Zoo
# Далее пример кода отсюда https://github.com/lokalise/ruby-lokalise-api, подсказки для тех фаилов где зайтверк не может сопоставить имя фаила и находящегося в екм класса:
# loader.inflector.inflect(
#   'oauth2' => 'OAuth2',
#   'oauth2_client' => 'OAuth2Client',
#   'oauth2_endpoint' => 'OAuth2Endpoint',
#   'oauth2_token' => 'OAuth2Token',
#   'oauth2_refreshed_token' => 'OAuth2RefreshedToken'
# )
# Далее пример настройки для фаилов которые Зайтверк не должен подключать на лету
# loader.ignore "#{__dir__}/lokalise_rails/railtie.rb" # Ignore the Railtie in non-Rails environments
# loader.ignore "#{__dir__}/generators/templates/lokalise_rails_config.rb"  # Ignore the generator templates
# loader.ignore "#{__dir__}/generators/lokalise_rails/install_generator.rb" # Ignore installation generator scripts
loader.setup


module FunTranslations
  # Чтобы пользователь не заморачивался с созданием экземпляра класса Client
  def self.client(token = nil)
    # token - необязательный токен авторизации для платной версии API
    FunTranslations::Client.new token
  end
end















#
