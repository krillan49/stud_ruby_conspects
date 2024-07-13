require File.expand_path('lib/fun_translations/version', __dir__) # подключаем фаил fun_translations/version.rb в блок? для Gem::Specification ниже
# expand_path - метод ищет относительно текущей директории(__dir__) путь из 1го аргумента

Gem::Specification.new do |spec|
  spec.name                  = 'fun_translations'        # название библиотеки которое будет на rubygems.org
  spec.version               = FunTranslations::VERSION  # версия - можно прописать вручную ввиде строки например '0.0.1', а можно использовать константу из фаила(тут lib/fun_translations/version.rb) в нашем исходном коде
  spec.authors               = ['Ilya Krukowski']        # инфа об авторе - имя
  spec.email                 = ['golosizpru@gmail.com']  # инфа об авторе - почта
  spec.summary               = 'Ruby interface for FunTranslations API.'  # короткое описание гема что будет на rubygems.org
  spec.description           = 'This is a Ruby client that enables you to easily perform translations using FunTranslations API.'  # длинное описание гема что будет на rubygems.org
  spec.homepage              = 'https://github.com/bodrovis/fun_translations' # то где лежит исходный код гема, но тут можно указать и просто вебсайт
  spec.license               = 'MIT'                     # стандартная лицензия для библиотек с открытым кодом
  spec.platform              = Gem::Platform::RUBY       # платформа гема - Руби
  spec.required_ruby_version = '>= 2.7.0'                # минимальная необходимая версия Руби

  # Массив со всеми именами фаилов, которые нам потребуются
  spec.files = Dir[
    'README.md', 'LICENSE', 'CHANGELOG.md', 'lib/**/*.rb', 'fun_translations.gemspec', '.github/*.md', 'Gemfile', 'Rakefile'
  ]
  spec.extra_rdoc_files = ['README.md']    # фаил в котором будет докумментация
  spec.require_paths    = ['lib']          # главный путь/директория нашей библиотеки в которой лежит весь исходный код

  # Гемы, которые будут использованы в нашей библиотеке, будут установлены обязательно вместе с нашим гемом, тк от них зависит его работоспособность, тоесть это зависимости
  spec.add_dependency 'faraday', '~> 2.6'
  spec.add_dependency 'zeitwerk', '~> 2.4'

  # Гемы(зависимости) только для раработчиков гема, а не для пользователей
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'simplecov', '~> 0.21'
  spec.add_development_dependency 'webmock', '~> 3.23'
  spec.add_development_dependency 'rubocop', '~> 1.64'
  spec.add_development_dependency 'rubocop-performance', '~> 1.21'
  spec.add_development_dependency 'rubocop-rspec', '~> 3.0'

  # Добавлено с пунктом "Дополнительные фаилы"
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8'

  # метаданные
  spec.metadata = {
    'rubygems_mfa_required' => 'true'  # требуется 2хфакторная аутонтификация на rubygems.org

    # Добавлено с пунктом "Дополнительные фаилы"
    # 'source_code_uri' => 'https://github.com/bodrovis/fun_translations',
    # 'changelog_uri' => 'https://github.com/bodrovis/fun_translations/blob/master/CHANGELOG.md',
    # 'bug_tracker_uri' => 'https://github.com/bodrovis/fun_translations/issues'
  }
end











#
