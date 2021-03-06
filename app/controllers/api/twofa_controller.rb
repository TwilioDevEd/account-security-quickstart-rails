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
    user = User.find_by(username: session[:username])

    if ! user
      render json: { err: 'Username Not Found' }, status: :internal_server_error and return
    end

    status = Authy::OneTouch.approval_request_status({uuid: session[:uuid]})

    if ! status.ok?
      render json: { err: 'One Touch Status Error' }, status: :internal_server_error and return
    end

    if status['approval_request']['approval_request'] == 'approved'
      session.delete(:uuid) || session.delete('uuid')
      session[:authy] = true
    end

    render json: {body: status}, status: :ok
  end

  def onetouch()
    user = User.find_by(username: session[:username])

    if ! user
      render json: { err: 'Username Not Found' }, status: :internal_server_error and return
    end

    one_touch = Authy::OneTouch.send_approval_request(
      id: user.authy_id,
      message: 'Login requested for Account Security account.',
      details: {
        AuthyID: user.authy_id,
        Username: user.username,
        Location: 'San Francisco, CA',
        Reason: 'Demo by Account Security'
      },
      hidden_details: { test: "This is a" }
    )

    if ! one_touch.ok?
      render json: { err: 'Create Push Error' }, status: :internal_server_error and return
    end

    session[:uuid] = one_touch.approval_request['uuid']

    render json: one_touch, status: :ok
  end
end
