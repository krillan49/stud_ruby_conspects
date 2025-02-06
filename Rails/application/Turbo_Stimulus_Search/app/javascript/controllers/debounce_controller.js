import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() { // метод, который выполняется если этот контроллер удачно подключен на фронтэнде
    console.log("debounce controller connected") // передаст сообщение в консоль браузера, если этот контроллер подключен успешно
  }

  static targets = ["form"] // передается из дата-атрибута тега формы

  search() { // метод принимает запросы из поля поиска формы, но отправяет на бэкенд, только если последний символ введен не ранее чем пол секунды назад
    clearTimeout(this.timeout) // очищаяем старый таймер
    this.timeout = setTimeout(() => { // создаем новый таймер на 0.5 секунды
      this.formTarget.requestSubmit() // отправит запрос на бэкенд только если прошли 0.5 секунды
    }, 500)
  }
}
