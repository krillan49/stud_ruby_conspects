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

















//
