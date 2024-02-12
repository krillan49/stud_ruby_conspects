import TomSelect from 'tom-select/dist/js/tom-select.popular' // подключаем tom-select, заодно добавим самые популярные плагины для него (.popular)
import Translations from './i18n/select.json'  // подключаем переводы из подпапки


// Урок 21 - добавлена "выгрузка" ??
let selects = []
document.addEventListener("turbolinks:before-cache", function() {
  selects.forEach((select) => {
    select.destroy()
  })
})


document.addEventListener("turbolinks:load", function() {
  const i18n = Translations[document.querySelector('body').dataset.lang] // для того чтобы определить для какого языка использовать перевод, инфу берем из аттрибута тега body из лэйаут (<body data-lang="<%= I18n.locale %>"> )

  document.querySelectorAll('.js-multiple-select').forEach((element) => { // те для каждого элемента селектора с классом .js-multiple-select
    // Создаем опции:
    let opts = {
      plugins: { // Подключаем в опциях плагины
        'remove_button': {
          title: i18n['remove_button'] // переод для плагина
        }, // 'remove_button' - плагин позволяет удалять элементы(у нас теги при нажатии на крестик ??)
        'no_backspace_delete': {}, // для удобства работы с backspace
        'restore_on_backspace': {} // для удобства работы с backspace
      },
      valueField: 'id', // опция говорит что значениями будут айдишники (тут наших тегов)
      labelField: 'title', // а для отображения будет title
      searchField: 'title', // и для поиска тоже title
      create: false, // если (тут тега) нет, то создать нельзя
      // Функция, которя принимает запрос и колбэк, которая и будет подгружать наши теги
      load: function(query, callback) {
        // содадим URL: часть из атрибута data
        const url = element.dataset.ajaxUrl + '.json?term=' + encodeURIComponent(query)
        // element.dataset.ajaxUrl - часть URL берем из атрибута data в форме (data: {'ajax-url': '/api/tags'})
        // encodeURIComponent(query) - то что ввел пользователь (добавим к 'term=')

        fetch(url)
          .then(response => response.json()) // получаем ответ от сервера
          .then (json => { callback(json) })
          .catch(() => { callback() })
      },
      // Переопределяем атрибут TomSelect-а render, чтобы добавить переводы в случае отсутсвия резов выбора ??
      render: {
        no_results: function(_data, _escape){
          return '<div class="no-results">' + i18n['no_results'] + '</div>';
        }
      }
    }

    new TomSelect(element, opts) // создаем новый элемент TomSelect с тегом(element) и созданными опциями

    // Вместо строки выше. Урок 21 - добавлена "выгрузка" ??
    const el = new TomSelect(element, opts)
    selects.push(el)
  })
})

















//
