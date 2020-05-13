require 'rails_helper'

class PhoneVerificationRespose
  def initialize(ok_value)
    @ok_value = ok_value
  end

  def ok?
    @ok_value
  end
end

RSpec.describe Api::VerifyController, type: :controller do
  describe 'POST /start' do
    context 'when all fields are sent' do
      it 'returns status 200 if everything is correct' do
        allow(Authy::PhoneVerification).to receive(:start).and_return(PhoneVerificationRespose.new(true))
        post :start, params: { phone_number: '123456789', country_code: '+593', via: 'sms' }

        expect(response.status).to eq(200)
      end

      it 'returns status 500 if something is wrong' do
        allow(Authy::PhoneVerification).to receive(:start).and_return(PhoneVerificationRespose.new(false))
        post :start, params: { phone_number: '123456789', country_code: '+593', via: 'sms' }

        expect(response.status).to eq(500)
        expect(response.body).to eql("{\"err\":\"Error delivering code verification\"}")
      end
    end

    context 'when a field is missing' do
      it 'returns status 500 and error message' do
        post :start, params: { phone_number: '123456789', country_code: '+593' }

        expect(response.status).to eq(500)
        expect(response.body).to eql("{\"err\":\"Missing fields\"}")
      end
    end
  end

  describe 'POST /verify' do
    context 'when all fields are sent' do
      it 'returns status 200 if everything is correct' do
        allow(Authy::PhoneVerification).to receive(:check).and_return(PhoneVerificationRespose.new(true))
        post :verify, params: { phone_number: '123456789', country_code: '+593', token: 'my_token' }

        expect(response.status).to eq(200)
      end

      it 'returns status 500 if something is wrong' do
        allow(Authy::PhoneVerification).to receive(:check).and_return(PhoneVerificationRespose.new(false))
        post :verify, params: { phone_number: '123456789', country_code: '+593', token: 'my_token' }

        expect(response.status).to eq(500)
        expect(response.body).to eql("{\"err\":\"Verify Token Error\"}")
      end
    end

    context 'when a field is missing' do
      it 'returns status 500 and error message' do
        post :verify, params: { phone_number: '123456789', country_code: '+593' }

        expect(response.status).to eq(500)
        expect(response.body).to eql("{\"err\":\"Missing fields\"}")
      end
    end
  end
end
