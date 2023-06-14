# p192 ООП: Состояние объектов

# Задание 1: напишите класс Monkey (“обезьянка”). В классе должно быть 1) реализовано два метода: run, stop; 2) каждый из методов должен менять состояние объекта; 3) you must expose the state of an object(вы должны предоставить информацию о состоянии объекта) так, чтобы можно было узнать о состоянии класса снаружи, но нельзя было его модифицировать. Создайте экземпляр класса Monkey, вызовите методы объекта и проверьте работоспособность программы.

# Задание 2: сделайте так, чтобы при инициализации класса Monkey экземпляру присваивалось случайное состояние. Создайте массив из десяти обезьянок. Выведите состояние всех элементов массива на экран.

class Monkey
  attr_reader :state

  def initialize
    r = rand(2)
    r == 0 ? @state = :stop : @state = :run
  end

  def run
    @state = :run
  end
  def stop
    @state = :stop
  end
end

monkey = Monkey.new
p monkey.state
monkey.run
p monkey.state
monkey.stop
p monkey.state

monkeys = []
10.times {monkeys << Monkey.new}

monkeys.each.with_index(1) do |el, i|
  puts "Monkey #{i} is #{el.state}"
end
