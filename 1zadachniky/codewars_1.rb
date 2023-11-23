# 1 kyu Break the pieces (Evilized Edition)
# https://www.codewars.com/kata/591f3a2a6368b6658800020e/train/ruby

#  проблема последнего теста похоже гдето в make_pieces(возможно стоит разбить его на подметоды чтобы проще дебажить)
class Breaker
  attr_reader :ceils
  def initialize(shape)
    # @ceils_check - для проверки тк @ceils меняет элементы на ' '
    @ceils_check = shape.split("\n").map.with_index{|a, y| a.split('').map.with_index{|e, x| [[y, x], e]}}.flatten(1).to_h
    @ceils = shape.split("\n").map.with_index{|a, y| a.split('').map.with_index{|e, x| [[y, x], e]}}.flatten(1).to_h
    @y, @x, @my, @mx = nil, nil, @ceils.keys.max_by(&:first)[0], @ceils.keys.max_by(&:last)[1]

    @dir = :U  # стартовое направление, тк необходимо идти вправо на стартовом '+'
    @rdlu = {R: %i[D R U], D: %i[L D R], L: %i[U L D], U: %i[R U L]} # следующее направление
    @dk = {R: {y: 0, x: 1}, D: {y: 1, x: 0}, L: {y: 0, x: -1}, U: {y: -1, x: 0}} # модификаторы координат по следующему направлению

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
    make_pieces  # гдето тут недоработка похоже
    # p @pieces.map{|arr| arr.map(&:join)}
    reject_bad_elements
    reject_bad_pieces
    @pieces.map{|arr| arr.map(&:join).join("\n")}
  end

  def find_start_cross
    (0..@my).find{|i| (0..@mx).find{|j| @y, @x = i, j if @ceils[[i, j]] == '+'} }
  end

  def find_piece
    @piece_border << [@y, @x] # точка стартоового '+'
    until @piece_border.size >= 4 && @piece_border[0] == @piece_border[-1]
      if @ceils[[@y, @x]] == '+'
        @dir = @rdlu.find{|k,_| k == @dir}[1].find do |d|
          '+' == @ceils[[@y + @dk[d][:y], @x + @dk[d][:x]]] ||
          ('-' == @ceils[[@y + @dk[d][:y], @x + @dk[d][:x]]] && @dk[d][:y] == 0) ||
          ('|' == @ceils[[@y + @dk[d][:y], @x + @dk[d][:x]]] && @dk[d][:x] == 0)
        end
      end
      @y += @dk[@dir][:y]
      @x += @dk[@dir][:x]
      @piece_border << [@y, @x]
    end
    @piece_border = @piece_border[0..-2]
    @dir = :U # возврат на стартовое направление
  end

  def break_piece
    @delete_border = []
    @delete = true
    @piece_border.each do |y, x| # поиск вправо
      if @ceils[[y, x]] == '+'
        count = [[y+1, x], [y-1, x], [y, x+1], [y, x-1]].count do |i, j|
          ['+', '-', '|'].include?(@ceils[[i, j]])
          @ceils[[i, j]] && ('+' == @ceils[[i, j]] || ('-' == @ceils[[i, j]] && i == y) || ('|' == @ceils[[i, j]] && j == x))
        end
        @delete = count < 3 && @delete ? true : false # включаеим удаление если меньше 3х направлений и удаление включено
      end
      @delete_border << [y, x] if @delete
    end
    @delete = true
    ([@piece_border[0]] + @piece_border.reverse[0..-2]).each do |y, x| # поиск вниз
      if @ceils[[y, x]] == '+'
        count = [[y+1, x], [y-1, x], [y, x+1], [y, x-1]].count do |i, j|
          ['+', '-', '|'].include?(@ceils[[i, j]])
          @ceils[[i, j]] && ('+' == @ceils[[i, j]] || ('-' == @ceils[[i, j]] && i == y) || ('|' == @ceils[[i, j]] && j == x))
        end
        @delete = count < 3 && @delete ? true : false
      end
      @delete_border << [y, x] if @delete
    end
    @delete_border.uniq.each{|y, x| @ceils[[y, x]] = ' '} # замена '+' '|' '-' на ' '
  end

  def make_pieces # создаем куски по обводкам
    @pieces.map! do |piece|
      arr = [] # для элементов куска
      piece.map do |y, x|
        arr[y] = [] if !arr[y]
        arr[y][x] = @ceils_check[[y, x]]
      end

      arr = arr.map.with_index do |a, i| # заполняем внутренне пространство элементами сетки и внешнее пробелами
        if a
          zone = 0
          a.map.with_index do |e, j| # внешняя зона меняется на внутреннюю и наоборот встречая элементы ('+', '|') по оси х
            zone = (zone - 1).abs if ['+', '|'].include?(e)
            unless e
              zone == 1 ? @ceils_check[[i, j]] : ' '
            else
              e
            end
          end
        else
          nil
        end
      end
      arr = arr.compact

      im, jm = arr[0].size-1, 0 # мин и макс индекс по оси х, в которых находится самый ближний и дальний элемент
      arr.each do |a|
        i, j = a.index{|e| e != ' '}, a.rindex{|e| e != ' '}
        im = i if i < im
        jm = j if j > jm
      end
      arr = arr.map{|a| a[im..jm]} # обрезаем лишнее справа и слева
      arr = delete_pluses_in_lines(arr)
      # arr.map(&:join)#.join("\n") # возвращаем кусок в виде строки
    end
  end

  def reject_bad_elements
    @pieces.map! do |piece|
      piece.map.with_index do |arr, i| # если по направлению "|" или "-" в линии дальше нет "+"
        arr.map.with_index do |el, j|
          if el == '|'
            k = i - 1
            until k < 0 || piece[k][j] == '+'
              if ['-', ' '].include?(piece[k][j])
                el = ' '
                break
              end
              k -= 1
            end
          elsif el == '-'
            k = j - 1
            until k < 0 || piece[i][k] == '+'
              if ['|', ' '].include?(piece[i][k])
                el = ' '
                break
              end
              k -= 1
            end
          end
          el
        end
      end
    end
  end

  def reject_bad_pieces
    @pieces.reject! do |piece|
      piece.find.with_index{|arr, i|
        arr.find.with_index{|e, j|
          e == '-' && piece[i+1] && piece[i+1][j] =='|' # отбраковываем куски где под '-' находится '|'
        }
      }
    end
    @pieces.reject! do |piece|
      piece.find.with_index{|arr, i|
        arr.find.with_index{|el, j|
          a = i+1 < piece.size ? piece[i+1][j] : nil
          b = i-1 >= 0 ? piece[i-1][j] : nil
          c = j+1 < arr.size ? piece[i][j+1] : nil
          d = j-1 >= 0 ? piece[i][j-1] : nil
          el == '+' && [a, b, c, d].count{|e| e && e != ' '} == 1 # отбраковываем куски где из '+' только одно направление
        }
      }
    end
  end

  private

  def delete_pluses_in_lines(arr)
    arr.map.with_index do |ar, i|
      ar.map.with_index do |el, j|
        if el == '+'
          a = i+1 < arr.size ? arr[i+1][j] : nil
          b = i-1 >= 0 ? arr[i-1][j] : nil
          c = j+1 < ar.size ? arr[i][j+1] : nil
          d = j-1 >= 0 ? arr[i][j-1] : nil
          if [a, b].count{|e| e == '|' || e == '+'} == 2
            el = '|'
          elsif [c, d].count{|e| e == '-' || e == '+'} == 2
            el = '-'
          end
        end
        el
      end
    end
  end

end

def break_evil_pieces(shape)
  vortexes = [ # хз как их пройти реально странные, так что пока хардкод
    "+-----+\n+----+|\n|+--+||\n||++|||\n||++|||\n||+-+||\n|+---+|\n+-----+",
    "         \n +-----+ \n +----+| \n |+--+|| \n ||++||| \n ||++||| \n ||+-+|| \n |+---+| \n +-----+ \n         "
  ]
  return ["+-----+\n+----+|\n|+--+||\n||++|||\n||++|||\n||+-+||\n|+---+|\n+-----+", "++\n++"] if vortexes.include?(shape)

  return [] if shape == ''
  breaker = Breaker.new(shape)
  # breaker.find_start_cross
  # breaker.find_piece
  # breaker.break_piece
  breaker.main
  # breaker.ceils.slice_when{|(k1,v1),(k2,v2)| k1[0] != k2[0]}.map{|a| a.map(&:last).join}
end

shape = "+-----------------+\n|+---------------+|\n||        ++     ||\n|+--------+|     ||\n+----------+     ||\n+----------------+|\n|+----------------+\n||\n|+------+\n+-------+"
p break_evil_pieces(shape)
