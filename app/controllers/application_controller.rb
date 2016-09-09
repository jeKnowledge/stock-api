class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_user

  def current_user
    @current_user
  end

  def authenticate_user
    token_authentication || render_unauthorized
  end

  def token_authentication
    authenticate_with_http_token do |token, options|
      @current_user = User.find_by(access_token: token)
      # TODO: handle session expiration verification
      #@current_user && !@current_user.access_token_expired?
    end
  end

  def render_unauthorized
    render json: 'Bad credentials', status: :unauthorized
  end
end
