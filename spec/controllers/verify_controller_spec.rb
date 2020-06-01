require 'rails_helper'

class MockTwilioClient
  attr_reader :verify

  def initialize(success = true)
    @verify = MockVerify.new(success)
  end
end

class MockVerify
  def initialize(success)
    @success = success
  end

  def services(verify_services_id)
    MockVerifications.new(@success)
  end
end

class MockVerifications
  attr_reader :verifications
  attr_reader :verification_checks

  def initialize(success)
    @verifications = MockCreate.new(success)
    @verification_checks = MockCreate.new(success)
  end
end

class MockCreate
  def initialize(success)
    @success = success
  end

  def create(params)
    MockResponse.new(@success)
  end
end

class MockResponse
  def initialize(success)
    @success = success
  end

  def sid
    @success ? 'sid' : nil
  end

  def status
    @success ? 'approved' : 'pending'
  end
end

RSpec.describe Api::VerifyController, type: :controller do
  describe 'POST /start' do
    context 'when all fields are sent' do
      it 'returns status 200 if everything is correct' do
        allow(Twilio::REST::Client).to receive(:new).and_return(MockTwilioClient.new)

        post :start, params: { phone_number: '123456789', country_code: '+593', via: 'sms' }

        expect(response.status).to eq(200)
        expect(response.body).to eq("{\"sid\":\"sid\"}")
      end

      it 'returns status 500 if something is wrong' do
        allow(Twilio::REST::Client).to receive(:new).and_return(MockTwilioClient.new(false))

        post :start, params: { phone_number: '123456789', country_code: '+593', via: 'sms' }

        expect(response.status).to eq(500)
        expect(response.body).to eql("{\"err\":\"Error delivering code verification\"}")
      end
    end

    context 'when a field is missing' do
      it 'returns status 500 and error message' do
        post :start, params: { phone_number: '123456789', via: 'SMS' }

        expect(response.status).to eq(500)
        expect(response.body).to eql("{\"err\":\"Missing fields\"}")
      end
    end
  end

  describe 'POST /verify' do
    context 'when all fields are sent' do
      it 'returns status 200 if status is approved' do
        allow(Twilio::REST::Client).to receive(:new).and_return(MockTwilioClient.new)
        post :verify, params: { phone_number: '123456789', country_code: '+593', token: 'my_token' }

        expect(session[:authy]).to eq(true)
        expect(response.body).to eq("{\"status\":\"approved\"}")
        expect(response.status).to eq(200)
      end

      it 'returns status 401 if status is not approved' do
        allow(Twilio::REST::Client).to receive(:new).and_return(MockTwilioClient.new(false))
        post :verify, params: { phone_number: '123456789', country_code: '+593', token: 'my_token' }

        expect(session[:authy]).to eq(nil)
        expect(response.status).to eq(401)
        expect(response.body).to eql("{\"err\":\"Wrong code\"}")
      end
    end

    context 'when a field is missing' do
      it 'returns status 500 and error message' do
        post :verify, params: { phone_number: '123456789', token: 'my_token' }

        expect(response.status).to eq(500)
        expect(response.body).to eql("{\"err\":\"Missing fields\"}")
      end
    end
  end
end
