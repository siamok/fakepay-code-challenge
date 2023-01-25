# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  describe 'POST /create' do
    let(:json_headers) { { 'ACCEPT' => 'application/json' } }
    # shipping information: their name, address, zip code.
    # billing information: card number, expiration date, CVV, and billing zip code
    # ID of the plan the customer is subscribing to.

    let(:customer_name) { 'Test Testinhio' }
    let(:customer_zip_code) { '12345' }
    let(:customer_address) { { street: 'Testing st', city: 'Test City' } }

    let(:card_number) { '123456789' }
    let(:expiration_date) { '1234-5-6' }
    let(:billing_zip_code) { '12345' }
    let(:cvv) { '123' }

    let(:shipping_info) { { name: customer_name, address: customer_address, zip_code: customer_zip_code } }
    let(:customer_billing) do
      {
        card_number: card_number,
        expiration_date: expiration_date,
        cvv: cvv,
        billing_zip_code: billing_zip_code
      }
    end

    let(:customer_plan) { { id: 1 } }
    let(:params) do
      {
        shipping_info: shipping_info,
        billing_info: customer_billing,
        plan_info: customer_plan
      }
    end

    context 'valid request' do
      it 'should respond with success' do
        post '/subscription', params: params, headers: json_headers

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
