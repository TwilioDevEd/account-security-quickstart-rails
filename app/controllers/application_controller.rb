require 'authy'

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :exception

  def register()
    if session[:user_id]
      redirect_to '/'
    end

    user = User.find_by!(username: params[:username])

    rescue ActiveRecord::RecordNotFound => e
      logger.warn e.to_s
      render json: { error: e.to_s }, status: :internal_server_error
    end

    if user
      render json: { err: 'Username Already Registered' }, status: :conflict
    end

    authy = Authy::API.register_user(
      :email => params['email'],
      :phone_number => params['phone_number'],
      :country_code => params['country_code']
    )

    if ! authy.ok?
      logger.warn "Authy didn't handle well the registration"
      render json: { error: "Authy didn't handle well the registration" }, status: :service_unavailable
    end

    new_user = User.create(
      :username params['username'],
      :email params['email'],
      :authyId authy.id,
      :password params['password ']
    )

    rescue ActiveRecord::NotCreated => e
      logger.warn e.to_s
      render json: { error: e.to_s }, status: :internal_server_error
    end

    session[:user] = user
  end
end
