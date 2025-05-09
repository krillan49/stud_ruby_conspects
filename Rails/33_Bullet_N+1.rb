puts '                               Оптимизация запросов к БД. Bullet. N+1'

# https://github.com/flyerhzm/bullet

# Bullet - библиотека для оптимизации запросов к БД, находящая неоптимальные запросы и делающая подсказки при просмотре страниц приложения в браузере


# Gemfile
group :development do
  gem 'bullet'
end
# > bundle i


# Устанавливаем Bullet в приложение (устанавливаем конфиг для него)
# > bundle exec rails g bullet:install
# =>
# Enabled bullet in config/environments/development.rb           # Добавляет конфигурацию булет в фаил конфигурации
# Would you like to enable bullet in test environment? (y/n) n   # Тут выбираем подключать ли в тестовой среде тоже


# Отключить Bullet если больше не нужны его подсказки:
# config/environments/development.rb находим блок:
config.after_initialize do
  Bullet.enable        = false  # и устанавливаем тут значение false
  Bullet.alert         = true
  Bullet.bullet_logger = true
  Bullet.console       = true
  Bullet.rails_logger  = true
  Bullet.add_footer    = true
end



puts '                                Bullet использование и решение проблемы N+1'

# Далее запускаем сервер, переходим по страницам и там где запросы не оптимальны Bullet выдаст подсказки во всплывающем окне, а так же в консоли приложения: в каких контроллерах, представлениях, на каких строках ошибки, к каким моделям относятся и способы их исправления, например:

# user: User
# GET /en/questions
# USE eager loading detected
#   Question => [:user]
#   Add to your query: .includes([:user])
# Call stack
#   E:/doc/Projects/stud_other/AskIt/app/views/questions/_question.html.erb:3:in `_app_views_questions__question_html_erb___1011012738_28240'
#   E:/doc/Projects/stud_other/AskIt/app/views/questions/index.html.erb:10:in `_app_views_questions_index_html_erb__205808045_28180'
#   E:/doc/Projects/stud_other/AskIt/app/controllers/concerns/internationalization.rb:15:in `switch_locale'

# Тоесть тут он предлагает добавить в запрос коллекции вопросов .includes([:user]), соотв откроем нужный questions_controller.rb и добавим в запрос, в экшене указанном выше (GET /en/questions)
def index
  @pagy, @questions = pagy Question.includes(:user).order(created_at: :desc) # добавили includes(:user) - это нужно чтобы не просто загрузить все вопросы, но и для каждого вопроса сразу подгрузить юзеров, которым они принадлежат(тк юзеры используются в представлении), тк иначе потом получится, что придеся делать для каждого вопроса отдельный запрос, который вытаскивает для него юзера, чтобы вывести его имя и аватар. Это и есть проблема N+1 и мы ее так решили
  @questions = @questions.decorate
end
# Заодно оптимизируем в консерне questions_answers для страницы questions/show.html.erb

# С includes(:user) в представлении все равно вызываем свойства из user от ассоциации user как и обычно, например:
question.user.email


# (??? если вызываем вопрос от ассоциации, например от текущего пользователя, то данные пользователя автоматом стыкуюися к подкастам и includes(:user) уже не нужно ??)













#
