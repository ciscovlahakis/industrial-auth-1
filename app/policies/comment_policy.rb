class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # Photos where user is public or user is comment's author
      scope.includes(:photo).where('users.private = ? OR comments.author_id = ?', false, user.id).references(:photo)
    end
  end

  def update?
    is_author?
  end

  def destroy?
    is_author?
  end

  private

  def is_author?
    user.id == record.author.id
  end
end
