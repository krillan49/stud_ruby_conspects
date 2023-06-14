# УРОК 12 ==============================================================
# Игра "Крестики-нолики"("Tic Tac Toe")


# Базовое пустое поле ----------------------------------------------------------------------------
@board = [
  [' ', ' ', ' '],
  [' ', ' ', ' '],
  [' ', ' ', ' ']
]
#-----------------------------------------------------------------------------------------

# Методы =============================================================================================

# Отображаемое игровое поле ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def fild()
  print '    ', 1, '    ', 2, '    ', 3, "\n"
  print 1, ' ', @board[0], "\n"
  print 2, ' ', @board[1], "\n"
  print 3, ' ', @board[2], "\n"
end
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Ход игрока +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def pl_move()
  loop do
    puts 'select a sector in 3x3 board to move'
    print 'selet number of line(1, 2, 3) '
    pl_line = gets.to_i - 1
    print 'selet number of column(1, 2, 3) '
    pl_column = gets.to_i - 1

    if pl_line <= 2 and pl_line >= 0 and pl_column <= 2 and pl_column >= 0
      if @board[pl_line][pl_column] == ' '
        @board[pl_line][pl_column] = @ps
        puts "Your move is #{pl_line + 1} line, #{pl_column + 1} column"
        break
      else
        puts 'wrong move(not clear sector)'
      end
    else
      puts 'wrong move(wrong number)'
    end
  end
end
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Ход бота (ИИ умеет: победный ход, мешать победному ходу) ++++++++++++++++++++++++++++++++++++
def en_move()
  end_move = 0
  end_move2 = 0

  loop do

    if @board[1][1] == ' ' # ход по умолчанию центр или рандом
      en_line = 1
      en_column = 1
    else
      en_line = rand(3)
      en_column = rand(3)
    end

    # ИИ на победу ставит последний символ в линии столбце или накрест
    bot_signs = [0, 0, 0] # для поб столбцом
    spaces_signs = [0, 0, 0]
    @board.each_with_index do |fild_line, i|
      # ИИ найти победу по линии
      if fild_line.count(@bs) == 2 and fild_line.any?(' ')
        en_line = i and end_move = 1
        break
      end

      # ИИ найти победу по столбцам
      fild_line.each_with_index do |sign, i|
        bot_signs[i] += 1 if sign == @bs
        spaces_signs[i] += 1 if sign == ' '
      end

      3.times do |index_column|
        if bot_signs[index_column] == 2 and spaces_signs[index_column] == 1
          en_column = index_column
          end_move = 1
          break
        end
      end

      # ИИ найти победу накрест
      en_line = 0 and en_column = 0 and end_move = 1 if @board[1][1] == @bs and @board[2][2] == @bs and  @board[0][0] == ' '
      en_line = 1 and en_column = 1 and end_move = 1 if @board[0][0] == @bs and @board[2][2] == @bs and  @board[1][1] == ' '
      en_line = 2 and en_column = 2 and end_move = 1 if @board[0][0] == @bs and @board[1][1] == @bs and  @board[2][2] == ' '
      en_line = 0 and en_column = 2 and end_move = 1 if @board[1][1] == @bs and @board[2][0] == @bs and  @board[0][2] == ' '
      en_line = 1 and en_column = 1 and end_move = 1 if @board[0][2] == @bs and @board[2][0] == @bs and  @board[1][1] == ' '
      en_line = 2 and en_column = 0 and end_move = 1 if @board[0][2] == @bs and @board[1][1] == @bs and  @board[2][0] == ' '

    end

    # ИИ мешает игроку поставить последний символ в линии стролбце или накрест
    p0 = 0
    s0 = 0
    p1 = 0
    s1 = 0
    p2 = 0
    s2 = 0
    if end_move == 0
      @board.each_with_index do |fild_line, i|
        # ИИ мешает победить игроку по линии
        if fild_line.count(@ps) == 2 and fild_line.any?(' ')
          en_line = i
          end_move2 = 1
          break
        end
        # ИИ мешает победить игроку по столбцам
        p0 += 1 if fild_line[0] == @ps
        s0 += 1 if fild_line[0] == ' '
        p1 += 1 if fild_line[1] == @ps
        s1 += 1 if fild_line[1] == ' '
        p2 += 1 if fild_line[2] == @ps
        s2 += 1 if fild_line[2] == ' '
        en_column = 0 and end_move2 = 1 if p0 == 2 and s0 == 1
        en_column = 1 and end_move2 = 1 if p1 == 2 and s1 == 1
        en_column = 2 and end_move2 = 1 if p2 == 2 and s2 == 1
        break if (p0 == 2 and s0 == 1) or (p1 == 2 and s1 == 1) or (p2 == 2 and s2 == 1)

        # ИИ мешает победить игроку по накрест
        en_line = 0 and en_column = 0 and end_move2 = 1 if @board[1][1] == @ps and @board[2][2] == @ps and  @board[0][0] == ' '
        en_line = 1 and en_column = 1 and end_move2 = 1 if @board[0][0] == @ps and @board[2][2] == @ps and  @board[1][1] == ' '
        en_line = 2 and en_column = 2 and end_move2 = 1 if @board[0][0] == @ps and @board[1][1] == @ps and  @board[2][2] == ' '
        en_line = 0 and en_column = 2 and end_move2 = 1 if @board[1][1] == @ps and @board[2][0] == @ps and  @board[0][2] == ' '
        en_line = 1 and en_column = 1 and end_move2 = 1 if @board[0][2] == @ps and @board[2][0] == @ps and  @board[1][1] == ' '
        en_line = 2 and en_column = 0 and end_move2 = 1 if @board[0][2] == @ps and @board[1][1] == @ps and  @board[2][0] == ' '

      end

    end

    # ИИ ставит свой знак в свою строку столбец(накрест не доделан)
    if end_move == 0 and end_move2 == 0
      bot_signs = [0, 0, 0]
      spaces_signs = [0, 0, 0]
      @board.each_with_index do |fild_line, i|
        # ИИ найти свою линию для хода
        if fild_line.count(@bs) == 1 and fild_line.count(' ') == 2
          en_line = i
          break
        end

        # ИИ найти свой столбец для ходпа
        fild_line.each_with_index do |sign, i|
          bot_signs[i] += 1 if sign == @bs
          spaces_signs[i] += 1 if sign == ' '
        end

        3.times do |index_column|
          if bot_signs[index_column] == 1 and spaces_signs[index_column] == 2
            en_column = index_column
            break
          end
        end

        # ИИ найти найти свой накрест для хода

      end
    end

    if @board[en_line][en_column] == ' '
      @board[en_line][en_column] = @bs
      puts "Bot move is #{en_line + 1} line, #{en_column + 1} column"
      break
    end
  end
end
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Победа игрока ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def pl_win()
  p0 = 0
  p1 = 0
  p2 = 0
  @board.each do |fild_line|
    # линии
    if fild_line.all? {|el| el == @ps}
      puts "You win"
      exit
    end
    # столбцы
    p0 += 1 if fild_line[0] == @ps
    p1 += 1 if fild_line[1] == @ps
    p2 += 1 if fild_line[2] == @ps
    if p0 == 3 or p1 == 3 or p2 == 3
      puts "You win"
      exit
    end
  end
  # накрест
  if (@board[0][0] == @ps and @board[1][1] == @ps and @board[2][2] == @ps) or (@board[0][2] == @ps and @board[1][1] == @ps and @board[2][0] == @ps)
    puts "You win"
    exit
  end
end
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Ничья +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def draw()
  n = 0
  @board.each do |fild_line|
    if fild_line.all? {|el| el != ' '}
      n += 1
    end
  end
  puts "Draw" if n == 3
  exit if n == 3
end
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Победа бота ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def en_win()
  b0 = 0
  b1 = 0
  b2 = 0
  @board.each do |fild_line|
    # линии
    if fild_line.all? {|el| el == @bs}
      puts "You loose"
      exit
    end
    # столбцы
    b0 += 1 if fild_line[0] == @bs
    b1 += 1 if fild_line[1] == @bs
    b2 += 1 if fild_line[2] == @bs
    if b0 == 3 or b1 == 3 or b2 == 3
      puts "You loose"
      exit
    end
  end
  # накрест
  if (@board[0][0] == @bs and @board[1][1] == @bs and @board[2][2] == @bs) or (@board[0][2] == @bs and @board[1][1] == @bs and @board[2][0] == @bs)
    puts "You loose"
    exit
  end
end
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#===========================================================================================================

# Выбрать крестик или нолик ------------------------------------------------------------------
print 'choose your sign X or O '
loop do
  @ps = gets.strip.upcase
  if @ps == 'X' or @ps == 'O'
    break
  end
  print 'wrong sign, enter X or O '
end
@bs = 'O' if @ps == 'X'
@bs = 'X' if @ps == 'O'
puts "you will be play with #{@ps}, bot will be play with #{@bs}"
#-------------------------------------------------------------------------------------------------

# Игровой процесс ==================================================================================
first_move = rand(2)
fild if first_move == 0
puts 'Your move is first' if first_move == 0
puts 'Bot move is first' if first_move == 1
loop do
  pl_move if first_move == 0
  en_move if first_move == 1
  sleep 1 if first_move == 1

  fild
  pl_win if first_move == 0
  en_win if first_move == 1
  draw

  en_move if first_move == 0
  pl_move if first_move == 1
  sleep 1 if first_move == 0

  fild
  en_win if first_move == 0
  pl_win if first_move == 1
  draw
end
#========================================================================================================
