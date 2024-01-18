# 0. Методы из доки пройти заново, массивы, строки, хэши

# ?? В руби можно сразу отправлять что-то в командную строку на выполнение, если заключить строку в обратные кавычки ``


# Защита от вызова метода от nil при помощи синтаксиса амперсанта & (либо rescue nil)
p nil&.some_meth #=> nil
str1, str2 = 'aaa', nil
p str1.split('') #=> ["a", "a", "a"]
p str2.split('') #=> undefined method `split' for nil:NilClass (NoMethodError)
p str2&.split('') #=> nil


# and return в конце действия, потом проверить
render plain: params.to_yaml and return

self # это метод, возвращающий текущий объект ??

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
