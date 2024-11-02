puts '                           Кастомные генераторы Рэилс для собственного гема'

# (! Если че потом допройти далее)

# https://www.youtube.com/watch?v=4VssXSv6gQQ&list=PLWlFXymvoaJ-td0fgYNj3fCnCVDTDClRg&index=20   47-00
# https://github.com/bodrovis/lokalise_rails                       на примере этого гема

# Пригодится например, если мы хотим чтоб наш гем, работающий с Рэилс обладал генераторами

# В Рэилс уже есть базовый функционал для создания своих генераторов

# > rails g команды_нашего_генератора


# Нужно от директории lib нашего гема создать поддиректорию generators, а в ней поддиректорию соответсвующую имени нашего гема и в ней rb-фаил. Получится например:
# lib/generators/gem_name/install_generator.rb

# install_generator.rb:
require 'rails/generators' # подключаем библиотеку для генераторов Рэилс

module LokaliseRails # модуль по имени нашего гема
  module Generators
    class InstallGenerator < Rails::Generators::Base # наследуем от класса генераторов Рэилс, добавит набор хэлперов
      source_root File.expand_path('../templates', __dir__)
      # source_root - мнтод Рэилс принимает маршрут к шашему шаблону, который нужно установить в проект юзера нашего гема

      desc 'Creates a LokaliseRails config file in your Rails application.' # просто описание

      def copy_config
        template 'lokalise_rails_config.rb', "#{Rails.root}/config/lokalise_rails.rb"
        # template - встроенный метод, принимает имя фаила и директорию, куда этот фаил нужно поместить
      end
    end
  end
end















#
