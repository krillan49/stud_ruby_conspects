# Обращение к массиву массивов  page128

# есть номера телефонов с буквами. существует номер “555-MATRESS”, который транслируется в “555-628-7377”. Когда наши клиенты набирают буквенный номер на клавиатуре телефона (см.картинку ниже), он транслируется в цифровой. Напишите программу, которая будет переводить (транслировать) слово без дефисов в телефонный номер.

def phone_to_number(phone)
  arr = [
    %w(A B C),
    %w(D E F),
    %w(G H I),
    %w(J K L),
    %w(M N O),
    %w(P Q R S),
    %w(T U V),
    %w(W X Y Z)
  ]

  phone_s = phone[3..-1].chars

  phone_new = [5, 5, 5]
  phone_s.each do |character|
    arr.each_with_index do |arr0, i|
      if arr0.include?(character)
        phone_new << (i + 2)
      end
    end
  end

  phone_new.join.to_i
end

puts phone_to_number('555MATRESS') # должно напечатать 5556287377
puts phone_to_number('555XUETA')
