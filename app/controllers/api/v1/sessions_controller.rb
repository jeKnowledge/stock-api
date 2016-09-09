module Api::V1
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user, only: :create

    def create
      user = User.find_by(email: user_params[:email])
                 .try(:authenticate, user_params[:password])

      if user 
        user.refresh_access_token!
        render json: user, status: :ok
      else
        render json: { message: 'The email and password you provided did not match.' }, status: :unauthorized
      end
    end

    def destroy
      current_user.expire_access_token!
      render json: { message: 'Logged out.' }, status: :ok
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
