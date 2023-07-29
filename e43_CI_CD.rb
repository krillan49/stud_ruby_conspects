puts '                          Как устроен процесс разработки в компании (CI, CD)'

# CI - continuous integration - непрерывная интеграция - автотест при коммитах в общий репозиторий
# CD - continuous delivery - непрерывная доставка - автозаливка на веб-сервер

# programmer  owner
#    |   ______|
# hipchat ______ github -------
#    |__________ test server__|
#                  |
#                 www (staging) --- QA

# Integration tests - watir, selenium
# https://github.com/watir/watir
# https://github.com/SeleniumHQ/selenium

# KANBAN-доска: http://kanbanflow.com/

# http://trello.com/
