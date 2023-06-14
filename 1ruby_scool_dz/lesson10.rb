# УРОК 10. Игра "Камень, ножницы, бумага"
# Дополнено: result_round_v2 Дополнительный метод сравнения результатов игрока и бота

@rsp = [:rock, :scissors, :paper]

# Блоки используемых функций -------------------------------------------------------------------------------------------

def bot_move  # Метод хода бота
	choose = rand(0..2)
	@bot_choose = @rsp[choose]
	puts "Bot choose: #{@rsp[choose]}"
end

def pl_move # Метод xoда игрока
	print "Choose (R)ock, (S)cissors or (P)aper "
	choose = gets.strip.upcase
	if choose != "R" and choose != "S" and choose != "P"
		puts "Wrong character, now random choose for you"
		choose = rand(0..2)
  elsif choose == "R"
    choose = 0
  elsif choose == "S"
    choose = 1
  elsif choose == "P"
    choose = 2
	end
  @pl_choose = @rsp[choose]
  puts "Your choose: #{@rsp[choose]}"
end

def result_round # Метод сравнения результатов игрока и бота с использованием одного условного оператора
	if @pl_choose == @bot_choose
		puts "Draw"
	elsif (@pl_choose == :rock and @bot_choose == :scissors) or (@pl_choose == :scissors and @bot_choose == :paper) or (@pl_choose == :paper and @bot_choose == :rock)
		puts "You won"
		@pl_points += 1
	else
		puts "You loose"
		@bot_points += 1
	end
	puts "Your points - #{@pl_points}. Bot points - #{@bot_points}."
end

def result_round_v2 # Метод сравнения результатов игрока и бота с использованием двумерного массива(вариант 2)
  @matrix = [
    [:rock, :rock, :draw],
    [:rock, :scissors, :pl_win],
    [:rock, :paper, :bot_win],
    [:scissors, :rock, :bot_win],
    [:scissors, :scissors, :draw],
    [:scissors, :paper, :pl_win],
    [:paper, :rock, :pl_win],
    [:paper, :scissors, :bot_win],
    [:paper, :paper, :draw]
  ]
  @matrix.each do |el|
    if el[0] == @pl_choose && el[1] == @bot_choose
      if el[2] == :pl_win
        puts "You won"
    		@pl_points += 1
      elsif el[2] == :bot_win
        puts "You loose"
    		@bot_points += 1
      else
        puts "Draw"
      end
    end
  end
  puts "Your points - #{@pl_points}. Bot points - #{@bot_points}."
end

def result_game # Метод подсчета очков за результаты игр.
  if @pl_points > @bot_points
  	puts "You won the game"
  elsif @pl_points < @bot_points
  	puts "You loose the game"
  else
  	puts "Drow"
  end
end
#----------------------------------------------------------------------------------------------------------------------

# Выбор колличества игр
@pl_points = 0
@bot_points = 0
puts "Choose number of rounds "
rounds = gets.to_i

# Основной блок(ход игры) ==============================================================================================
round = 0
while round != rounds
	round += 1
	puts "------------- Round #{round} -------------"
	pl_move
	bot_move
	result_round_v2
end
result_game
#=======================================================================================================================
