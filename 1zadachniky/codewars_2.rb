# Break the pieces
# https://www.codewars.com/kata/527fde8d24b9309d9b000c4e/train/ruby

# проблема в обрезке, обрезает то что используется похоже
class Breaker
  # attr_reader :ceils
  def initialize(shape)
    # @ceils_check - для проверки тк @ceils меняет элементы на ' '
    @ceils_check = shape.split("\n").map.with_index{|a, y| a.split('').map.with_index{|e, x| [[y, x], e]}}.flatten(1).to_h
    @ceils = shape.split("\n").map.with_index{|a, y| a.split('').map.with_index{|e, x| [[y, x], e]}}.flatten(1).to_h
    @y, @x, @my, @mx = nil, nil, @ceils.keys.max_by(&:first)[0], @ceils.keys.max_by(&:last)[1]

    @dir = :U  # текущее направление, тк необходимо вправо на стартовом перекрестке
    @ruld = {R: %i[D R U], U: %i[R U L], L: %i[U L D], D: %i[L D R]} # следующее направление
    @dk = {R: {y: 0, x: 1}, U: {y: -1, x: 0}, L: {y: 0, x: -1}, D: {y: 1, x: 0}} # координаты точки по следующему направлению

    @piece_border = []
    @pieces = []
  end

  def main
    until @ceils.values.all?{|e| e == ' '}
      find_start_cross
      find_piece
      break_piece
      @pieces << [*@piece_border] # получаем только обводки
      @piece_border = []
    end

    # создаем куски по обводкам
    @pieces.map do |piece|
      arr = [] # для элементов куска
      piece.map do |y, x|
        arr[y] = [] if !arr[y]
        arr[y][x] = @ceils_check[[y, x]]
      end
      arr = arr.compact.map{|a| a.map{|e| e ? e : ' '}} # убираем лишние нилы и меняем остальные на ' '
      im, jm = arr[0].size-1, 0 # мин и макс индекс по оси х, в которых находится самый ближний и дальний элемент
      arr.each do |a|
        i, j = a.index{|e| e != ' '}, a.rindex{|e| e != ' '}
        im = i if i < im
        jm = j if j > jm
      end
      arr = arr.map{|a| a[im..jm]} # обрезаем лишнее спара и слева

      # убираем лишние + (когда с обоих сторон одинаковые элементы)
      arr = arr.map.with_index do |a, i|
        a.map.with_index do |el, j|
          if el == '+'
            a = i+1 < arr.size ? arr[i+1][j] : nil
            b = i-1 >= 0 ? arr[i-1][j] : nil
            els = [a, b, arr[i][j+1], arr[i][j-1]].select{|e| e && e != ' '}#.uniq.size == 1
            el = els[0] if els.uniq.size == 1
          end
          el
        end
      end

      arr.map(&:join)#.join("\n")
    end

  end

  def find_start_cross
    (0..@my).find{|i| (0..@mx).find{|j| @y, @x = i, j if @ceils[[i, j]] == '+'} }
  end

  def find_piece
    @piece_border << [@y, @x] # точка стартоового +

    until @piece_border.size >= 4 && @piece_border[0] == @piece_border[-1]
      if @ceils[[@y, @x]] == '+'
        @dir = @ruld.find{|k, _| k == @dir}[1].find{|d| ['-', '|'].include?(@ceils[[@y + @dk[d][:y],  + @x + @dk[d][:x]]]) }
      end
      @y += @dk[@dir][:y]
      @x += @dk[@dir][:x]
      @piece_border << [@y, @x]
    end
    @piece_border = @piece_border[0..-2]

    @dir = :U # возврат на стартовое направление
  end

  def break_piece # в зависимости от того был ли на последнем перекрестке альтернативный путь. Удаляем метки(+ | -) если не было и не удаляем если был
    # start = true
    @delete_border = []
    # поиск
    @piece_border.each do |y, x|
      if @ceils[[y, x]] == '+'
        count = [[y+1, x], [y-1, x], [y, x+1], [y, x-1]].count{|i, j| @ceils[[i, j]] && ['-', '|'].include?(@ceils[[i, j]])}
        @delete = count < 3 ? true : false # включаеим удаление если 2 направления
      end
      @delete_border << [y, x] if @delete
    end
    @piece_border.reverse.each.with_index do |(y, x), i|
      if @ceils[[y, x]] == '+' || i == 0
        count = [[y+1, x], [y-1, x], [y, x+1], [y, x-1]].count{|i, j| @ceils[[i, j]] && ['-', '|'].include?(@ceils[[i, j]])}
        @delete = count < 3 ? true : false # включаеим удаление если 2 направления
      end
      @delete_border << [y, x] if @delete
    end
    # замена на ' '
    @delete_border.uniq.each{|y, x| @ceils[[y, x]] = ' '}
  end
end

def break_pieces(shape)
  # p shape.split("\n")
  breaker = Breaker.new(shape)
  # breaker.find_start_cross
  # breaker.find_piece
  # breaker.break_piece
  breaker.main
  # breaker.ceils.map{|k, v| v}.each_slice(shape.split("\n")[0].size).map(&:join)
end

shape = "+-------------------+--+\n|                   |  |\n|                   |  |\n|  +----------------+  |\n|  |                   |\n|  |                   |\n+--+-------------------+"

[
  "+-------------------+--+",
  "|                   |  |",
  "|                   |  |",
  "|  +----------------+  |",
  "|  |                   |",
  "|  |                   |",
  "+--+-------------------+"
]

p break_pieces(shape) # solution
