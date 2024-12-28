puts '                                    Serialize (парсинг json)'

# (Альтернатива serialize: jBuilder - урок 16)

# serialize / сериализатор - это программа которая генерирует объект json (тут из коллекции объектов Руби)

# Существуют разные сеарилизаторы, например:
# https://github.com/jsonapi-serializer/jsonapi-serializer       - более навороченый
# https://github.com/procore-oss/blueprinter                     - менее навороченный



puts '                                           Blueprinter'

# https://github.com/procore-oss/blueprinter

# Blueprinter - гем сериализатор


# 1. Добавим blueprinter в гемфаил
gem 'blueprinter'
# > bundle i

# 2. app/blueprints - создаем дирректорию для классов с описанием серриализации (название любое ??)

# 2. app/blueprints/tag_blueprint.rb - создаем фаил с классом, содержащим описание того, как нужно сериализовать наши сущности определенной модели (тут теги) в формат json (те как именно генерировать json с коллекцией сущностей)
class TagBlueprint < Blueprinter::Base
  identifier :id # тоесть идентификатором в json будет id тега
  fields :title  # значением будет title тега
end

# 3. В необходимом экшене необходимого контроллера можем сгенерировать и отрендерить json от коллекции сущностей
class TagsController < ApplicationController
  def index
    @tags = Tag.all

    json_tags = TagBlueprint.render(@tags)
    # TagBlueprint.render(@tags) - через наш класс сериализатора Blueprint превращаем коллекцию тегов в json

    render json: json_tags # просто (без представлений) отрендерим json на страницу
    # http://localhost:5000/api/tags.json - можно посмотреть объект целиком (через паблик, где его сохраняет blueprinter ??)
  end
end















#
