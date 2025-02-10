puts "                                        Turbo Stimulus Search"

# Поиск похожий на томселект, только при пмощи Turbo и Stimulus вместо ЖС скрипта, который дополнительно будет выдавать временный список всех найденных (тут фильмов) объектов в виде ссылок,  кторых можно будет перейти на страницу объекта.



puts "                                          Подготовка проекта"

# Создадим все необходимое:
# $ rails g scaffold Movie title:string

# routes.rb:
resources :movies
root "movies#index"

# Добавим simplecss-стили через cdn в Лэйаут

# Добавим фильмы при помощи Faker в seeds.rb

# Добавим валидацию в модель
class Movie < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end

# $ rails db:seed



puts "                                            Создание поиска"

# 1. Создадим ЮРЛ для экшена search контроллера movies
resources :movies do
  collection do
    # collection - ??? нужно чтобы добавить маршрут к стандартным resources маршрутам к новому нестандартному экшену контроллера movies ???
    post :search # тоесть маршрут /movies/search(.:format) для POST запроса к экшену search.
    # POST лучше для турбостримов(тк с гет какието проблемы могут быть), при обычном вароике можно GET
  end
end
# Так же закрепился хэлпер search_movies_path для /movies/search ЮРЛ экшена search контроллера movies


# 2. Добавим виды
# _search_form.html.erb - форму поиска и отрендерим ее в index.html.erb
# _search_results.html.erb - паршал с результатами поиска (колличество и временный вывод ссылок на все фильмы с подходящим названием) будет рендериться через контроллере в паршал формы _search_form.html.erb в блок с нужным id


# 3. Добавим экшен search в контроллер movies_controller.rb
def search
  if params[:title_search].present? # чтобы не выдавало список вообще всех фильмов, когда не введены(удалены) символы
    @movies = Movie.where('title ILIKE ?', "%#{params[:title_search]}%") # тоесть ищем все записи, в которых поле title содержит переданные из формы символы
  else
    @movies = []
  end
  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.update("search_results", partial: "movies/search_results", locals: { movies: @movies })
      # update         - метод который обновит какой-то HTML-элемент (тут после ввода символо в форме)
      # search_results - id HTML-элемента в который после введения символов добавится седующий параметр(ы) метода update
      # partial: "movies/search_results", locals: { movies: @movies } - тоесть в HTML-элемент заданный выше будет добавлен данный паршал с локальной переменной содержащей коллекцию выбранных фильмов

      # Так же как вариант можем выводить там просто данные, например текущее время, колличество фильмов или сами выбранные символы из параметров, вместо рендера паршала
      render turbo_stream: turbo_stream.update("search_results", Time.zone.now)
      render turbo_stream: turbo_stream.update("search_results", @movies.count)
      render turbo_stream: turbo_stream.update("search_results", params[:title_search])
    end
  end
end


# 4. Добавим в модель метод, чтобы не прописывать некрасивый SQL в контроллере
class Movie < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  # Добавим метод:
  scope :filter_by_title, -> (title) { where('title ILIKE ?', "%#{title}%") }
end
# Теперь можем в контроллере просто вызывать данный метод
@movies = Movie.filter_by_title(params[:title_search])



puts "                                           Добавление Stimulus"

# Сейчас запрос отправляется при срабптывании oninput, тоесть при вводе каждого символа происходит новый запрос, но при помощи Stimulus можно сделать так чтобы запрос оправлялся с задержкой в пол секунды, если за это время не было введено новых букв


# 1. app/javascript/controllers/debounce_controller.js - создадим новый фронтенд Stimulus-контроллер, который будет обрабатывать запросы из формы на стороне браузера и передавать их на бэкэнд контроллер только при условии, что символы не вводились кеакое-то время (код и описание там)


# 2. _search_form.html.erb - изменим форму поиска, чтобы она передавала запросы в javascript/controllers/debounce_controller.js а не на бэкенд



puts '                      Вариант того же но отдельным контроллером и вьюхами для поиска'

# Назвать контроллер можно `SearchesController`, во множественном числе если тк может быть несколько методов для поиска.
class SearchesController < ApplicationController
  def index
    # для отображения формы поиска и вывода результатов (тут не нужен тк Турбо)
  end

  # для обработки поисковых запросов. Это может быть методом, который будет принимать параметры для различных сущностей
  def search
    @query = params[:query]
    # Логика поиска по Podcast, Movie, Song и т.д.
    @podcasts = Podcast.where('title LIKE ?', "%#{@query}%")
    @movies = Movie.where('title LIKE ?', "%#{@query}%")
    @songs = Song.where('title LIKE ?', "%#{@query}%")
  end
end


# Маршруты вариант 1: для одной сущности
Rails.application.routes.draw do
  get 'search', to: 'search#index', as: 'search' # `GET /search` - для отображения формы поиска (тут не нужен тк Турбо)
  post 'searches/results', to: 'searches#search', as: 'search_results' #`POST /search/results` - для обработки запроса и вывода результатов.
end

# Маршруты вариант 2: для многих сущностей. Если делать более RESTful подход к поиску, можено использовать пути с параметрами
Rails.application.routes.draw do
  get 'searches/:query', to: 'searches#search', as: 'search_entities' # только post для Турбо
end
# В этом случае, URL может выглядеть так: `/search/podcast`, `/search/movie`, `/search/song`, и в контроллере можно обрабатывать различные типы сущностей основываясь на переданном параметре.



puts '                                         Особенности тестирования'

# 1. Убедиться, что Capybara и RSpec правильно настроены для работы с JavaScript, особенно в контексте использования Turbo:

# В Gemfile должны быть следующие гемы:
group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver' # Для работы с JavaScript
  gem 'webdrivers'         # Для автоматического управления драйверами браузеров (Не использовал)
end

# (Не добавлял) spec/rails_helper.rb добавьте следующие настройки для Capybara:
require 'capybara/rspec'
Capybara.configure do |config|
  config.default_driver = :selenium_chrome    # или :selenium_chrome_headless для безголового режима
  config.javascript_driver = :selenium_chrome # Убедитесь, что JavaScript работает
  config.app_host = 'http://localhost:3000'   # Укажите базовый URL вашего приложения
end


# 2. Создание теста с поддержкой JavaScript. Чтобы тесты нормально работали с JavaScript, нужно использовать "js: true" для сценариев, которые требуют выполнения JavaScript. Например:
RSpec.feature "Movie search", type: :feature, js: true do # js: true - добавляем эту опцию
  scenario "User searches for movies" do
    Movie.create!(title: "Inception")
    Movie.create!(title: "Interstellar")
    Movie.create!(title: "The Dark Knight")

    visit root_path

    fill_in 'title_search', with: 'Inception'
    click_button 'Search' # Если есть кнопка для отправки формы (В нашем примере нет, тк отправляет само скриптом)

    expect(page).to have_selector('#search_results', wait: 0.6)
    # wait: 0.6 - подождать (в секундах) перед выполнением этого матчера, если в скрипте есть таймаут, достаточно подожать в 1м матчере
    expect(page).to have_content('Inception')
    expect(page).not_to have_content('Interstellar')
    expect(page).not_to have_content('The Dark Knight')
  end
end













#
