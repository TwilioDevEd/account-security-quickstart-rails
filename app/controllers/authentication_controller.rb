class AuthenticationController < ApplicationController
  def login
    user = User.find_by(username: params[:username])

    if ! user
      err = 'Username Not Found';
    end

    if params['password'] && params['password'] != user.password
      err = 'Wrong Password';
    end

    if err
      render status: :internal_server_error
    end

    session[:user] = user
    session[:logged_in] = true
    render status: :ok
  end

  def logout
    reset_session
    render status: ok
  end

  def logedIn
    url = '/login'

    if req.session.loggedIn && req.session.authy
      url = '/protected'
    end

    if req.session.loggedIn && !req.session.authy
      url = '/2fa'
    end

    render json: { url: url }, status: :ok
  end
end
