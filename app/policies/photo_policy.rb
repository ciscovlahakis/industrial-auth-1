class PhotoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.present?
        # Photo belong to user OR their followers OR public users
        scope.where('photos.owner_id = ? OR photos.owner_id IN (?) OR photos.owner_id IN (?)',
                    user.id, user.following_ids, User.where(private: false).pluck(:id))
      else
        # Photos belong to public users
        scope.where(owner_id: User.where(private: false).pluck(:id))
      end
    end
  end

  attr_reader :user, :photo

  def initialize(user, photo)
    @user = user
    @photo = photo
  end

  def create?
    true
  end

  def update?
    @user.id == @photo.owner_id
  end

  def destroy?
    update?
  end

    # Our policy is that a photo should only be seen by the owner or followers
  #   of the owner, unless the owner is not private in which case anyone can
  #   see it
  def show?
    user == photo.owner ||
      !photo.owner.private? ||
      photo.owner.followers.include?(user)
  end
end
