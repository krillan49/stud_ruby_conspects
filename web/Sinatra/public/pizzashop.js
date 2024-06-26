// Функция с параметром для корзины товаров(пицы) в localstorage
function addToCart(id) {
  var x = window.localStorage.getItem('product_' + id); // ключи будут 'product_1', 'product_2' итд. Нужно для того чтоб отличать объекты в хэше, тк в localstorage мы можем хранить много всего, а не только пицы
  x = x * 1 + 1; // увеличиваем на 1 тк каждое нажатие на кнопку вызывает функцию.
  window.localStorage.setItem('product_' + id, x); // устанавливаем новое значение хэша(число товаров с этим айди в корзине)

  // (см функции ниже) Обновляем значения в полях после нажатия кнопки и соотв изменения значений в локалсторедж
  updateOrdersButton(); // вызываем метод для обновления отображения счетчика всех товаров в значении кнопки
  updateOrdersInput();  // вызываем метод для обновления значения "product_1=3,product_2=5,product_3=1, ..." в скрытом поле
}


// Функция для того чтобы:
// а. вызвать cartGetNumberOfItems()
// б. обратиться к кнопке в имя которой мы хотим поместить общее число заказов чтобы информацию о заказах было видно клиенту.
function updateOrdersButton() {
  var text = 'Корзина (' + cartGetNumberOfItems() + ' шт.)'; // Используем функцию с общим числом заказов
  $('#orders_button').val(text); // Используем джэйквери - для этого в лэйоут нужно подключть его
}


// Функция для того чтобы:
// а. вызвать сartGetOrders()
// б. обратиться к полю в которое мы хотим поместить "product_1=3,product_2=5,product_3=1, ..." чтобы потом отправить этот результат на сервер.
function updateOrdersInput() {
  var orders = сartGetOrders(); //  "product_1=3,product_2=5,product_3=1, ..."
  $('#orders_input').val(orders); // обращаемся к полю формы через его айди и вставляем в его значение(value) "product_1=3,product_2=5,product_3=1, ...". val(orders) - метод установки значений
}


// Счетчик для общего количества товаров в корзине:
function cartGetNumberOfItems() {
  var cnt = 0;
  for (var i = 0; i < window.localStorage.length; i++) {
    var key = window.localStorage.key(i); // получаем ключ по идексам ключей локалсторедж
    if(key.indexOf('product_') == 0) { // проверяем начинается ли ключ с 'product_'
      var value = window.localStorage.getItem(key); // теперь по полученному выше ключу получаем значение из локалсорэдж
      cnt += value * 1; // считаем сумму значений для всех подходящих ключей
    }
  }
  return cnt;
}


// Функция для получения(и дальнейшей отправки через форму на сервер) результата о заказах из localStorage вида "product_1=3,product_2=5,product_3=1, ..."
function сartGetOrders() {
  var orders = '';
  for (var i = 0; i < window.localStorage.length; i++){
    var key = window.localStorage.key(i); // получаем ключ
    if(key.indexOf('product_') == 0) {
      var value = window.localStorage.getItem(key); // получаем значение
      orders += key + '=' + value + ','; // тут прибавляем один элемент результата например "product_1=3,"
    }
  }
  return orders; // "product_1=3,product_2=5,product_3=1, ..."
}


// Для очистки козины на странице подтверждения. И для очистки информации об отмененном заказе
function canselOrder() {
  window.localStorage.clear();
  updateOrdersInput();
  updateOrdersButton();

  $('#cart').text('Your cart is now empty');
} // заменяем элемент id="cart" на текст при потощи метода text











//
