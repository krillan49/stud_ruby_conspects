class AnswerPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    !user.guest?
  end

  def show? # прописываем на будущее на всякий, хоть сейчас такого экшена в контроллере ответов и нет
    true
  end

  def update?
    user.admin_role? || user.moderator_role? || user.author?(record)
  end

  def destroy?
    user.admin_role? || user.author?(record)
  end
end
