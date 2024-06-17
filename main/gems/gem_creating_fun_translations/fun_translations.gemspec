require File.expand_path('lib/fun_translations/version', __dir__) # подключаем фаил fun_translations/version.rb в блок? для Gem::Specification ниже
# expand_path - метод ищет относительно текущей директории(__dir__) путь из 1го аргумента

Gem::Specification.new do |spec|
  spec.name                  = 'fun_translations'        # название библиотеки которое будет на rubygems.org
  spec.version               = FunTranslations::VERSION  # версия - можно прописать вручную ввиде строки например '0.0.1', а можно использовать константу из фаила(тут lib/fun_translations/version.rb) в нашем исходном коде
  spec.authors               = ['Ilya Krukowski']        # инфа об авторе - имя
  spec.email                 = ['golosizpru@gmail.com']  # инфа об авторе - почта
  spec.summary               = ''                        # короткое описание гема что будет на rubygems.org
  spec.description           = ''                        # длинное описание гема что будет на rubygems.org
  spec.homepage              = 'https://github.com/bodrovis/fun_translations' # то где лежит исходный код гема, но тут можно указать и просто вебсайт
  spec.license               = 'MIT'                     # стандартная лицензия для библиотек с открытым кодом
  spec.platform              = Gem::Platform::RUBY       # платформа гема - Руби
  spec.required_ruby_version = '>= 2.7.0'                # минимальная необходимая версия Руби

  # Массив со всеми именами фаилов, которые нам потребуются
  # spec.files = Dir['README.md', 'LICENSE',
  #                  'CHANGELOG.md', 'lib/**/*.rb',
  #                  'fun_translations.gemspec', '.github/*.md',
  #                  'Gemfile', 'Rakefile']
  spec.files = Dir['lib/**/*.rb', 'fun_translations.gemspec', 'Gemfile']
  # spec.extra_rdoc_files = ['README.md']    # фаил в котором будет докумментация
  spec.require_paths    = ['lib']          # главный путь/директория нашей библиотеки в которой лежит весь исходный код

  # Гемы, которые будут использованы в нашей библиотеке, будут установлены вместе с нашим гемом, тоесть это зависимости
  spec.add_dependency 'faraday', '~> 2.6'  # ~> 2.6 тоесть от данной включительно до 3.0 не включительно
  spec.add_dependency 'zeitwerk', '~> 2.4'

  # метаданные
  spec.metadata = {
    'rubygems_mfa_required' => 'true'  # требуется 2хфакторная аутонтификация на rubygems.org
  }
end











#
