puts '                                        Тестирование моделей'

# /spec/models - cоздадим для тестирования моделей этот каталог. В нем будем создавать фаилы для тестирования моделей



puts '                                      Тестирование объектов AR'

# Проверить существование объекта AR
expect(Foo.where(bar: 1, bax: 2)).to exist

# Если вы проверяете наличие записи в базе данных с помощью ActiveRecord:
expect(User.exists?(id: user_id)).to be_truthy



puts '                                    Проверка создания строки в БД'

# spec/models/subscription_spec.rb
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { FactoryBot.create(:subscription) }

  describe 'create subscription' do
    it 'successfully creates a record in the database' do
      expect { subscription }.to change { Subscription.count }.by(1)
    end
  end
end
















#
