class UserBulkExportJob < ApplicationJob
  queue_as :default

  def perform(initiator) # принимаем юзера который инициировал задачу экспорта
    stream = UserBulkExportService.call # вызываем наш сервис user_bulk_export_service.rb и передаем в переменную(для варианта 1 можно назвать например zipped_blob) либо загруженный архив в виде объекта ActiveStorage(Вариант 1), либо сжатый фаилстрим(Вариант 2)

    # Отправляем через мэйлер ссылку на скачивание архива на почту пользователя(админа)
    Admin::UserMailer.with(user: initiator, stream: stream).bulk_export_done.deliver_now
    # bulk_export_done - этот метод создадим в мэйлере admin/user_mailer.rb
    # так же создадим представления для писем для этой задачи с тем же именем bulk_export_done в views/admin/users_mailer/

  ensure # это нужно только если сохраняли в ActiveStorage
    stream.purge # удаляем архив
    # Хотя можно и не удалять и даже отдельный контроллер сделать, где можно будет например смотреть список всех выполненных задач, чтоб можно было нажать на ссылку и скачать этот архив
  end
end
