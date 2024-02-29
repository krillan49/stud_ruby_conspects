puts
puts '                                        Вложенные классы и модули'

# В Ruby вложенность может влиять на область действия констант и классов. Если класс или модуль определен внутри другого класса или модуля, он является вложенным, и его область действия ограничивается включающим его классом или модулем. Это означает, что доступ к нему возможен только из класса или модуля, в который он вложен.

class Lottery
  attr_reader :tickets

  def initialize(n, size)
    @tickets = Array.new(n) { Ticket.new(size).list }
  end

  class Ticket
    def initialize(size)
      @all = Array.new(size) { rand(99) }
    end

    def list = @all
  end

end

lottery =  Lottery.new(5, 3)
p lottery.tickets #=> [[51, 9, 23], [17, 49, 60], [67, 76, 72], [62, 40, 29], [53, 3, 79]]
















# 
