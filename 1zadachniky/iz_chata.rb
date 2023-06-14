# Задачка с собеса на сеньера в LegalZoom в кремневой долине

# Есть графическая картинка игры морской бой. Там стоят корабли, типа такого:
# . . . . . . . . . .
# . . . . . . . . . .
# . A . . . B B . . .
# . A . . . . . . . .
# . A . . . . . . . .
# . A . . . . . C . .
# . . . . . . . C . .
# . . . . . C C C . .
# . . . . . . . . . .
# . . . . . . . . . .
#
# Реализовать следующий метод:
#
# init_board
#
# Который будет инициализировать поле.
#
# А также вот такой метод:
#
# attack(x, y)
#
# Который возвращает одно из:
#
# :hit
# :miss
# :ship_sunk
# :winner
#
# Для простоты видимо подразумевается, что игра происходит в одни ворота.

# Разумеется надо сделать это эффективно. Например, если на предыдущем ходе попало в угол C, то получается как бы два корабля. Но на самом деле это один. Корабли могут быть сколь угодно сложной конфигурации. Поле может быть сколь угодно большим

# требуемая скорость O(1)

class SeaFight
  def initialize(arr)
    @field = arr
    @ships = {}
    @ships_x_y = {}
  end

  def init_board
    @field = @field.map{|str| str.chars} # .gsub(/ /,'')
    @field.each.with_index do |arr, y|
      arr.each.with_index do |e, x|
        if e!='.'
          @ships[e] ? @ships[e] += 1 : @ships[e] = 1
          @ships_x_y[[x, y]] = e
        end
      end
    end
  end

  def attack(x,y)
    if @field[y][x] == '+'
      :already_was_attacked
    elsif @field[y][x] != '.'
      @field[y][x] = '+'
      @ships[@ships_x_y[[x, y]]] -= 1
      if @ships.values.sum == 0   # слишком медленная скорость O(N)
        :winner
      elsif @ships[@ships_x_y[[x, y]]] == 0
        :ship_sunk
      else
        :hit
      end
    else
      @field[y][x] = '+'
      :miss
    end
  end
end

# 1000 строк по 1000 символов(пр половина '.' и пр половина от 'A' до 'Z')
def field_1_000_000
  arr = []
  1000.times do
    str=''
    1000.times do
      rand(2) == 0 ? c = '.' : c = rand(65..90).chr
      str += c
    end
    arr << str
  end  # 1.9 sec
  arr
end

arr=field_1_000_000()

game = SeaFight.new(arr)
game.init_board # 3.3 sec   (3.3 - 1.9 == 1.4)

result = []
(0..999).each do |y|
  (0..999).each do |x|
    result << game.attack(x,y)
  end
end # 6.3 sec   (6.3 - 3.3 == 3)

p result.size #=> 1000000
p result.count{|e| e == :miss} #=> 500357
p result.count{|e| e == :hit} #=> 499617
p result.count{|e| e == :ship_sunk} #=> 25
p result.count{|e| e == :winner} #=> 1
# 6.6 sec   (6.6 - 6.3 == 0.3)




class SeaFight
  def initialize(arr)
    @field = arr
    @ships = {}
    @ships_x_y = {}
  end

  def init_board
    @field = @field.map{|str| str.gsub(/ /,'').chars}
    @field.each.with_index do |arr, y|
      arr.each.with_index do |e, x|
        if e!='.'
          @ships[e] ? @ships[e] += 1 : @ships[e] = 1
          @ships_x_y[[x, y]] = e
        end
      end
    end
  end

  def attack(x,y)
    if @field[y][x] == '+'
      :already_was_attacked
    elsif @field[y][x] != '.'
      @field[y][x] = '+'
      @ships[@ships_x_y[[x, y]]] -= 1
      if @ships[@ships_x_y[[x, y]]] == 0
        @ships.delete(@ships_x_y[[x, y]])
        @ships.empty? ? :winner : :ship_sunk
      else
        :hit
      end
    else
      @field[y][x] = '+'
      :miss
    end
  end
end
arr=[
  '. . . . . . . . . .',
  '. B B . . . . . . .',
  '. A B . . . . . . .',
  '. A A . . . . . . .',
  '. . . . . . . . . .',
  '. . . . . . . . . .',
  '. . . . . . . . . .',
  '. . . . . . . . . .',
  '. . . . . . . . . .',
  '. . . . . . . . . .'
]
game=SeaFight.new(arr)
game.init_board
p game.attack(1,0)
p game.attack(1,1)
p game.attack(2,1)
p game.attack(2,2)
p game.attack(1,2)
p game.attack(1,3)
p game.attack(2,3)
p game.ships




#==================================================================================================================
# Еще задача с собеса Романа из 5 частей
#==================================================================================================================

# короче задачка для интерна-джуна, постепенно сложность увеличивается. Я дошел до 5 части за 50 минут. Попробуйте решить певую часть:
#
#
# Даны игральные карты. Есть ranks, есть suits.
#
# Card Ranks: ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, jack, queen, king
# Card Suits: heart ❤️ , diamond ♦️, spade ♠️  , club  ♣️
#
# cards = [
#   { suit: "heart", rank: "8" },
#   { suit: "diamond", rank: "2" },
#   { suit: "diamond", rank: "ace" },
#   { suit: "heart", rank: "king" },
#   { suit: "spade", rank: "4" },
#   { suit: "club", rank: "king" },
#   { suit: "spade", rank: "king" },
#   { suit: "heart", rank: "4" }
# ]
#
# Part 1
# ======
#
# Find the frequency of the ranks in your cards. Определить частоту по rank'у. Для массива выше вот такой должен быть вывод:
#
# 8 - 1
# 2 - 1
# ace - 1
# king - 3
# 4 - 2

# Part 2
# ======
#
# Произвести калькуляцию всех ранков, согласно каждому ранку (см.правила ниже) и написать метод с сигнатурой beat_dealer(number), который будет возвращать булевое значение.
#
# Rank '2' - '10': Value equal to their numerical value
# Rank 'jack', 'queen', 'king': Value of 10
# Rank 'ace': Value of 1
#
# Using these values, compute a hand total from your cards
#
# 8 + 2 + 1 + 10 + 4 + 10 + 10 + 4
# 49
#
# We then want to compare our hand total to a dealer number
#
# Return True if Player wins and False if the dealer wins.
#
# Example:
# Dealer number 44 -> true
# Dealer number 55 -> false

# да, что в первой части. Хотя давай сделаем метод, который будет принимать этот набор карт: beat_dealer(cards, number)

# Part 3 - Shifting
# =================
#
# Rank Order
# "ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king"
#
# Cards -> [
#   { suit: "heart", rank: "queen"},
#   { suit: "diamond", rank: "7" },
#   { suit: "heart", rank: "10" } ]
#
# Shift 2
#
# Output Cards -> [
#   { suit: heart", rank: "ace" },
#   { suit: "diamond", rank: "9" },
#   { suit: "heart", rank: "queen"}]

# написать метод, который сдвигает карты на заданное количество позиций если сдвинуть queen на одну, будет king если на две, то будет уже ace если ace на две сдвинуть, будет "3" в обратную сторону тоже надо чтобы сдвигалось и сдвиги на 123123 позиций чтобы тоже работали это уже на мидла тест, на мой взгляд. На начинающего такого миддла)

# Part 3C
# =======
#
# Надо пройтись по этим actions вызывая методы и вывести вывод для beatDealer:
#
# const dealerActions = [
#   { action: "shift", value: 3},
#   { action: "beatDealer", value: 30 },
#   { action: "shift", value: -7 },
#   { action: "beatDealer", value: 30 },
# ]

# в рубях это будет dealer_actions

# т.е. вот за 50 минут смотришь что ты решил и ранк такой:
#
# СТАЖЕР - часть 1
# ДЖУН - часть 1, 2
# МИДДЛ - часть 1, 2, 3
# СЕНИОР - часть 1, 2, 3, 3C, 4 (пока не опубликована), 5 (тоже не опубликована)

# Part 4
# ======
#
# Немного усложняется, добавляется метод swap.
#
# const dealerActions = [
#   { action: "shift", value: 3},
#   { action: "beatDealer", value: 58 },
#   { action: "swap", value: ["10", "9"] },
#   { action: "shift", value: -7 },
#   { action: "beatDealer", value: 30 },
# ]
#
# Пример работы метода swap:
#
# cards = [
#   { rank: "2", suit: "diamond" },
#   { rank: "king", suit: "heart" },
#   { rank: "king", suit: "spade" }
# ]
#
# { action: "swap”, value: [ "2", "king"] }
#                          ^^^^^^^^^^^^^^ всегда два значения,
#                       всегда карты присутствуют (в этой Part 4)
#
# // Result:
# cards = [
#   { rank: "king", suit: "diamond" },
#   { rank: "2", suit: "heart" },
#   { rank: "2", suit: "spade" }
# ]

# Part 5
# ======
#
# Сделать так, чтобы swap делался только в том случае, если карты присутствуют в колоде

cards = [
  { suit: "heart", rank: "8" },
  { suit: "diamond", rank: "2" },
  { suit: "diamond", rank: "ace" },
  { suit: "heart", rank: "king" },
  { suit: "spade", rank: "4" },
  { suit: "club", rank: "king" },
  { suit: "spade", rank: "king" },
  { suit: "heart", rank: "4" }
]

dealer_actions = [
  { action: "shift", value: 3},
  { action: "beat_dealer", value: 30 },
  { action: "shift", value: -7 },
  { action: "beat_dealer", value: 30 },
]

class CardDealer
  def initialize(cards)
    @cards = cards
    @ranks = ['ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'jack', 'queen', 'king']
    @suits = ['heart', 'diamond', 'spade', 'club']
    @ranks_values = @ranks.map{|e| e == 'ace' ? ['ace', 1] : e.to_i == 0 ? [e, 10] : [e, e.to_i]}.to_h
  end

  def count_same_rangs
    @cards.map{|card| card[:rank]}.tally.map{|k, v| "#{k} - #{v}"}
  end

  def beat_dealer(number)
    @cards.map{|card| @ranks_values[card[:rank]]}.sum > number
  end

  def shift(n)
    shifted_ranks = @ranks.rotate(n)
    rotating_rangs = @ranks.zip(shifted_ranks).to_h
    @cards.each{|card| card[:rank] = rotating_rangs[card[:rank]]}
  end

  def swap(values)
    return 'incorrect input' if values.uniq.size != 2
    ourranks = @cards.map{|hh| hh[:rank]}.uniq
    return 'no cards to swap' if values.any?{|v| !ourranks.include?(v)}
    @cards.each do |card|
      if card[:rank] == values[1]
        card[:rank] = values[0]
      elsif card[:rank] == values[0]
        card[:rank] = values[1]
      end
    end
  end

  def methods_runner(actions, method_to_outpot)
    actions.each.with_object([]) do |action, output|
      res = send action[:action], action[:value]
      output << res if action[:action] == method_to_outpot
    end
  end
end

cd = CardDealer.new(cards)
p cd.swap(['4', 'king']) #=> [{:suit=>"heart", :rank=>"8"}, {:suit=>"diamond", :rank=>"2"}, {:suit=>"diamond", :rank=>"ace"}, {:suit=>"heart", :rank=>"4"}, {:suit=>"spade", :rank=>"king"}, {:suit=>"club", :rank=>"4"}, {:suit=>"spade", :rank=>"4"}, {:suit=>"heart", :rank=>"king"}]
p cd.swap(['10', '9']) #=> "no cards to swap"
# p cd.count_same_rangs #=> ["8 - 1", "2 - 1", "ace - 1", "king - 3", "4 - 2"]
# p cd.beat_dealer(44) #=> true
# p cd.beat_dealer(55) #=> false
# p cd.shift(2) #=> [{:suit=>"heart", :rank=>"10"}, {:suit=>"diamond", :rank=>"4"}, {:suit=>"diamond", :rank=>"3"}, {:suit=>"heart", :rank=>"2"}, {:suit=>"spade", :rank=>"6"}, {:suit=>"club", :rank=>"2"}, {:suit=>"spade", :rank=>"2"}, {:suit=>"heart", :rank=>"6"}]
# p cd.methods_runner(dealer_actions, "beat_dealer") #=> [true, true]
