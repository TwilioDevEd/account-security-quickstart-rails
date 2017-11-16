class Api::TwofaController < ApplicationController
  def sms()
    user = User.find_by(username: session[:username])

    if ! user
      render json: { err: 'Username Not Found' }, status: :internal_server_error and return
    end

    response = Authy::API.request_sms(id: user.authy_id)

    if ! response.ok?
      render json: { err: 'Error requesting SMS token' }, status: :internal_server_error and return
    end

    render json: response, status: :ok
  end

  def voice()
    user = User.find_by(username: session[:username])

    if ! user
      render json: { err: 'Username Not Found' }, status: :internal_server_error and return
    end

    response = Authy::API.request_phone_call(id: user.authy_id)

    if ! response.ok?
      render json: { err: 'Error requesting Phone call token' }, status: :internal_server_error and return
    end

    render json: response, status: :ok
  end

  def verify()
    user = User.find_by(username: session[:username])

    if ! user
      render json: { err: 'Username Not Found' }, status: :internal_server_error and return
    end

    response = Authy::API.verify(:id => user.authy_id, :token => params[:token])

    if ! response.ok?
      render json: { err: 'Verify Token Error' }, status: :internal_server_error and return
    end

    session[:authy] = true
    render json: response, status: :ok
  end

  def onetouchstatus()
  end

  def onetouch()
  end
end
