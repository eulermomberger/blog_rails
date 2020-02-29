class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user.nil?
      render json: {error: 'user not found'}, status: :not_found
    elsif @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     username: @user.username, id: @user.id }, status: :ok
    else
      render json: { error: 'password incorrect' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end