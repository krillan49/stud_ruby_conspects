class UserBulkExportService < ApplicationService
  def call
    compressed_filestream = output_stream() # для рефакторинга создадим подметод(ниже)
    compressed_filestream.rewind # перематываем


    # send_data compressed_filestream.read, filename: 'users.zip' - раньше в контроллере в методе respond_with_zipped_users делали так чтобы отправить фаил для загрузки пользователем сразу через браузер

    # Вариант 1 - с сохранением архива в ActiveStorage после отправки письма, на случай если мы еще раз захотим использовать этот фаил
    ActiveStorage::Blob.create_and_upload! io: compressed_filestream, filename: 'users.zip'

    # Вариант 2 - без сохранения в ActiveStorage
    compressed_filestream # тут просто возвращаем
  end

  private

  def output_stream
    renderer = ActionController::Base.new # тк метод render_to_string, применяющийся ниже, не доступен в сервисном объекте, а доступен только в контроллере, а при помощи вызова от этого объекта мы сможем применить этот метод

    Zip::OutputStream.write_buffer do |zos|
      User.order(created_at: :desc).each do |user|
        zos.put_next_entry "user_#{user.id}.xlsx"
        zos.print renderer.render_to_string(
          layout: false, handlers: [:axlsx], formats: [:xlsx], template: 'admin/users/user', locals: { user: user }
        )
      end
    end
  end

end















#
