class Api::AuthenticationController < ApplicationController
  def login()
    user = User.find_by(username: params[:username])

    if ! user
      err = 'Username Not Found'
    end

    if params[:password] && user && params[:password] != user.password
      err = 'Wrong Password'
    end

    if err
      render json: { err: err }, status: :unauthorized and return
    end

    reset_session
    session[:username] = user.username
    session[:logged_in] = true
    session[:authy] = false
    session[:ph_verified] = false

    data = {
      loggedIn: true,
      user: user.id,
      username: user.username,
      msg: 'Authenticated as: ' + user.username,
      authy: false,
      ph_verified: false
    }

    render json: { session: data }, status: :ok
  end

  def logout
    reset_session
    head :ok
  end

  def logedIn
    url = '/protected'

    if ! session[:logged_in]
      url = '/login'
    end

    if ! session[:authy]
      url = '/2fa'
    end

    render json: { url: url }, status: :ok
  end
end
