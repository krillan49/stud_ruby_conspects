puts '                                       Транзакции(AR)'

# Active Record транзакции в Ruby on Rails позволяют выполнять несколько операций с базой данных как единое целое. Это означает, что если одна из операций не удалась, вы можете откатить все изменения, сделанные в рамках этой транзакции. Это помогает поддерживать целостность данных и предотвращает частичное выполнение операций

# Транзакция начинается с вызова метода ActiveRecord::Base.transaction

# Коммит: Если все операции внутри блока выполняются успешно, транзакция автоматически коммитится, и изменения сохраняются в БД

# Откат: Если возникает ошибка или исключение, все изменения откатываются.



puts '                               Транзакция с использованием create!'

# Рассмотрим пример, где мы хотим создать пользователя и связанный с ним профиль. Если создание профиля не удастся, мы не хотим сохранять и пользователя

# метод create! выбрасывает исключение, если запись не может быть создана. Это гарантирует, что если создание профиля не удастся, транзакция будет откатана.

class User < ApplicationRecord
  has_one :profile
end

class Profile < ApplicationRecord
  belongs_to :user
end

# Использование транзакции
begin
  ActiveRecord::Base.transaction do
    user = User.create!(name: "John Doe")
    profile = Profile.create!(user: user, bio: "Hello, I'm John!")
    # Если что-то пойдет не так, например, профиль не удастся создать, выбросит исключение и все изменения будут откатаны
  end
rescue ActiveRecord::RecordInvalid => e
  puts "Ошибка: #{e.message}"
end



puts '                       Транзакция с использованием save и проверкой ошибок'

# Можно использовать save и проверять ошибки вручную

ActiveRecord::Base.transaction do
  user = User.new(name: "John Doe")
  raise ActiveRecord::Rollback unless user.save    # Откат транзакции если юзер не сохранен

  profile = Profile.new(user: user, bio: "Hello, I'm John!")
  raise ActiveRecord::Rollback unless profile.save # Откат транзакции если профиль не сохранен
end



puts '                                      Вложенные транзакции'

# Rails поддерживает вложенные транзакции с помощью savepoints. Если внутренняя транзакция вызывает ROLLBACK, это не повлияет на внешнюю транзакцию

ActiveRecord::Base.transaction do
  user = User.create!(name: "John Doe")

  ActiveRecord::Base.transaction do
    profile = Profile.create!(user: user, bio: "Hello, I'm John!")
    raise ActiveRecord::Rollback unless profile.valid?
  end
  # Если создание профиля не удалось, пользователь все равно будет создан, а профиль не будет.
end













#
