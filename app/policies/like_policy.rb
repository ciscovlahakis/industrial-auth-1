class LikePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # Adjust according to your application's scope needs
      scope.joins(:photo).where('photos.private = ?', false)
    end
  end

  def create?
    !already_liked? && photo_public?
  end

  def destroy?
    is_owner?
  end

  private

  def already_liked?
    Like.exists?(fan_id: user.id, photo_id: record.photo_id)
  end

  def is_owner?
    user == record.fan
  end

  def photo_public?
    !record.photo.private?
  end
end
