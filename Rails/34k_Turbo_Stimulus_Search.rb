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
    post :search # тоесть маршрут /movies/search(.:format) для POST запроса к экшену search. POST лучше для турбостримов, при обычном вароике можно GET
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
















#
