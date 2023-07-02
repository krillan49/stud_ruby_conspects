// Функция с параметром для корзины товаров(пицы) в localstorage
function addToCart(id) {
  var x = window.localStorage.getItem('product_' + id); // тоесть ключи будут 'product_1', 'product_2' итд. Нужно для того чтоб отличать объекты в хэше, тк в localstorage мы можем хранить много всего, а не только пицы
  x = x * 1 + 1; // увеличиваем на 1 тк каждое нажатие на кнопку вызывает функцию.
  window.localStorage.setItem('product_' + id, x); // устанавливаем новое значение хэша(число товаров с этим айди в корзине)

  // alert('Items in your cart' + cart_get_number_of_items()) // для вывода в окне вызываем функцию счетчика, что сообщить об общем числе пиц

  // (см функции ниже) Обновляем значения в полях после нажатия кнопки и соотв изменения значений в локалсторедж
  update_orders_input(); // вызываем метод для обновления значения "product_1=3,product_2=5,product_3=1, ..." в скрытом поле
  update_orders_button(); // вызываем метод для обновления отображения счетчика всех товаров в значении кнопки
}


// Счетчик для общего количества товаров в корзине:
function cart_get_number_of_items() {
  var cnt = 0;

  for (var i = 0; i < window.localStorage.length; i++) { // от 0 до длинны локалсторедж(итератор/перебор чисел присвоенных в i)
    var key = window.localStorage.key(i); // получаем ключ по идексам ключей локалсторедж(от значений i по которым идет проход)
    var value = window.localStorage.getItem(key); // теперь по полученному выше ключу получаем значение из локалсорэдж

    if(key.indexOf('product_') == 0) {
      // cnt ++;  // прибавляем 1 если такой ключ существует(тоесть получим количество ключей начинающихся с 'product_')
      cnt = cnt + value * 1; // а так считаем сумму значений для всех подходящих ключей
    }
  }

  return cnt;
}


// Функция для получения(и дальнейшей отправки через форму на сервер) результата о заказах из localStorage вида "product_1=3,product_2=5,product_3=1, ..."
// Почти такая же по функционалу функция как и cart_get_number_of_items, за исключением замены cnt на orders
function сart_get_orders() {
  var orders = '';

  for (var i = 0; i < window.localStorage.length; i++){
    var key = window.localStorage.key(i); // получаем ключ
    var value = window.localStorage.getItem(key); // получаем значение

    if(key.indexOf('product_') == 0) {
      orders = orders + key + '=' + value + ','; // тут прибавляем один элемент результата например "product_1=3,"
    }
  }

  return orders; // "product_1=3,product_2=5,product_3=1, ..."
}


// Функция для того чтобы обратиться к полю в которое мы хотим поместить "product_1=3,product_2=5,product_3=1, ..." чтобы потом отправить этот результат на сервер.
function update_orders_input() {
  var orders = сart_get_orders(); //  "product_1=3,product_2=5,product_3=1, ..."

  // Используем джэйквери - для этого в лэйоут нужно подключть его, например так <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>  либо бутстрапное
  $('#orders_input').val(orders); // обращаемся к полю через его айди и вставляем в его значение(атрибут value) "product_1=3,product_2=5,product_3=1, ...". val(orders) - метод установки значений
}

// Функция для того чтобы обратиться к кнопке в имя которой мы хотим поместить общее число заказов чтобы информацию о заказах было видно клиенту.
function update_orders_button() {
  var text = 'Корзина (' + cart_get_number_of_items() + ' шт.)'; // Используем функцию с общим числом заказов
  $('#orders_button').val(text);
}

// Для очистки козины на странице подтвержден. И для очиски информации об отмененном заказе
function cansel_order() {
  window.localStorage.clear();
  update_orders_input();
  update_orders_button();

  $('#cart').text('Your cart is now empty');
} // заменяем элемент id="cart" на текст при потощи метода text











//
