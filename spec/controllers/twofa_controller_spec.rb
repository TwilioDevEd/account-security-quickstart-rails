require 'rails_helper'

class APIRespose
  attr_reader :approval_request

  def initialize(ok_value)
    @ok_value = ok_value
    @approval_request = { :uuid => '123' }
  end

  def ok?
    @ok_value
  end
end

RSpec.describe Api::TwofaController, type: :controller do
  before(:all) do
    User.create({username: 'angie', email: 'angie@test.com', authy_id: '123', password: 'pass'})
  end

  after(:all) do
    User.delete_all
  end

  describe 'POST /sms' do
    context 'when a user exists' do
      context 'and everything is ok with Authy request_sms' do
        it'returns 200' do
          allow(Authy::API).to receive(:request_sms).and_return(APIRespose.new(true))
          post :sms, session: { username: 'angie' }

          expect(response.status).to eq(200)
        end
      end

      context 'and an error ocurrs with Authy request_sms' do
        it'returns 500' do
          allow(Authy::API).to receive(:request_sms).and_return(APIRespose.new(false))
          post :sms, session: { username: 'angie' }

          expect(response.body).to eql("{\"err\":\"Error requesting SMS token\"}")
          expect(response.status).to eq(500)
        end
      end
    end

    context 'when a user does not exists ' do
      it'returns 500' do
        post :sms, session: { username: 'not_exists' }

        expect(response.body).to eql("{\"err\":\"Username Not Found\"}")
        expect(response.status).to eql(500)
      end
    end
  end

  describe 'POST /voice' do
    context 'when user exists' do
      context 'and everything is ok with Authy request_phone_call' do
        it 'returs 200 code' do
          allow(Authy::API).to receive(:request_phone_call).and_return(APIRespose.new(true))
          post :voice, session: { username: 'angie' }

          expect(response.status).to eq(200)
        end
      end

      context 'and an error ocurrs with Authy request_phone_call' do
        it'returns 500' do
          allow(Authy::API).to receive(:request_phone_call).and_return(APIRespose.new(false))
          post :voice, session: { username: 'angie' }

          expect(response.body).to eql("{\"err\":\"Error requesting Phone call token\"}")
          expect(response.status).to eq(500)
        end
      end
    end

    context 'when a user does not exists ' do
      it'returns 500' do
        post :voice, session: { username: 'not_exists' }

        expect(response.body).to eql("{\"err\":\"Username Not Found\"}")
        expect(response.status).to eql(500)
      end
    end
  end

  describe 'POST /verify' do
    context 'when user exists' do
      context 'and everything is ok with Authy verify' do
        it 'returs 200 code' do
          allow(Authy::API).to receive(:verify).and_return(APIRespose.new(true))
          post :verify, session: { username: 'angie' }

          expect(response.status).to eq(200)
        end
      end

      context 'and an error ocurrs with Authy verify' do
        it'returns 500' do
          allow(Authy::API).to receive(:verify).and_return(APIRespose.new(false))
          post :verify, session: { username: 'angie' }

          expect(response.body).to eql("{\"err\":\"Verify Token Error\"}")
          expect(response.status).to eq(500)
        end
      end
    end

    context 'when a user does not exists ' do
      it'returns 500' do
        post :verify, session: { username: 'not_exists' }

        expect(response.body).to eql("{\"err\":\"Username Not Found\"}")
        expect(response.status).to eql(500)
      end
    end
  end

  describe 'POST /onetouch' do
    context 'when user exists' do
      context 'and everything is ok with Authy send_approval_request' do
        it 'returs 200 code' do
          allow(Authy::OneTouch).to receive(:send_approval_request).and_return(APIRespose.new(true))
          post :onetouch, session: { username: 'angie' }

          expect(response.status).to eq(200)
        end
      end

      context 'and an error ocurrs with Authy send_approval_request' do
        it'returns 500' do
          allow(Authy::OneTouch).to receive(:send_approval_request).and_return(APIRespose.new(false))
          post :onetouch, session: { username: 'angie' }

          expect(response.body).to eql("{\"err\":\"Create Push Error\"}")
          expect(response.status).to eq(500)
        end
      end
    end

    context 'when a user does not exists ' do
      it'returns 500' do
        post :onetouch, session: { username: 'not_exists' }

        expect(response.body).to eql("{\"err\":\"Username Not Found\"}")
        expect(response.status).to eql(500)
      end
    end
  end
end
