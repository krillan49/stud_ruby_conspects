puts '                            expect().to receive и allow().to receive'

# 1. expect(...).to receive(...) - матчер используется для проверки того, что метод был вызван на объекте. Если метод не был вызван, тест завершится с ошибкой. Используется, когда нужно проверить, что метод был действительно вызван.

# 2. allow(...).to receive(...) - матчер используется для разрешения вызова метода на объекте, но не проверяет, был ли он вызван. Тест пройдет независимо от того, был ли метод вызван. Это полезно, когда нужно избежать реального выполнения метода или когда не хотите проверять его вызов.

# 3. Иногда бывает полезно использовать оба матчера в одном тесте, например, когда нужно разрешить один метод и проверить другой.

class User
  def notify; end

  def log_activity; end

  def perform_action
    notify
  end

  def perform_action_2
    notify
    log_activity
  end
end

RSpec.describe User do
  let(:user) { User.new }

  # 1. Тест будет успешным только в том случае, если метод notify был вызван в процессе выполнения метода perform_action
  it 'calls the notify method' do
    expect(user).to receive(:notify) # Ожидаем, что метод notify будет вызван
    user.perform_action              # Вызов метода, который должен вызвать notify
  end

  # 2. Тест пройдет успешно независимо от того, был ли вызван notify в процессе выполнения метода perform_action или нет.
  it 'allows the notify method to be called' do
    allow(user).to receive(:notify) # Разрешаем вызов метода notify, но не проверяем его вызов
    user.perform_action             # Вызов метода, который вызывает notify
  end

  # 3. Проверяем, что метод notify был вызван, и разрешаем метод log_activity, но не проверяем его вызов.
  it 'calls notify and allows log_activity' do
    expect(user).to receive(:notify)      # Ожидаем, что метод notify будет вызван
    allow(user).to receive(:log_activity) # Разрешаем вызов метода log_activity, но не проверяем его вызов
    user.perform_action_2                 # Вызов метода, который вызывает notify и log_activity
  end
end












#
