# 3 kyu The builder of things  https://www.codewars.com/kata/5571d9fc11526780a000011a/train/ruby
class Thing
  attr_accessor :name, :meths, :new_meth
  def initialize(name)
    @name = name
    @is_a = @is_not_a = @is_the = @has = false

    @meths = {}
    @new_meth = false
  end

  def is_a
    @is_a = true
    self
  end
  def is_not_a
    @is_not_a = true
    self
  end
  def is_the
    @is_the = true
    self
  end
  def has(n)
    @has = n
    self
  end
  def is_a?(cls)
    cls == Thing
  end

  def each(&block)
    p block
  end

  def method_missing(method)
    # p method
    return @meths[method] if @meths[method] != nil
    if @is_a
      @is_a = false
      @meths[(method.to_s + '?').to_sym] = true
    elsif @is_not_a
      @is_not_a = false
      @meths[(method.to_s + '?').to_sym] = false
    elsif @is_the
      if @new_meth
        @is_the = false
        @meths[@new_meth] = method
        res = @new_meth
        @new_meth = false
        @meths[res]
      else
        @new_meth = method
        self
      end
    elsif @has
      @meths[method] = []
      if @has == 1
        @meths[method] = Thing.new(method)
      else
        @has.times{ @meths[method] << Thing.new(method) }
        @meths[method]
      end
    end
  end
end

jane = Thing.new('Jane')
# p jane.name # => 'Jane'
# p jane.meths
#
# jane.is_a.person
# jane.is_a.woman
# jane.is_not_a.man
#
# p jane.person? # => true
# p jane.woman? #=> true
# p jane.man? # => false
#
# jane.is_the.parent_of.joe
# p jane.parent_of # => 'joe'

# p jane.has(2).legs
# p jane.legs.size # => 2
# p jane.legs.first.is_a?(Thing) # => true
#
# jane.has(1).head
# p jane.head.is_a?(Thing) # => true


# ХЗ КАК ЭТО СДЕЛАТЬ тк обращается к объекту main

# can define number of things in a chainable and natural format
p jane.has(2).arms.each { having(1).hand.having(5).fingers }
# jane.arms.first.hand.fingers.size # => 5

# # can define properties on nested items
# jane.has(1).head.having(2).eyes.each { being_the.color.blue.and_the.shape.round }

# # can define methods
# jane.can.speak('spoke') do |phrase|
#   "#{name} says: #{phrase}"
# end

# jane.speak("hello") # => "Jane says: hello"

# # if past tense was provided then method calls are tracked
# jane.spoke # => ["Jane says: hello"]



puts
#================================================
# Hard Sudoku Solver   https://www.codewars.com/kata/55171d87236c880cea0004c6/train/ruby
#================================================
class SudokuSolver
  attr_reader :puzzle, :grid#, :storage_of_grids#,

  def initialize(puzzle)
    @puzzle = puzzle
    @grid = puzzle.map.with_index{|arr,i| arr.map.with_index{|e,j| [[i,j], e == 0 ? [] : e]}}.flatten(1).to_h
    @storage_of_grids = []
  end

  def test_cycle
    brute_force_step
    return true if @puzzle.flatten.sum == 405
    old_grid = nil

    counter = 0

    until old_grid == @grid

      counter += 1
      p counter

      # if @grid.any?{|k, v| v.class == Array && v.include?(nil)}
      #   # pp old_grid
      #   # pp @grid
      #   return false
      # end

      old_grid = @grid.map{|k, v| [k.clone, v.clone]}.to_h # @grid.clone

      tracking_step

      brute_force_step
      # bfs = brute_force_step

      # if !bfs or @grid.any?{|k, v| v.class == Array && v.size > 7}
      #   p 'back_track test_cycle'
      #   back_track
      # end

      return true if @puzzle.flatten.sum == 405
    end
  end

  def brute_force_step
    old_puzzle = nil
    until old_puzzle == @puzzle
      old_puzzle = @puzzle.clone.map{|arr| arr.clone} # @puzzle.clone
      [:rows_except, :cols_except, :sqrs_except, :cell_filling].each do |meth|
        return false if send(meth) == false
      end
    end
  end

  def tracking_step
    grid_exepts = @grid.select{|k, v| v.class == Array} # исключаем заполненные клетки
    max_exepts = grid_exepts.values.map(&:size).max # максимальное число исключенных значений среди всех клеток

    # if max_exepts == 8
    #   # pp grid_exepts
    #   # p choosen_cell
    #   # p possible_vals
    #   p 'back_track tracking_step'
    #   back_track
    #   # return false
    # end

    choosen_cell = grid_exepts.find{|ij, exepts| exepts.size == max_exepts} # клетка с максимальным числом исключенных значений например [[0, 5], [9, 8, 1, 6, 5, 4, 7]]
    possible_vals = (1..9).to_a - choosen_cell[1] # возможные значения для выбранной клетки
    val_choosen = possible_vals[0] # выбираем значение из возможных


    grid_for_storage = @grid.clone.map{|k, v| [k.clone, v.clone]}.to_h # @grid.clone
    grid_for_storage[choosen_cell[0]] << val_choosen # добавляем в исключения выбранной клетки выбранное значение, на случай если оно не пройдет  (похоже тут и добавляется 9е ?? тут вставим тест)



    @storage_of_grids << [grid_for_storage, choosen_cell[0]] # добавляем в конец хранилища прошлую версию сетки (?? и ключ клетки в которой угадывалось значение)

    @grid[choosen_cell[0]] = val_choosen # добавляем угадываемое значение в сетку
    @puzzle[choosen_cell[0][0]][choosen_cell[0][1]] = val_choosen # добавляем угадываемое значение в результат(!!!мб потом изменить)

    # p @storage_of_grids.size
  end

  def back_track # откатываем сетку к последнему шагу угадывания(последние 2 шага если единствееное значение тоже говно??)
    # p @storage_of_grids
    # p '---'
    @grid = @storage_of_grids.pop[0]
    @grid.each{|(i, j), v| @puzzle[i][j] = v.class == Integer ? v : 0}
    # p '==='
  end

  # def solve
  #   [:rows_except, :cols_except, :sqrs_except, :cell_filling].cycle do |meth|
  #     send meth
  #     break if @puzzle.flatten.sum == 405
  #   end
  # end

  private

  # def errors_checker(val)
  #   val.uniq != val
  # end

  def rows_except # добавляем значения заполненных клеток в исключения незаполненных([]) в каждой линии
    (0..8).each do |i|
      val = @grid.select{|k, v| k[0] == i && v.class != Array}.values  # значения запоненных клеток в каждой линии
      # return false if errors_checker(val)
      @grid.select{|k, v| k[0] == i && v.class == Array}.each{|k, v| @grid[k] = (@grid[k] + val).uniq}
    end
  end

  def cols_except
    (0..8).each do |j|
      val = @grid.select{|k, v| k[1] == j && v.class != Array}.values # значения заполненных клеток в каждом столбце
      # return false if errors_checker(val)
      @grid.select{|k, v| k[1] == j && v.class == Array}.each{|k, v| @grid[k] = (@grid[k] + val).uniq}
    end
  end

  def sqrs_except
    [0..2, 3..5, 6..8].each do |r_i|
      [0..2, 3..5, 6..8].each do |r_j|
        val = @grid.select{|k, v| r_i.include?(k[0]) && r_j.include?(k[1]) && v.class != Array}.values
        # return false if errors_checker(val)
        @grid.select{|k, v| r_i.include?(k[0]) && r_j.include?(k[1]) && v.class == Array}.each{|k, v| @grid[k] = (@grid[k] + val).uniq}
      end
    end
  end

  def cell_filling
    @grid.each do |(i, j), v|
      if v.class == Array && v.size == 8
        v = ((1..9).to_a - v)[0]
        @grid[[i, j]] = v
        @puzzle[i][j] = v
      end
    end
  end
end

def solve(puzzle)
  solver = SudokuSolver.new(puzzle)

  solver.test_cycle
  # pp solver.grid
  solver.puzzle
end

puzzle = [
 [9, 0, 0, 0, 8, 0, 0, 0, 1],
 [0, 0, 0, 4, 0, 6, 0, 0, 0],
 [0, 0, 5, 0, 7, 0, 3, 0, 0],
 [0, 6, 0, 0, 0, 0, 0, 4, 0],
 [4, 0, 1, 0, 6, 0, 5, 0, 8],
 [0, 9, 0, 0, 0, 0, 0, 2, 0],
 [0, 0, 7, 0, 3, 0, 2, 0, 0],
 [0, 0, 0, 7, 0, 5, 0, 0, 0],
 [1, 0, 0, 0, 4, 0, 0, 0, 7]]

solution = [
  [9, 2, 6, 5, 8, 3, 4, 7, 1],
  [7, 1, 3, 4, 2, 6, 9, 8, 5],
  [8, 4, 5, 9, 7, 1, 3, 6, 2],
  [3, 6, 2, 8, 5, 7, 1, 4, 9],
  [4, 7, 1, 2, 6, 9, 5, 3, 8],
  [5, 9, 8, 3, 1, 4, 7, 2, 6],
  [6, 5, 7, 1, 3, 8, 2, 9, 4],
  [2, 8, 4, 7, 9, 5, 6, 1, 3],
  [1, 3, 9, 6, 4, 2, 8, 5, 7]
]

pp solve(puzzle)




puts
#================================================
# Upside-Down Numbers - Challenge Edition   https://www.codewars.com/kata/59f98052120be4abfa000304/train/ruby
#================================================

# для просмотра количества чисел в каждом новом порядке(от 0 до 9, от 11 до 99 итд)
$digs = [
  [%w[1 8], %w[0 1 8]],
  [%w[11 69 88 96], %w[00 11 69 88 96]]
]#, %w[000 101 111 181 609 619 689 808 818 888 906 916 986]
3.times do
  digs = $digs[-2][1]
  all = []
  res = []
  [%w[0 0], %w[1 1], %w[6 9], %w[8 8], %w[9 6]].each do |s, e|
    digs.each do |n|
      all << s + n + e
      (res << s + n + e) if s != '0'
    end
  end
  $digs << [res, all]
end
p $digs
p $digs.map{|res, all| [res.size, all.size]}

[
  [2, 3],
  [4, 5],
  [12, 15],   # 12 = 3*4    # 15 = 3*5
  [20, 25],   # 20 = 5*4    # 25 = 5*5
  [60, 75],   # 60 = 15*4   # 75 = 15*5
  [100, 125], # 100 = 25*4  # 125 = 25*5
  [300, 375], # 300 = 75*4  # 375 = 75*5
  [500, 625],
  [1500, 1875],
  [2500, 3125],
  [7500, 9375],
  [12500, 15625]
]

[
  [
    ["1", "8"], # 2
    ["0", "1", "8"] # 3
  ],
  [
    ["11", "69", "88", "96"], # 4 (7)
    ["00", "11", "69", "88", "96"] # 5 (8)
  ],
  [
    ["101", "111", "181", "609", "619", "689", "808", "818", "888", "906", "916", "986"], # 12 (19)
    ["000", "010", "080", "101", "111", "181", "609", "619", "689", "808", "818", "888", "906", "916", "986"] # 15 (23)
  ],
  [
    ["1001", "1111", "1691", "1881", "1961", "6009", "6119", "6699", "6889", "6969", "8008", "8118", "8698", "8888", "8968", "9006", "9116", "9696", "9886", "9966"], # 20 (39)
    ["0000", "0110", "0690", "0880", "0960", "1001", "1111", "1691", "1881", "1961", "6009", "6119", "6699", "6889", "6969", "8008", "8118", "8698", "8888", "8968", "9006", "9116", "9696", "9886", "9966"] # 25 (48)
  ],
  [
    ["10001", "10101", "10801", "11011", "11111", "11811", "16091", "16191", "16891", "18081", "18181", "18881", "19061", "19161", "19861", "60009", "60109", "60809", "61019", "61119", "61819", "66099", "66199", "66899", "68089", "68189", "68889", "69069", "69169", "69869", "80008", "80108", "80808", "81018", "81118", "81818", "86098", "86198", "86898", "88088", "88188", "88888", "89068", "89168", "89868", "90006", "90106", "90806", "91016", "91116", "91816", "96096", "96196", "96896", "98086", "98186", "98886", "99066", "99166", "99866"], # 60 (99)
    ["00000", "00100", "00800", "01010", "01110", "01810", "06090", "06190", "06890", "08080", "08180", "08880", "09060", "09160", "09860", "10001", "10101", "10801", "11011", "11111", "11811", "16091", "16191", "16891", "18081", "18181", "18881", "19061", "19161", "19861", "60009", "60109", "60809", "61019", "61119", "61819", "66099", "66199", "66899", "68089", "68189", "68889", "69069", "69169", "69869", "80008", "80108", "80808", "81018", "81118", "81818", "86098", "86198", "86898", "88088", "88188", "88888", "89068", "89168", "89868", "90006", "90106", "90806", "91016", "91116", "91816", "96096", "96196", "96896", "98086", "98186", "98886", "99066", "99166", "99866"] # 75 (123)
  ]
]

# решение

nums = [0, 3, 5]
40.times{ nums << nums[-2] * 5 }
NUMS5 = nums                                        # [0,   3, 5, 15, 25, 75, 125, 375, 625, 1875]
NUMS4 = nums[0..1] + nums[2..-1].map{|n| n / 5 * 4} # [0,   3, 4, 12, 20, 60, 100, 300, 500, 1500]

def for_if5(x) # диапазоны, числа в которых будем проверять и далее с усечением крайних цифр(остальные просто 1 подсчет)
  size = x.size
  mid = size.odd? ? '8' : '' # центральная 8 для нечетных
  first = '0' * (size - 2)
  last = '9' * ((size - 2) / 2) + mid + '6' * ((size - 2) / 2)
  for_if5 = ["00", "11", "69", "88", "96"].map{|n| [n[0] + first + n[-1], n[0] + last + n[-1]]}
end #=> ["00000"..."09860", "10001"..."19861", "60009"..."69869", "80008"..."89868", "90006"..."99866"]  # lkz size == 5

def upside_down_helper(x)
  res = NUMS4[0...x.size].sum # все перевернутые числа на порядок ниже
  # p "--- #{res} ---"
  nums4 = true
  loop do
    if x.size == 1
      return res + ["0", "1", "8"].count{|n| n <= x} if nums4
      return res + ["1", "8"].count{|n| n <= x}
    end

    # перенести вне цикла вверх ?
    return res if nums4 && x < '1'+'0'*(x.size-2)+'1' # если стартовые числа больше порядка ниже на 1(пр 10000)

    if x.size == 2
      return res + if nums4
        ["11", "69", "88", "96"].count{|n| n <= x}
      else
        ["00", "11", "69", "88", "96"].count{|n| n <= x}
      end
    end

    ranges = for_if5(x)
    ranges = ranges[1..-1] if nums4

    # p ranges

    if ranges.all?{|min, max| x < min or x >= max} # числа вне диапазонов(считать внутренние числа не нужно)
      # p "out of ranges"
      k = if x >= ranges[-1][1] # x > '9''6' # проверяем крайние числа
        5
      elsif x >= ranges[-2][1] && x < ranges[-1][0] # x > '8''8'
        4
      elsif x >= ranges[-3][1] && x < ranges[-2][0] # x > '6''9'
        3
      elsif x >= ranges[-4][1] && x < ranges[-3][0] #x > '1''1'
        2
      else
        1
      end
      # p k
      if nums4
        k -= 1
        r = NUMS4[x.size] / 4 * k
      else
        x = x[1..-2]
        r = NUMS5[x.size] # все числа тк берем уже от числа усеченного
      end
      res += r
      return res
    else
      # p "in ranges"
      # p ranges

      k = if x >= ranges[-1][0] && x < ranges[-1][1] # проверяем диапазоны
        5
      elsif x >= ranges[-2][0] && x < ranges[-2][1]
        4
      elsif x >= ranges[-3][0] && x < ranges[-3][1]
        3
      elsif x >= ranges[-4][0] && x < ranges[-4][1]
        2
      else
        1
      end

      k -= 1 if nums4

      x = x[1..-2]
      r = NUMS5[x.size] / 5 * k # только числа по коэфу

      # p [res, x, k, r]

      res += r

      # p res
    end

    nums4 = false
  end
  res
end

def upside_down(x, y)
  upside_down_helper(x)
  # upside_down_helper(y)
  # upside_down_helper(y) - upside_down_helper(x)
end

# p upside_down('0','10')#3

# p upside_down('6','25')#2
# p upside_down('10','100')#4
# p upside_down('100','1000')#12
# p upside_down('1000', '10000')#20
# p upside_down('10000', '15000')#6
# p upside_down('15000', '20000')#9
# p upside_down('60000', '70000')#15
# p upside_down('60000', '130000')#55
# p upside_down('100000','12345678900000000')#718650
# p upside_down('10000000000','10000000000000000000000')#78120000

p upside_down('8665','98187')#

# p upside_down('861813545615','9813815838784151548487')#74745418
# p upside_down('5748392065435706','643572652056324089572278742')#2978125000
# p upside_down('9090908074312','617239057843276275839275848')#2919867187

# p upside_down('1','45898942362076547326957326537845432452352')#209808349609373


# Knight's Attack!  https://www.codewars.com/kata/58e6d83e19af2cb8840000b5/train/ruby   (непонятно как найти закрытые позиции)
require 'set'

def attack(start, dest, obstacles)
  p [start, dest]
  p obstacles

  return 0 if start == dest
  obstacles = obstacles.to_set
  return nil if obstacles.include?(dest)
  moves = Set.new
  no = [[start]]
  mvs = [[1, -2], [2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2]]
  count = 0
  while count < 200 # loop do
    arr = []
    return nil if no[count] == []
    no[count].each do |y, x|
      mvs.each do |i, j|
        a = [y+i, x+j]
        return count + 1 if a == dest
        if y+i >= 0 && x+j >=0 && !obstacles.include?(a) && !moves.include?(a)
          arr << a
          moves << a
        end
      end
    end
    no << arr
    count += 1
  end
  nil
end
