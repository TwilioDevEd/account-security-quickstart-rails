require 'rails_helper'

RSpec.describe Api::VerifyController, type: :controller do
  it 'verify a phone number' do
    post :start, params: { phone_number: '958902747', country_code: '+593', via: 'sms' }

    expect(response.status).to eq(500)
  end
end
