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

  document.querySelectorAll('.js-multiple-select').forEach((element) => {
    // те для каждого элемента селектора с классом .js-multiple-select создаем опции:
    let opts = {
      plugins: { // Подключаем в опциях плагины
        'remove_button': {
          // 'remove_button' - плагин позволяет удалять элементы(у нас теги при нажатии на крестик ??)
          title: i18n['remove_button'] // перевод для плагина
        },
        'no_backspace_delete': {}, // для удобства работы с backspace
        'restore_on_backspace': {} // для удобства работы с backspace
      },
      valueField: 'id',     // опция говорит что значениями будут айдишники (тут наших тегов)
      labelField: 'title',  // а для отображения будет title
      searchField: 'title', // и для поиска тоже title
      create: false,        // если (тут тега) нет, то создать нельзя
      // Функция, которя принимает запрос и колбэк, которая и будет подгружать наши теги
      load: function(query, callback) {
        // содадим URL: часть из атрибута data
        const url = element.dataset.ajaxUrl + '.json?term=' + encodeURIComponent(query)
        // element.dataset.ajaxUrl - часть URL берем из атрибута data в форме (data: {'ajax-url': '/api/tags'})
        // encodeURIComponent(query) - то что ввел пользователь (добавим к 'term=')

        fetch(url)
          .then(response => response.json()) // получаем ответ от сервера
          .then(json => { callback(json) })
          .catch(() => { callback() })
      },
      // Переопределяем атрибут TomSelect-а render, чтобы добавить переводы в случае отсутсвия резов выбора ??
      render: {
        no_results: function(_data, _escape){
          return '<div class="no-results">' + i18n['no_results'] + '</div>';
        }
      }
    }

    // Вариант 1: создаем новый элемент TomSelect с тегом(element) и созданными опциями
    new TomSelect(element, opts)
    // Вариант 2: Урок 21 - добавлена "выгрузка" ??
    const el = new TomSelect(element, opts)
    selects.push(el)
  })
})




//                                           Версия с использованием Turbo

import TomSelect from 'tom-select/dist/js/tom-select.popular'
import Translations from './i18n/select.json'

let selects = []

// document.addEventListener("turbolinks:before-cache", function() {
document.addEventListener("turbo:before-cache", function() { // меняем turbolinks на turbo
  selects.forEach((select) => {
    select.destroy()
  })
})

// document.addEventListener("turbolinks:load", function() {
// document.addEventListener("turbo:load", function() {         // меняем turbolinks на turbo
const rerender = function() {                                   //  помещаем в переменную rerender(название любое), чтобы исправить ошибку при валидации
  const i18n = Translations[document.querySelector('body').dataset.lang]

  document.querySelectorAll('select.js-multiple-select').forEach((element) => {
    // select.js-multiple-select - ищем именно селекторы с таким классом тк класс отдельно дублируется и для вложенных элементов
    if(!element.classList.contains('tomselected')) { // дополнительно проверим что элемент с которым мы сейчас работаем не содержит в списке классов класс tomselected, чтобы на элемент, на который мы Томселект назначили, оно не пыталось его назначить еще раз. Тк когда рендерим турбофрэйм с Томселектом, то на странице может быть другой Томселект и он уже назначен
      let opts = {
        plugins: {
          'remove_button': {
            title: i18n['remove_button']
          },
          'no_backspace_delete': {},
          'restore_on_backspace': {}
        },
        valueField: 'id',
        labelField: 'title',
        searchField: 'title',
        create: false,
        load: function(query, callback) {
          const url = element.dataset.ajaxUrl + '.json?term=' + encodeURIComponent(query)

          fetch(url)
            .then(response => response.json())
            .then (json => {
              callback(json)
            }).catch(() => {
              callback()
            })
        },
        render: {
          no_results: function(_data, _escape){
            return '<div class="no-results">' + i18n['no_results'] + '</div>';
          }
        }
      }

      const el = new TomSelect(element, opts)
      selects.push(el)
    }
  })
// })
}
// чтобы исправить ошибку при валидации добавим лисентеры событий с нашей созданной переменной
// turbo:load и turbo:render - события, их опясания а так же других событий есть в доках
document.addEventListener("turbo:load", rerender)
document.addEventListener("turbo:frame-render", rerender) // чтобы делать перерендер при рендере фрэйма
document.addEventListener("turbo:render", rerender)

















//
