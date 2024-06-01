class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    !user.guest?
  end

  def show?
    true
  end

  def update?
    user.admin_role? || user.moderator_role? || user.author?(record)
  end

  def destroy?
    user.admin_role? || user.author?(record)
  end
end
