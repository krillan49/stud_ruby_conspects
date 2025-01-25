module Authorship
  extend ActiveSupport::Concern

  included do
    def authored_by?(user)
      self.user == user # тоесть пользователь написавший данный вопрос, ответ или коммент явзяется пользователем переданным в метод
    end
  end
end
