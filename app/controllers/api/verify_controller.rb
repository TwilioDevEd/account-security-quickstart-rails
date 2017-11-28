require 'authy'

class Api::VerifyController < ApplicationController
  def start()
    phone_number = params[:phone_number]
    country_code = params[:country_code]
    via = params[:via]

    if !phone_number || !country_code || !via
      render json: { err: 'Missing fields' }, status: :internal_server_error and return
    end

    response = Authy::PhoneVerification.start(
      via: via,
      country_code: country_code,
      phone_number: phone_number
    )

    if ! response.ok?
      render json: { err: 'Error delivering code verification' }, status: :internal_server_error and return
    end

    render json: response, status: :ok
  end

  def verify()
    phone_number = params[:phone_number]
    country_code = params[:country_code]
    token = params[:token]

    if !phone_number || !country_code || !token
      render json: { err: 'Missing fields' }, status: :internal_server_error and return
    end

    response = Authy::PhoneVerification.check(
      verification_code: token,
      country_code: country_code,
      phone_number: phone_number
    )

    if ! response.ok?
      render json: { err: 'Verify Token Error' }, status: :internal_server_error and return
    end

    session[:authy] = true
    render json: response, status: :ok
  end
end
