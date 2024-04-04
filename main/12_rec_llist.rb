puts '                                       Рекурсия и Linked lists'

# Рекурсивная реализация более элегантна чем итеративная и не имеет изменяемого состояния, но у него есть проблема с потреблением памяти.


# 4 kyu Hash.flattened_keys
# https://www.codewars.com/kata/521a849a05dd182a09000043
class Hash

  def flattened_keys(obj = nil)
    obj = self.clone if !obj

    res = obj.map {|k, v|
      if v.class == Hash or v.class == Array
        v.map {|key, val|
          newk = k.to_s + '_' + key.to_s
          newk = newk.to_sym if k.class == Symbol && key.class == Symbol
          [newk, val]
        }
      else
        [k, v]
      end
    }.flatten

    if res.any?{|e| e.class == Hash or e.class == Array}
      flattened_keys(res.each_slice(2).to_a)
    else
      res.each_slice(2).to_a.to_h
    end
  end

end

unflat = {id: 1, info: {name: 'example'}}
p unflat.flattened_keys # {id: 1, info_name: 'example'}
unflat = {id: 1, info: {name: 'example', more_info: {count: 1}}}
p unflat.flattened_keys # {id: 1, info_name: 'example', info_more_info_count: 1}
unflat = {a: 1, 'b' => 2, info: {id: 1, 'name' => 'example'}}
p unflat.flattened_keys # {a: 1, 'b' => 2, info_id: 1, 'info_name' => 'example'}


puts
puts '                                      Linked list(связанные списки)'

# https://en.wikipedia.org/wiki/Linked_list


# пример1 (вывести связанный список в виде строки разделив элементы при помощи '->')
class Node
  attr_reader :data, :next_node

  def initialize(data, next_node=nil)
    @data = data
    @next_node = next_node
  end
end
# решение
def stringify(list)
  list == nil ? 'nil' : list.data.to_s + ' -> ' + stringify(list.next_node)
end
linked_list = Node.new(0, Node.new(1, Node.new(4, Node.new(9, Node.new(16)))))
p stringify(linked_list)# "0 -> 1 -> 4 -> 9 -> 16 -> nil"


puts
# пример2 (соединение двух списков: конца 1го и начала 2го)
class Node
  attr_accessor :data, :next
  def initialize(data, next_node=nil)
    @data = data
    @next = next_node
  end
end

def append(list_a, list_b)
  return list_a if !list_b # проверка не равен ли один из списков nil
  return list_b if !list_a
  list_a.next == nil ? list_a.next = list_b : append(list_a.next, list_b)
  list_a
end

list_a = Node.new(0, Node.new(1))
list_b = Node.new(2, Node.new(3))

p append(list_a, list_b) #=> #<Node:0x000002b0a1c495b0 @data=0, @next=#<Node:0x000002b0a1c49628 @data=1, @next=#<Node:0x000002b0a1c49510 @data=2, @next=#<Node:0x000002b0a1c49538 @data=3, @next=nil>>>>


puts
# пример3 (создание списков)
class Node
	attr_accessor :data, :next
	def initialize(data)
  	@data = data
  end
end

def push(head=nil, data)  # отдельные методы
	node = Node.new(data)
  node.next = head
  node
  # Node.new(data, node)
end

def build_one_two_three
  push(push(push(3), 2), 1)
end

def build_one_two_three_four_five_six
  node = nil
  6.downto(1){|n| node = push(node, n)}
  node
end

def build_list(arr)
  node = Node.new(arr[-1])
  arr[0..-2].reverse.each{|e| node = push(node, e)}
  node
end

push(nil, 1) #=> #<Node:0x00000299ebad1678 @data=1, @next=nil>
build_one_two_three() #=> #<Node:0x00000299ebad1380 @data=1, @next=#<Node:0x00000299ebad13a8 @data=2, @next=#<Node:0x00000299ebad13d0 @data=3, @next=nil>>>
build_list([1, 2, 3, 4, 5, 6, 7]) #=> #<Node:0x000002501e604058 @data=1, @next=#<Node:0x000002501e6040d0 @data=2, @next=#<Node:0x000002501e6040f8 @data=3, @next=#<Node:0x000002501e604120 @data=4, @next=#<Node:0x000002501e604148 @data=5, @next=#<Node:0x000002501e604198 @data=6, @next=#<Node:0x000002501e604350 @data=7, @next=nil>>>>>>>


puts
# пример4 (перемещение первого узла с одного списка на дрцугой) (класс списков и методы задействованы из пред примера)
class Context
  attr_accessor :source, :dest
  def initialize(source, dest)
    @source = source
    @dest = dest
  end
end

def move_node(source,dest)
  dest = push(dest, source.data)
  source = source.next
  Context.new(source,dest)
end

p move_node(build_one_two_three(), nil)# Context.new(build_list([2, 3]), Node.new(1)))
#=> #<Context:0x000001dfeaab01f0 @source=#<Node:0x000001dfeaab03f8 @data=2, @next=#<Node:0x000001dfeaab0498 @data=3, @next=nil>>, @dest=#<Node:0x000001dfeaab02e0 @data=1, @next=nil>>
p move_node(build_one_two_three(), build_one_two_three())# Context.new(build_list([2, 3]), build_list([1, 1, 2, 3])))
#=> #<Context:0x000001dfeaaabd58 @source=#<Node:0x000001dfeaaabe48 @data=2, @next=#<Node:0x000001dfeaaabe70 @data=3, @next=nil>>, @dest=#<Node:0x000001dfeaaabd80 @data=1, @next=#<Node:0x000001dfeaaabda8 @data=1, @next=#<Node:0x000001dfeaaabdd0 @data=2, @next=#<Node:0x000001dfeaaabdf8 @data=3, @next=nil>>>>>


puts
# пример5 (подсчет всх узлов и определенных по значениям) (класс списков и методы задействованы из пред примера3)
def length(node)
	return 0 if node == nil
  counter=0
  until node.next == nil
    node = node.next
    counter += 1
  end
  counter + 1
end

def count(node, data)
	return 0 if node == nil
  counter = 0
  until node.next == nil
    counter += 1 if node.data == data
    node = node.next
  end
  counter += 1 if node.data == data
  counter
end

list = build_one_two_three()

p length(nil)# 0
p length(Node.new(99))# 1
p length(list)# 3

p count(list, 1)# 1
p count(list, 2)# 1
p count(list, 3)# 1
p count(list, 99)# 0
p count(nil, 1)# 0


# https://www.codewars.com/kata/55cacc3039607536c6000081/train/ruby
# Добавить(не заменить а именно вставить) сегмент динкет листа в заданном индексе с заджанным значением
class Node
  attr_accessor :data, :next
  def initialize(data, nextN = nil)
    @data = data
    @next = nextN
  end
end

def insert_nth(head, index, data, i=0)
  if (i == index)
    Node.new(data, head)
  else
    Node.new(head.data, insert_nth(head.next, index, data, i+1)) # до нужного индекса придется переопределять внешние листы
  end
end















#
