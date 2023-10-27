# Break the pieces
# https://www.codewars.com/kata/527fde8d24b9309d9b000c4e/train/ruby

# Реализация обрезки: в зависимости от того был ли на помледнем перекрестке альтернативный путь. Удаляем метки(+ | -) если не было и не удаляем если был

# Какаято ошибка с выбором направления, гдето не так поворачивает
class Breaker
  def initialize(shape)
    @ceils = shape.split("\n").map.with_index{|a, y| a.split('').map.with_index{|e, x| [[y, x], e]}}.flatten(1).to_h
    @y, @x, @my, @mx = nil, nil, @ceils.keys.max_by(&:first)[0], @ceils.keys.max_by(&:last)[1]

    @dir = :R  # текущее направление
    @ruld = {R: %i[D R U], U: %i[R U L], L: %i[U L D], D: %i[L D R]} # следующее направление
    @dk = {R: {y: 0, x: 1}, U: {y: -1, x: 0}, L: {y: 0, x: -1}, D: {y: 1, x: 0}} # координаты точки по следующему направлению

    @piece_border = []
  end

  def find_start_cross
    (0..@my).find{|i| (0..@mx).find{|j| @y, @x = i, j if @ceils[[i, j]] == '+'} }
  end

  def find_piece
    @piece_border << [@y, @x]

    # until @piece_border.size >= 4 && @piece_border[0] == @piece_border[-1]
    #   if @ceils[[@y, @x]] == '+'
    #     @dir = @ruld.find{|k, _| k == @dir}[1].find{|d| @ceils[[@dk[d][:y] + @y, @dk[d][:x] + @x]]}
    #   end
    #   @y += @dk[@dir][:y]
    #   @x += @dk[@dir][:x]
    #   @piece_border << [@y, @x]
    # end
    # @piece_border = @piece_border[0..-2]

    if @ceils[[@y, @x]] == '+'
      @dir = @ruld.find{|k, _| k == @dir}[1].find{|d| @ceils[[@dk[d][:y] + @y, @dk[d][:x] + @x]]}
    end
    @y += @dk[@dir][:y]
    @x += @dk[@dir][:x]
    @piece_border << [@y, @x]
  end

  def break_piece
    @piece_border
  end
end

def break_pieces(shape)
  breaker = Breaker.new(shape)
  breaker.find_start_cross
  breaker.find_piece
  breaker.break_piece
end

shape = ["+------------+",
         "|            |",
         "|            |",
         "|            |",
         "+------+-----+",
         "|      |     |",
         "|      |     |",
         "+------+-----+"].join("\n")

solution = [["+------------+",
             "|            |",
             "|            |",
             "|            |",
             "+------------+"].join("\n"),
            ["+------+",
             "|      |",
             "|      |",
             "+------+"].join("\n"),
            ["+-----+",
             "|     |",
             "|     |",
             "+-----+"].join("\n")]
p break_pieces(shape) # solution
