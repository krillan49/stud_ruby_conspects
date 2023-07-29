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
