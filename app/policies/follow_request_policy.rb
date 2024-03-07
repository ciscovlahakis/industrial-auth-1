class FollowRequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(recipient_id: user.id) # Only show follow requests where the user is the recipient
    end
  end

  def create?
    true # Anyone can create a follow request
  end

  def destroy?
    user == record.sender || user == record.recipient # Only the sender or recipient can destroy the request
  end

  def update?
    user == record.recipient # Only the recipient can update the status of the request
  end
end
