# Другие объекты в качестве значений  стр  151


# Задание: корзина пользователя в Интернет-магазине определена следующим массивом (qty - количество единиц товара, которое пользователь хочет купить, type - тип):
cart = [
  { type: :soccer_ball, qty: 2 },
  { type: :tennis_ball, qty: 3 }
]
#А наличие на складе следующим хешем:
inventory = {
  soccer_ball: { available: 2, price_per_item: 100 },
  tennis_ball: { available: 1, price_per_item: 30 },
  golf_ball: { available: 5, price_per_item: 5 }
}
# Написать программу, которая выводит на экран цену всех товаров в корзине (total), а также сообщает - возможно ли удовлетворить запрос пользователя - набрать все единицы товара, которые есть на складе.

#prise = cart[0][:qty] * inventory[:soccer_ball][:price_per_item] + cart[1][:qty] * inventory[:tennis_ball][:price_per_item]
prise = 0
cart.each do |hh|
  prise_type = 0
  inventory.each do |k, v|
    if hh[:type] == k
      prise_type = hh[:qty] * v[:price_per_item] # цена штук одного товара

      if hh[:qty] > v[:available] # проверка наличия товара
        puts "Оut of stock #{hh[:qty]} #{hh[:type]}s. You cаn buy only #{v[:available]}"
        prise_type = v[:available] * v[:price_per_item]
        puts "Prise for #{v[:available]} #{hh[:type]}s is #{prise_type}"
      else
        puts "Prise for #{hh[:qty]} #{hh[:type]}s is #{prise_type}"
      end
    end
  end
  prise += prise_type # цена всех товаров в корзине (total)
end
puts "Prise for all is #{prise}"
