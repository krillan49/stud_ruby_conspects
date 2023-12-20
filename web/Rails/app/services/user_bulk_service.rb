class UserBulkService < ApplicationService
  attr_reader :archive # геттер для архива

  def initialize(archive_param) # принимает params[:archive], те zip архив загруженный в форму
    @archive = archive_param.tempfile
    # tempfile - метод позволяющий получить ссылку на загруженный временный фаил
  end

  def call # основной метод для обработки архива (вызывается в application_service.rb)
    Zip::File.open(@archive) do |zip_file| # Открываем zip архив и передаем открытый фаил в zip_file
      zip_file.glob('*.xlsx').each do |entry| # Перебираем каждый фаил xlsx, который есть в архиве (на случай если их много)
        # Вариант 1: при потощи итератора и записи в БД кажого пользователя отдельно (если много зпписей то будет оч медленно)
        u = users_from(entry)
        u.each do |user|
          # ...
        end

        # Вариант 2: оптимизировать при помощи гема activerecord-import, и вополнять все записи одним запростом
        User.import users_from(entry), ignore: true
        # users_from(entry) - наш кастомный подметод(ниже) создает(распарсит по ячейкам) массив пользователей на основе xlsx фаила из entry
        # import - метод activerecord-import, принимает тут массив из пользователей и записывает их в БД одним запросом
        # ignore: true - дополнительный параметр не пускающий дублирующие записи в БД
        # валидации будут сделаны
        # у гема activerecord-import есть еще раздые доп опции, которые можно посмотреть в доках
      end
    end
  end

  private

  def users_from(entry)
    sheet = RubyXL::Parser.parse_buffer(entry.get_input_stream.read)[0]
    # get_input_stream - метод гема rubyzip возвращает последовательность бит.
    # RubyXL::Parser.parse_buffer - метод гема rubyXL, делает парсинг полученных данных. Есть еще метод parse он парсит фаилы
    # [0] - чтобы взять 1й лист из докумкнта Excel
    sheet.map do |row| # на основе распарсенных данных сделаем массив
      cells = row.cells[0..2].map { |c| c&.value.to_s } # из каждого ряда таблицы Excel, вытаскиваем ячейки (тут 3 первые по индексам от 0 слева направо)
      # value - берет содержимое ячейки
      # Далее на основе ячеек создадим объекты новых юзеров, но только в памяти не сохраняя в БД (для оптимизации)
      User.new name: cells[0], # тк в нашем примере в 1й ячейке таблицы Excel содержится имя
               email: cells[1], # тк в нашем примере в 2й ячейке таблицы Excel содержится почта
               password: cells[2], # тк в нашем примере в 3й ячейке таблицы Excel содержится пароль
               password_confirmation: cells[2] # берем туже ячейку из таблицы Excel, что содержит пароль
    end
  end
end













#
