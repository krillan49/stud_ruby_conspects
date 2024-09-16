puts '                                          Универсальные'

# tab+shift            - отступ влево(удаление отступа)
# shift+стрелка       - выделить текст
# Ctrl+/Ctrl-         - Увеличить/уменьшить размер шрифта на экране
# ctrl+колесико       - Увеличить/уменьшить размер шрифта на экране
# ctrl+c              - копировать
# ctrl+v              - вставить
# Ctrl+s              - сохранение фаила
# Ctrl+A              - выделить все
# Ctrl+z              - отмена предыдущего действия.
# Ctrl+y              - вернуть вперед(обратное Ctrl+z)



puts '                                            Браузеры'

# Ctrl + Плюс           — увеличить масштаб
# Ctrl + Минус          — уменьшить масштаб
# Ctrl + 0              — установить исходный масштаб (сбросить настройки)



puts '                                              Far'

# https://github.com/elfmz/far2l  - установка фар на линукс
# Для Linux семейства Ubuntu установка обычно сводится к двум командам в терминале:
# $ sudo apt-get update
# $ sudo apt-get install mc
# (после этого можно вводить “mc”, чтобы запустился Midnight Commander)


# меню - нажать на иконку Фар командера на окне.

# перемещение курсора кнопками "вверх" и "вниз", либо мышью

# кнопки внизу панели фаилов означают F1 F2 F3 ... F12

# shift+F4  - создать фаил. Появится Editor(редактор). После нажатия enter созданный фаил откроется, а чтобы сохранить его нужно нажать F2
# F3                                                                   - смотреть фаилы без редактирования
# F4                                                                   - вход для редактирования(при наведении на фаил)
# F7 -> foldername0/foldername1 -> Enter                               - Создание папки и подпапки одновременно
# F6 -> указание места куда перенести(папка/подпапка/итд) -> Enter     - Перенос папки в другое место
# F5 -> вводим новое имя фаила -> Enter                                - Скопировать фаил под новым именем

# Alt+F1                   - переход с диска Д на диск С и наоборот в левом окне
# Alt+F2                   - переход с диска Д на диск С и наоборот в правом.
# tab                      - переход на соседнюю панель
# insert(shift+стрелка)    - выделить фаилы/снять выделение
# ctrl+o                   - переключение с панели фаилов на консоль(аналог обычной консоли cmd) и обратно

# Вставить в консоли фара: меню -> именить -> втавить


# Если зайти в фаил через F3 и находясь в нем нажать F4 то выдаст 16ричный код фаила и доп инфу

# Enter  - чтоб открыть этот фаил не в фаре(html  в браузере откроется)
# выходить из фаила можно и esc

# В фар командере некоторые слова зарезервированы за операторами функций(ключевые слова), соотв мы не можем делать переменные с таким именем



puts '                                               VSCode'

# https://code.visualstudio.com/                                       оф сайт
# https://code.visualstudio.com/docs/?dv=win64user                     документация
# https://www.youtube.com/watch?v=nxCLXMBl4e4                          гайд
# https://habr.com/ru/post/650561/                                     убираем визуальный шум
# https://itchef.ru/articles/200288/                                   расширения
# https://vscodethemes.com/, https://marketplace.visualstudio.com/     Цветовые темы

# https://docs.emmet.io/             -  документация дополнения быстрого набора для расширения Emmet

# ul>li*10                - создание списка ul с 10ю элементами li
# lorem50                 - 50 слов заглушки

# Параметры>hints подсказки

# "Code runner extension"(аналог Атомранор в ВСкод)

# Shift+Ctrl+P                                                   - Палитра команд
# settings(в строке поиска) - open settings (user) json          - фаил всех наших настроек

# Ctrl+Shift+M                                                   - Открыть нижнюю панель(терминал итд)
# Alt+Z                                                          - Перенос теста
# Ctrl+колесико (включается в Editor: Mouse Wheel Zoom)          - Изменение размера шрифта без настроек
# Shift+Alt+F                                                    - автоформатирование(табуляция отступы)(для Руби нужно отдельное дополнение)
# Ctrl+Alt+N                                                     - ранер


# Настройка отступов(тут для Руби меняем таб на 2 прбела):
# ctrl+shift+p и напишите «настройки». Нажмите «Открыть настройки пользователя (JSON)».
# Добавьте в ваш json-скрипт (помните, что поля должны заканчиваться запятой, если за ними следует другое поле)
# "[ruby]": {
#   "editor.detectIndentation" : false,
#   "editor.insertSpaces": true,
#   "editor.tabSize": 2
# }



puts '                                           Sublime'

# https://vimeo.com/99694298   15m
# Установка sublime, установка пути(добавление в переменную path) для связи far и sublime.
# копировали экзешник саблайма в s.exe  для использования в консоли
# Открытие фаила в sublime через консоль far. Заходим в far в нужную папку с фаилами и потом в консоли  набираем   s имяфаила.rb  (сбрасывается при обновлении)


# Настройка отступов(тут делаем руби-отступы по 2 пробела на таб):
# Открываем пустой фаил .rb(или другой который хотм настроить) В меню Preferences -> Settings - Syntax Specific
# {
# 	"tab_size": 2,
# 	"translate_tabs_to_spaces": true,
# 	"detect_indentation": false
# }


# Плагины от Fedor Koshel
# это команда Package Control, точно не помню, как ее вызвать
# Ctrl+alt+P для списка команд (у меня так настроено), там можно ввести Package control и в списке найти что-то вроде Installed packages list
# И в настройках плагина Package Control этот список, помоему просто текстом лежит
# "installed_packages":
#   [
#     "AdvancedNewFile",
#     "Alignment",
#     "All Autocomplete",
#     "BracketHighlighter",
#     "Colorsublime",
#     "FileDiffs",
#     "Gist",
#     "GitSavvy",
#     "Gofmt",
#     "GoImports",
#     "GoOracle",
#     "HTML5",
#     "Local History",
#     "Markdown HTML Preview",
#     "MarkdownPreview",
#     "Package Control",
#     "PostgreSQL Syntax Highlighting",
#     "Rails Migrations List",
#     "Ruby Block Converter",
#     "Ruby Completions",
#     "Ruby on Rails snippets",
#     "Ruby Slim",
#     "SCSS",
#     "SideBarEnhancements",
#     "SublimeLinter",
#     "SublimeLinter-contrib-ruby-lint",
#     "SublimeLinter-contrib-scss-lint",
#     "SublimeLinter-contrib-slim-lint",
#     "SublimeLinter-eslint",
#     "SublimeLinter-golint",
#     "SublimeLinter-rubocop",
#     "SyncedSideBar",
#     "Theme - SoDaReloaded"
#   ]
# У меня вот такой список, на мой взгляд удобнее и эффективнее чем VScode c плагинами для Ruby. По крайней мере go to definition, поиск и автокомплит гораздо лучше работают



puts '                                               Atom'

# Atom – это open source редактор, его производителем является компания GitHub.

# https://pulsar-edit.dev/                       - IDE похожий на атом

# https://timeweb.com/ru/community/articles/kak-polzovatsya-redaktorom-atom    - инструкция к Атом


# file -> settings -> editor -> Sort Wrap      -  Настойки переноса строк в Атом

# ctrl+стрелка              - поменять строки местами

# альт+r         - Проверить в атомранере

# Открыть/скрыть скрытые/игнорируемые фаилы и папки Settings → Packeges, в поиске Tree View -> ставим или снимаем галочки необходимые















#
