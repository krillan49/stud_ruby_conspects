# 0. Методы из доки пройти заново, массивы, строки, хэши

# ?? В руби можно сразу отправлять что-то в командную строку на выполнение, если заключить строку в обратные кавычки ``


# https://www.sitepoint.com/understanding-scope-in-ruby/   продолжить с 'Являются ли блоки воротами области действия?'


# Метод с ensure
def some
  # тут возвращает
ensure
  # тут доп действие, после возврата ??
end
# метод еще со всяким
def perform(archive_key, initiator)

rescue StandardError => e

else

end



# класс внутри класса методы в строку с =
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
