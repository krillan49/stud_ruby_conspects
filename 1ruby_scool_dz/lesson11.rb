# УРОК 11 =====================================

# Маленькое подзадание для повторения урока 10: Создать массив имен с помощью %w, вывести все имена с порядковым номером с помощью ич виз индекс
def small_arr()
  names = %w[Vasya Petya Vova Sergey Jenya]
  names.each_with_index do |name, i|
    puts "#{i + 1}. #{name}"
  end
end
#-----------------------------------------------------------------------------------------------------


# Англорусский словарь с вариантами переводов например "кошка и кот" в массиве являющ значением хэша. Он будет выводить а.коллич переводов слова и б.сами переводы слова.
dict = {
	'cat' => ['кошка', 'кот', 'кашара'],
	'dog' => ['собака'],
	'girl' => ['девушка', 'девочка']
}

loop do
  puts '--------------------------------------------'
	print 'Введите слово на английском(Enter не вводя символы для выхода) '
	word = gets.strip.downcase

	if word == ''
		break
	end

  if dict[word].size > 1
    puts "Колличество вариантов перевода #{dict[word].size}"
  end

  dict[word].each_with_index do |wordRU, i|
    if dict[word].size > 1
      puts "#{i + 1}й вариант перевода: #{wordRU}"
    else
      puts "Перевод: #{wordRU}"
    end
  end

end
#--------------------------------------------------------------------------------------------------------


# Переделанная игра "камень ножницы бумага" с использованием хэша
hands = [:rock, :scissors, :paper]

loop do

  pl_choose = ""
  while pl_choose != "R" and pl_choose != "S" and pl_choose != "P" and pl_choose != "E"
    print "Enter (R)ock, (S)cissors, (P)aper or (E)xit game "
    pl_choose = gets.strip.upcase
  end

  if pl_choose == "E"
    puts "The game is over"
    exit
  elsif pl_choose == "R"
    choose = 0
  elsif pl_choose == "S"
    choose = 1
  elsif pl_choose == "P"
    choose = 2
  end

  pl_hand = hands[choose]
  puts "You choose #{pl_hand}"

  en_hand = hands[rand(0..2)]
  puts "Bot choose #{en_hand}"

  results = {
    "You win" => [[:rock, :scissors], [:scissors, :paper], [:paper, :rock]],
    "Bot win" => [[:rock, :paper], [:scissors, :rock], [:paper, :scissors]],
    "Draw" => [[:rock, :rock], [:scissors, :scissors], [:paper, :paper]]
  }

  results.each do |result, hands|
    #if hands.any? { |hand| hand == [pl_hand, en_hand] }
      #puts result
    #end
    if hands[0] == [pl_hand, en_hand] or hands[1] == [pl_hand, en_hand] or hands[2] == [pl_hand, en_hand]
      puts result
    end
    #hands.each do |el|
      #if el[0] == pl_hand and el[1] == en_hand
        #puts result
      #end
    #end
  end

end
