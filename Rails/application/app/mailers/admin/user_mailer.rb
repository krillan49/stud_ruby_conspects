module Admin
  class UserMailer < ApplicationMailer
    def bulk_import_done # для письма успешного импорта
      @user = params[:user]
      mail to: @user.email, subject: I18n.t('admin.user_mailer.bulk_import_done.subject')
    end

    def bulk_import_fail # для письма об ошибке импорта
      @error = params[:error]
      @user = params[:user]
      mail to: @user.email, subject: I18n.t('admin.user_mailer.bulk_import_fail.subject')
    end

    def bulk_export_done # для письма об экспорте
      @user = params[:user]
      stream = params[:stream]

      # Вариант 1 для для передачи архива с ActiveStorage
      attachments[stream.attachable_filename] = stream.download
      # attachments         - пристыковывает к письму (?? фаил архива ??)
      # attachable_filename - метод ActiveStorage, вернет имя фаила в удобоваримом формате
      # stream.download     - тоесть контент архива мы считаем и пристыкуем к письму

      # Вариант 2 для для передачи стрима (без архива ActiveStorage)
      attachments['result.zip'] = stream.read
      # stream.read - тут используем просто метод чтения для пристыковки к писбму

      mail to: @user.email, subject: I18n.t('admin.user_mailer.bulk_export_done.subject')
    end
  end
end
