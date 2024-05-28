module Admin
  module UsersHelper
    # для наполнения селектора в admin/users/_form.html.erb ролями
    def user_roles
      User.roles.keys.map do |role|
        # User.roles - обращвемся к модели и получаем от enum хэш ролей { basic: 0, moderator: 1, admin: 2 }
        # role - соответсвенно содержит ключ :basic или :moderator или :admin
        [t(role, scope: 'global.user.roles'), role] # для каждой роли генерим массив из 2х элементов
        # t(role, scope: 'global.user.roles') - будет отображаться в селекторе для пользователя
        # role - будет значением в селекторе
      end
      # В итоге получается массив массивов который и отрендерится в селекторе
    end
  end
end
