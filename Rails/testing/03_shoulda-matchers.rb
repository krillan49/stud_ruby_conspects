puts '                                       Матчеры shoulda-matchers'

# http://matchers.shoulda.io/docs/v3.1.3/
# https://github.com/thoughtbot/shoulda-matchers

# Shoulda Matchers предоставляет совместимые с RSpec и Minitest однострочные тесты для тестирования функциональности Common Rails, которые, если бы они были написаны вручную, были бы намного длиннее, сложнее и подвержены ошибкам.



puts '                                        shoulda-matchers install'

# 1. Gemfile:
group :test do
  gem 'shoulda-matchers', '~> 6.0'
end
# $ bundle install

# Далее нужно настроить gem, указав ему какие сопоставления нужно использовать в тестах, что используется RSpec, чтобы он мог сделать эти сопоставления доступными в группах примеров

# 2. Конфигурация в Rails-приложении, добавим в конец spec/spec_helper.rb или spec/rails_helper.rb(я добавил в rails_helper.rb):
RSpec.configure do |config|
  # всякие конфигурации ...

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

end



puts '                                  Матчеры shoulda-matchers для моделей'

# 1. Матчеры ля тестирования валидаций:

# https://matchers.shoulda.io/docs/v5.3.0/Shoulda/Matchers/ActiveModel.html#validate_length_of-instance_method   validate_length_of

# validate_presence_of - матчер проверяющий ваидацию, которая проверяет наличие значения в поле (тут в поле email)
should validate_presence_of :email

# Разные матчеры валидации длинны значения тестового поля:
should validate_length_of(:title).is_at_most(140)                  # не больше чем 140 символов
should validate_length_of(:bio).is_at_least(15)                    # не менее чем
should validate_length_of(:favorite_superhero).is_equal_to(6)      # равен значению
should validate_length_of(:password).is_at_least(5).is_at_most(30) # одновременно меньше и больше чем


# 2. Матчеры для тестирования ассциаций:

# http://matchers.shoulda.io/docs/v3.1.3/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method

# have_many - матчер проверяет наличие ассоциации have_many для тестируемой модели.
should have_many :comments   # тоесть тоесть тестируемая модель должна иметь связь have_many :comments
# "have" а не "has" из-за правил английского тк есть "should"

# belong_to - матчер проверяет наличие ассоциации belong_to для тестируемой модели.
should belong_to :article
# в матчере "belong" хотя в модели "belongs" из-за правил английского тк есть "should"




puts '                                         Тестирование моделей'

# Матчеры shoulda-matchers для проверки моделей(работает как для rspec так и для обычных юнит тестов)

# Модель, которую будем тестировать /app/models/contact.rb:
class Contact < ApplicationRecord
  validates :email, presence: true
  validates :message, presence: true
end

# Создадим тест для модели: /spec/models/contact_spec.rb
require 'rails_helper' # подключаем фаил spec/rails_helper.rb
# Далее используем матчеры shoulda-matchers, чтобы проверить валидации на наличие значения полей
describe Contact do
  it { should validate_presence_of :email }
  it { should validate_presence_of :message }
end
# > rake spec     # запускаем rspec через rake, но можно и обычным способом (нужны миграции тестовой БД)


# модель /app/models/article.rb которую будем тестировать
class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 140 } # Добавим валидацию длинны
  validates :text, presence: true, length: { maximum: 4000 }
  has_many :comments
end

# Создадим тест /spec/models/article_spec.rb:
require 'rails_helper'
describe Article do
  # Проверим длинну
  describe "validations" do
    it { should validate_length_of(:title).is_at_most(140) } # is_at_most(140) - не больше чем 140
    it { should validate_length_of(:text).is_at_most(4000) }
  end

  # Проверим ассоциавции принадлежности при помощи матчера have_many
  describe "assotiations" do  # сущность Article должна иметь много комментов
    it { should have_many :comments } # have а не has ииза правил английского тк есть should
  end
end


# модель /app/models/comment.rb которую будем тестировать
class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 4000 } # Добавим валидацию длинны
  belongs_to :article
end

# Создадим тест /spec/models/comment_spec.rb
require 'rails_helper'
describe Comment do
  describe "validations" do
    it { should validate_length_of(:body).is_at_most(4000) }
  end

  # Проверим ассоциавции принадлежности при помощи матчера belong_to
  describe "assotiations" do  # сущность Comment должа принадлежать статье
    it { should belong_to :article } # в матчере belong хотя в модели belongs
  end
end



puts '                                 Баг тестирования belong_to к Devise модели'

# По умолчанию, если User это модель Devise, возникает ошибка при тестировании ассоциации /spec/models/comment_spec.rb
require 'rails_helper'

describe Comment do
  it { should belong_to :user }
end

# > rake spec
# => Failure/Error: it { should belong_to :user }

# Для исправления в модели нужно добавить:
class Comment < ApplicationRecord
  belongs_to :user, optional: true, required: true
  # optional: true  - если это не добавить то при использовании Rails 5.1 и выше создание нового коммента и тесты этого свойства выдадут ошибку "User must exist"
  # required: true  - если не добавить возникнут ошибки с rspec тестирыванием этой ассоциации

  # !!! Но вообще так нельзя и стоит выбрать одно из 2х, тк получается противоречие:
  # optional: true - позволяет сохранять Post без пользователя
  # required: true - требует наличия пользователя (валидация)
end














#
