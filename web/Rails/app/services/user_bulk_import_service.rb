class UserBulkImportService < ApplicationService
  attr_reader :archive_key, :service # геттеры для ключа архива и ссылки на сервис

  def initialize(archive_key) # принимает ключ архива (раньше принимал сам временный архив)
    @archive_key = archive_key
    @service = ActiveStorage::Blob.service # сохраняем ссылку на сервис ActiveStorage (для обращения к БД ??)
  end

  def call # этот метод меняем тк со старым, при считывании фаилов из архива, они криво закрываются и потом нельзя удалить архив
    read_zip_entries do |entry| # read_zip_entries - наш новй метод(код ниже), entry - каждый фаил из архива
      entry.get_input_stream do |f| # get_input_stream - читает содержание фаила, метод гема rubyzip возвращает последовательность бит.
        User.import users_from(f.read), ignore: true # собственно создаем оптимизированный запрос для добавления всех пользователей сразу при помощи гема activerecord-import (Admin_Exel_Zip)
        # f.read - добавляем фаил(или строку??) в режиме чтения
        f.close
      end
    end
  ensure
    service.delete archive_key # удаляем по ключу из БД архив с которым мы работали, после того как мы завершили работу, чтобы не хранился больше у нас на жиске
    # service - геттер обращается к таблицам ActiveStorage ??
  end

  private

  def read_zip_entries # метод использующийся в методе call
    return unless block_given? # выходим если блок не передан
    stream = zip_stream # zip_stream - метод (код ниже), который выполняет стриминг загруженного зип-фаила
    loop do # цикл который будет брать каждый следующий фаил из зип-архива, тк мы делаем стриминг и сразу не знаем сколько там фаилов. Можно делать цикл не бесконечным а ограничить например 50ю итерациями, чтобы нас не дудосили
      entry = stream.get_next_entry # берем следующую запись из архива (?? стрима)
      break unless entry # завершаем цикл если записей больше нет
      next unless entry.name.end_with? '.xlsx' # пропускаем(переходим к след итерации) если формат записи не xlsx
      yield entry # передаем запись в блок в |entry|
    end
  ensure
    stream.close # закрываем стрим/поток
  end

  def zip_stream
    f = File.open service.path_for(archive_key) # открываем фаил по его адресу в нашем приложении (?? директория storage)
    # service.path_for(archive_key) - получаем путь к загруженному архиву из БД ActiveStorage по его айдишнику
    stream = Zip::InputStream.new(f) # Zip::InputStream работает быстрее чем Zip::File
    f.close # обязательно закрываем иначе потом не получится удалить фаил
    stream
  end

  def users_from(data) # тут принимаем уже конкретные данные, тк стримминг (entry.get_input_stream) уже сделали в call
    sheet = RubyXL::Parser.parse_buffer(data)[0] # соотв парсим тоже данные
    sheet.map do |row|
      cells = row.cells[0..2].map { |c| c&.value.to_s }
      User.new name: cells[0],
               email: cells[1],
               password: cells[2],
               password_confirmation: cells[2]
    end
  end
end











#
