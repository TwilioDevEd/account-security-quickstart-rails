require 'authy'

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :exception

  def register()
    if session[:user_id]
      redirect_to '/'
    end

    user = User.find_by!(username: params['username'])

    rescue ActiveRecord::RecordNotFound => e
      logger.warn e.to_s
      render json: { error: e.to_s }, status: :internal_server_error and return
    end

    if user
      render json: { err: 'Username Already Registered' }, status: :conflict and return
    end

    authy = Authy::API.register_user(
      :email => params['email'],
      :phone_number => params['phone_number'],
      :country_code => params['country_code']
    )

    if ! authy.ok?
      error_msg = "Authy didn't handle well the registration"
      logger.warn error_msg
      render json: { err: error_msg }, status: :internal_server_error and return
    end

    new_user = User.create(
      :username params['username'],
      :email params['email'],
      :authy_id authy.id,
      :password params['password ']
    )

    rescue ActiveRecord::NotCreated => e
      logger.warn e.to_s
      render json: { error: e.to_s }, status: :internal_server_error and return
    end

    session[:user] = user
    session[:logged_in] = true
    render status: :ok
  end
end
