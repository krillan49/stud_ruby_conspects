# 0. Методы из доки пройти заново, массивы, строки, хэши

# ?? В руби можно сразу отправлять что-то в командную строку на выполнение, если заключить строку в обратные кавычки ``


# класс внутри класса методы в строку с =
# В Ruby вложенность может влиять на область действия констант и классов. Если класс или модуль определен внутри другого класса или модуля, он является вложенным, и его область действия ограничивается включающим его классом или модулем. Это означает, что доступ к нему возможен только из класса или модуля, в который он вложен.
class Lottery

  def initialize(**options)
    @limited_of_tickets = options[:limited_of_tickets] || 5
    @ticket_size = options[:ticket_size] || 3
    @all_tickets = Array.new(@limited_of_tickets) { Ticket.new(@ticket_size).list }
  end

  def all_tickets = @all_tickets || []

  class Ticket
    include Comparable

    def initialize(size)
      @size = size
      @all = Array.new(@size) { rand(99) }
    end

    def list = @all
  end

end

lottery_1 =  Lottery.new(limited_of_tickets: 100,ticket_size: 3)
pp lottery_1.all_tickets
