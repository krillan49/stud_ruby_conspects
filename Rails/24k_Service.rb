puts '                                       Сервисные объекты'

# Сервисные объекты (Service Objects) - это класс, который инкапсулирует обособленные части слишком сложных и больших контроллеров и моделей или определенную бизнес-логику, не связанную напрямую с конкретной моделью, контроллером или представлениями

# Когда стоит использовать сервисные объекты?:
# 1. Когда контроллер или модель становятся слишком большими и сложными
# 2. Когда бизнес-логика не принадлежит ни одной конкретной модели
# 3. Чтобы повторно использовать логику в нескольких местах
# 4. Чтобы инкапсулировать сложный процесс, состоящий из нескольких шагов
# 5. Чтобы организовать асинхронные задачи

# Сервисные объекты помогают организовать код, делают его более читаемым, тестируемым и поддерживаемым:
# 1. Разделение ответственности (Separation of Concerns): Выносят сложную логику из моделей, контроллеров и представлений, делая их более компактными и понятными
# 2. Повторное использование: Позволяют повторно использовать логику в разных частях приложения. Если нужно выполнить один и тот же процесс в нескольких контроллерах или моделях, можно просто вызвать сервисный объект
# 3. Тестируемость: Изолируют бизнес-логику в отдельные сервис классы, которые легко тестировать независимо от моделей и контроллеров
# 4. Поддерживаемость: Упрощают поддержку и изменение кода. Когда логика сосредоточена в одном месте, легче понять, как она работает и как ее изменить.
# 5. Соблюдение принципа единственной ответственности: Каждый сервисный объект отвечает за выполнение одной конкретной задачи.



puts '                               Принцыпы создания сервисные объектов'

# app/services/  - дерикторя (по умолчанию ее нет) в которую принято помещать сервисы

# 1. Называйте сервисные объекты в соответствии с тем, что они делают. Например, `UserCreator`, `OrderCalculator`, `SmsSender`
# 2. Обычно у сервисного объекта есть один главный метод (например, `create`, `calculate`, `send`), который выполняет основную логику
# 3. Передавайте сервисному объекту все необходимые параметры для выполнения его задачи
# 4. Возвращайте результат выполнения сервисного объекта. Можно использовать простой класс `Result` или просто возвращать `true`/`false` в случае успеха/неудачи
# 5. Можно сделать материнские классы срвисов, чтобы инкапсулировать создание объекта в статический метод (пример в 25_Admin_Exel_Zip services/application_service.rb)



puts  '                           Альтернативные паттерны сервисным объектам'

# 1. Операции (Operations) - похожи на сервисные объекты, но используются для более сложных процессов, состоящих из нескольких шагов

# 2. Интеракторы (Interactors) - используют цепочку вызовов других объектов (обычно других интеракторов) для выполнения сложной задачи. Например популярная библиотека для Rails: `interactor`

# 3. Команды (Commands) - представляют собой объект, инкапсулирующий действие. Часто используются для обработки пользовательских команд



puts '                                 Пример1: Выделение сложной логики'

# Вместо того, чтобы помещать логику расчета суммы заказа в модель `Order` или контроллер `OrdersController`, создадим сервисный объект `OrderCalculator`

# app/services/order_calculator.rb
class OrderCalculator
  def initialize(order)
    @order = order
  end

  def calculate_total
    total = @order.line_items.sum { |item| item.quantity * item.price }
    total += @order.shipping_cost if @order.apply_shipping?

    # Применение скидки (пример сложной логики)
    if @order.coupon_code.present?
      coupon = Coupon.find_by(code: @order.coupon_code)
      total *= (1 - coupon.discount_percentage) if coupon&.valid?
    end

    total.round(2)
  end
end

# app/controllers/orders_controller.rb:
class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @total = OrderCalculator.new(@order).calculate_total # Создаем и использум сервисный объект
  end
end

# Логика расчета суммы заказа теперь находится в отдельном классе, что делает модель `Order` и контроллер `OrdersController` более чистыми
# Легко тестировать логику расчета суммы заказа, не завися от моделей или контроллеров.
# Можно повторно использовать `OrderCalculator` в других частях приложения, если потребуется.



puts '                                           Пример2:'

# Логика создания пользователя и отправки приветственного письма вынесена в отдельный сервисный объект.

# app/services/user_creator.rb
class UserCreator
  def initialize(user_params)
    @user_params = user_params
  end

  def create
    user = User.new(@user_params)
    if user.save
      UserMailer.welcome_email(user).deliver_later # выполняется асинхронно через ActiveJob, что улучшает производительность приложения
      Result.new(success: true, user: user)
    else
      Result.new(success: false, errors: user.errors.full_messages)
    end
  rescue => e
    Result.new(success: false, errors: [e.message])
  end
end


# app/models/result.rb (Простой класс для возврата результатов) Сервисный объект обрабатывает ошибки и возвращает результаты в виде объекта `Result`, что упрощает обработку результатов в контроллере.
class Result
  attr_reader :success, :data, :errors

  def initialize(success:, data: nil, errors: [])
    @success = success
    @data = data
    @errors = errors
  end

  def successful?
    @success
  end

  def failed?
    !@success
  end
end


# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def create
    result = UserCreator.new(user_params).create

    if result.successful?
      redirect_to root_path, notice: 'User created successfully!'
    else
      flash[:alert] = result.errors.join(', ')
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end



puts '                               Пример 3: Интеграция со сторонним API'

# Интеграция со сторонним API для отправки SMS-сообщений

# Интеграция со сторонним API инкапсулирована в отдельном сервисе
# Легко изменить или заменить сторонний API, не затрагивая остальную часть приложения
# Логика обработки ошибок и логирования вынесена в сервисный объект

# app/services/sms_sender.rb
class SmsSender
  def initialize(phone_number, message)
    @phone_number = phone_number
    @message = message
  end

  def send
    # Логика отправки SMS через сторонний API (Twilio, Nexmo, etc.)
    # Здесь будет код, который отправляет запрос к API и обрабатывает ответ.

    # Пример (псевдокод):
    begin
      response = ThirdPartyApi.send_sms(to: @phone_number, message: @message)
      if response.success?
        Rails.logger.info("SMS sent successfully to #{@phone_number}")
        true
      else
        Rails.logger.error("Failed to send SMS to #{@phone_number}: #{response.error_message}")
        false
      end
    rescue => e
      Rails.logger.error("Error sending SMS to #{@phone_number}: #{e.message}")
      false
    end
  end
end

# app/models/user.rb
class User < ApplicationRecord
  after_create :send_welcome_sms

  private

  def send_welcome_sms
    SmsSender.new(phone_number, "Welcome to our app!").send if phone_number.present?
  end
end
















#
