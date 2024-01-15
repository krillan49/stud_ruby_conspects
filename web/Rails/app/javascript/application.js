// Entry point for the build script in your package.json
import * as bootstrap from "bootstrap"



// Добавили все что идет далее:

// Добавляем скрипты
import Rails from "@rails/ujs"   // Подключаем потому что по умолчанию UJS отключен в Рэилс 7  ??
import Turbolinks from "turbolinks"

// для дропдаунов
import '@popperjs/core'
import 'bootstrap/js/dist/dropdown' // собственно компонент бутстрапа отвечающий за дропдауны
import 'bootstrap/js/dist/collapse' // для выпадающих форм для commentable

// подключаем скрипт с кодом для TomSelect (ManyToMany)
import './scripts/select'

// Запускаем скрипты
Rails.start()
Turbolinks.start()

















//
