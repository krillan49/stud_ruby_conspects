//                                        Версия 1

// Entry point for the build script in your package.json
// import * as bootstrap from "bootstrap" // этого начиная с какогото урока нет (мб и совсем не нужно ??)


// Добавили все что идет далее:

// Добавляем скрипты
import Rails from "@rails/ujs"   // Подключаем потому что по умолчанию UJS отключен в Рэилс 7  ??
import Turbolinks from "turbolinks"

import * as ActiveStorage from "@rails/activestorage" // у круковского есть(я не делал) связано с такими же package.json ??

// для дропдаунов
import '@popperjs/core'      // с ESBuild не нужно, можно удалить, тк дропдаун его загружает автоматически
import 'bootstrap/js/dist/dropdown' // собственно компонент бутстрапа отвечающий за дропдауны
import 'bootstrap/js/dist/collapse' // для выпадающих форм для commentable

// подключаем скрипт с кодом для TomSelect (ManyToMany)
import './scripts/select'

// Запускаем скрипты
Rails.start()
Turbolinks.start()
ActiveStorage.start() // у круковского есть(я не делал) связано с такими же package.json ??




//                                        Версия 2 с Turbo (и ESBuild)

// Entry point for the build script in your package.json
// import * as bootstrap from "bootstrap"

import "@hotwired/turbo-rails"
// import Rails from "@rails/ujs"            // ujs нам больше не нужен, ссылки использующие его далее мигрируем в turbo-синтаксис
// import Turbolinks from "turbolinks"       // убираем турболинкс
import * as ActiveStorage from "@rails/activestorage"  // у Круковского есть(я не делал) связано с такими же package.json ??

// import '@popperjs/core'                  // с ESBuild не нужно, можно удалить, тк дропдаун его загружает автоматически
import 'bootstrap/js/dist/dropdown'
import 'bootstrap/js/dist/collapse'
import './scripts/select'

// Rails.start()                             // тоже больше не нужно (хз почему)
// Turbolinks.start()                        // убираем турболинкс
ActiveStorage.start() // у Круковского есть(я не делал) связано с такими же package.json ??















//
