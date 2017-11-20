require 'authy'

class Api::UsersController < ApplicationController
  def register()
    if session[:user_id]
      redirect_to '/'
    end

    if User.find_by(username: params[:username])
      render json: { err: 'Username Already Registered' }, status: :conflict and return
    end

    authy = Authy::API.register_user(
      email: params[:email],
      phone_number: params[:phone_number],
      country_code: params[:country_code]
    )

    if ! authy.ok?
      error_msg = "One attribute is not valid, would you mind to take a look at them?"
      logger.warn error_msg
      render json: { err: error_msg }, status: :internal_server_error and return
    end

    new_user = User.create(
      username: params[:username],
      email: params[:email],
      authy_id: authy.id,
      password: params[:password]
    )

    if ! new_user
      logger.warn e.to_s
      render json: { error: e.to_s }, status: :internal_server_error and return
    end

    session[:username] = new_user.username
    session[:logged_in] = true
    render json: {}, status: :ok
  end
end
