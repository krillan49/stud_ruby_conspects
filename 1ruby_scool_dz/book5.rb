# Пример JSON-структуры, описывающей приложение.  p154-155

# Напишите хеш, который бы отображал состояние следующего приложения:
@online_bank = {
  name: 'Герман Оскарович Блокчейн',
  balance: 123.45,
  transactions: [
    { name: 'Сапоги', tipe: 'расход', price: 40 },
    { name: 'Зарплата', tipe: 'приход', price: 1000 },
    { name: 'Продажа ваучера', tipe: 'приход', price: 300 },
    { name: 'Велосипед', tipe: 'расход', price: 200 },
    { name: 'Протез', tipe: 'расход', price: 300 }
  ],
  visibility_fiter: :show_all
}

# Напишите программу, которая будет принимать хеш, который вы определили в предыдущей задаче, и выводить результат на экран. Убедитесь, что переключатель работает и программа не выводит приход, если переключатель включен.

# Methods----------------------------------------------------------------------------------------------------
def new_transactions
  print 'Введите имя операции '
  name = gets.strip.capitalize
  print 'Введите тип операции(приход/расход) '
  tipe = gets.strip.downcase
  print 'Введите сумму '
  price = gets.to_i

  @online_bank[:transactions] << {name:, tipe:, price:}

  if tipe == 'приход'
    @online_bank[:balance] += price
  elsif tipe == 'расход'
    @online_bank[:balance] -= price
  end

end


def show_transactions
  print 'Показать все операции(1), показать только приход(2), показать только расход(3) '
  trans_tipe_choose = gets.to_i

  puts '-' * 40
  puts @online_bank[:name]
  puts "#{@online_bank[:balance]}$"

  @online_bank[:transactions].each do |el|
    case trans_tipe_choose
    when 1
      @online_bank[:visibility_fiter] = :show_all
      puts "#{el[:name]} - #{el[:price]}$(#{el[:tipe]})"
    when 2
      @online_bank[:visibility_fiter] = :show_plus
      puts "#{el[:name]} - #{el[:price]}$" if el[:tipe] == 'приход'
    when 3
      @online_bank[:visibility_fiter] = :show_minus
      puts "#{el[:name]} - #{el[:price]}$" if el[:tipe] == 'расход'
    end
  end
  puts '-' * 40
end
#-----------------------------------------------------------------------------------------------------

#Main=================================================================================================
loop do
  print 'Добавить операцию(1), показать список операций(2), выход(Enter) '
  choose = gets.to_i

  break if choose == ''

  new_transactions if choose == 1

  show_transactions if choose == 2

end
#======================================================================================================
