puts '                                        Вложенные классы и модули'

# В Ruby вложенность может влиять на область действия констант и классов. Если класс или модуль определен внутри другого класса или модуля, он является вложенным, и его область действия ограничивается включающим его классом или модулем. Это означает, что доступ к нему возможен только из класса или модуля, в который он вложен.



puts '                                  Класс вложенный в класс (nested class)'

# Можно вложить один ксласс в другой так же как в модуль

class Lottery
  attr_reader :tickets

  def initialize(n, size)
    @tickets = Array.new(n) { Ticket.new(size).list }
  end

  # Вложенный класс
  class Ticket
    attr_reader :list
    
    def initialize(size)
      @list = Array.new(size) { rand(99) }
    end
  end
end

# Вложенный класс вызывается от внешнего так же как и от модуля
ticket = Lottery::Ticket.new(4)
p ticket.list #=> [44, 56, 19, 42]

lottery = Lottery.new(5, 3)
p lottery.tickets #=> [[51, 9, 23], [17, 49, 60], [67, 76, 72], [62, 40, 29], [53, 3, 79]]



puts '                            Определение вложенного класса через :: синтаксис'

class ProductListTable::Query # Такой синтаксис означает, что класс Query является вложенным классом (nested class) внутри класса или модуля ProductListTable, который определен ранее, тоесть это какбы удаленное вложение класса в класс или модуль, который находится в другом месте в коде
end
# ProductListTable        - это либо класс, либо модуль, который уже был определён ранее, если не был определен, то выбросит ошибку
# ProductListTable::Query - это класс Query, который находится в пространстве имён ProductListTable

# Это равноценно такому определению, но только в отличие от этого требует чтобы класс (или модуль) ProductListTable был предварительно создан:
module ProductListTable
  class Query
  end
end

# Преимущества такого синтаксиса:
# 1. Позволяет избежать лишнего уровня вложенности в коде
# 2. Делает явным, что класс принадлежит определённому пространству имён
# 3. Часто используется, когда вложенный класс небольшой и не требует отдельного большого блока кода


# Пример использования:
class ProductListTable 
  # если этот класс (или модуль) предварительно не создано, то вызов метода ниже выбросит ошибку uninitialized constant ProductListTable (NameError)
end

class ProductListTable::Query
  def initialize(params)
    @params = params
  end
  
  def call
    'Hi'
  end
end

query = ProductListTable::Query.new('params')
query.call #=> "Hi"
