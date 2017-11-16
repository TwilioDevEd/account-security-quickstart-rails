require 'authy'

class Api::UsersController < ApplicationController
  def register()
    if session[:user_id]
      redirect_to '/'
    end

    user = User.find_by(username: params[:username])

    if user
      render json: { err: 'Username Already Registered' }, status: :conflict and return
    end

    authy = Authy::API.register_user(
      email: params[:email],
      phone_number: params[:phone_number],
      country_code: params[:country_code]
    )

    if ! authy.ok?
      error_msg = "Authy didn't handle well the registration"
      logger.warn error_msg
      render json: { err: error_msg }, status: :internal_server_error and return
    end

    new_user = User.create(
      username: params[:username],
      email: params[:email],
      # authy_id: authy.id,
      authy_id: 2,
      password: params[:password]
    )

    if ! new_user
      logger.warn e.to_s
      render json: { error: e.to_s }, status: :internal_server_error and return
    end

    session[:username] = user.username
    session[:logged_in] = true
    render json: {}, status: :ok
  end
end
