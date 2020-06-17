# frozen_string_literal: true

# This class handle verify process with twi
class Api::VerifyController < ApplicationController
  before_action :set_twilio_client, only: [:start, :verify]

  def start
    phone_number = params[:phone_number]
    via = params[:via]

    if !phone_number || !via
      render json: { err: 'Missing fields' }, status: :internal_server_error and return
    end

    verification = start_verification(phone_number, via)

    unless verification.sid
      render json: { err: 'Error delivering code verification' }, status: :internal_server_error and return
    end

    puts "Successfully sent verification, #{verification.sid}"
    render json: { sid: verification.sid }, status: :ok
  end

  def verify
    phone_number = params[:phone_number]
    token = params[:token]

    if !phone_number || !token
      render json: { err: 'Missing fields' }, status: :internal_server_error and return
    end

    response = check_verification(phone_number, token)

    unless response.status
      puts"Error creating phone reg request, #{err}"
      render json: { err: 'Verify Token Error' }, status: :internal_server_error and return
    end

    if response.status != 'approved'
      render json: { err: 'Wrong code' }, status: 401 and return
    end

    session[:authy] = true
    render json: { status: response.status }, status: :ok
  end

  private

  def set_twilio_client
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def start_verification(to, channel = 'sms')
    channel = 'sms' unless ['sms', 'voice'].include? channel
    verification = @client.verify.services(ENV['VERIFY_SERVICE_SID'])
                          .verifications
                          .create(:to => to, :channel => channel)
  end

  def check_verification(phone, code)
    verification_check = @client.verify.services(ENV['VERIFY_SERVICE_SID'])
                                .verification_checks
                                .create(:to => phone, :code => code)
  end
end
