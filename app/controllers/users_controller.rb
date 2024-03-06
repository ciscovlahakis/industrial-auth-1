class UsersController < ApplicationController
  before_action :set_user, only: %i[ show liked feed followers following discover ]
  before_action :authorize_resource

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  private
    def set_user
      if params[:username]
        @user = User.find_by!(username: params.fetch(:username))
      else
        @user = current_user
      end
    end

    def authorize_resource
      authorize @user || User
    end

    def record_not_found
      redirect_to users_path, alert: 'User not found.'
    end

end
