# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  describe 'POST /create' do
    let(:json_headers) { { 'ACCEPT' => 'application/json' } }
    let(:customer_name) { 'Test Testinhio' }
    let(:customer_zip_code) { '12345' }
    let(:customer_address) { 'Testing st, Test City' }
    let(:card_number) { '123456789' }
    let(:expiration_month) { 6 }
    let(:expiration_year) { Time.now.year + 1 }
    let(:billing_zip_code) { '12345' }
    let(:cvv) { '123' }
    let(:customer_shipping) { { name: customer_name, address: customer_address, zip_code: customer_zip_code } }
    let(:customer_billing) do
      {
        card_number: card_number,
        expiration_month: expiration_month,
        expiration_year: expiration_year,
        cvv: cvv,
        billing_zip_code: billing_zip_code
      }
    end

    let(:customer_plan) { { id: 1 } }
    let(:params) { { shipping: customer_shipping, billing: customer_billing, plan: customer_plan } }
    let(:httparty_response) { { token: '2e3673154977752b3ed5e0a5a849c3', success: true, error_code: nil } }

    before do
      http_response = double('httparty', body: httparty_response.to_json)
      allow(HTTParty).to receive(:post).and_return(http_response)
    end

    describe 'valid request' do
      context 'when all params provided' do
        it 'reponds with success' do
          post '/subscription', params: params, headers: json_headers

          expect(response).to have_http_status(:ok)
          expect(response_json.fetch('status')).to eq('success')
        end

        it 'reponds with subscription' do
          post '/subscription', params: params, headers: json_headers

          subscription = response_json.fetch('data').fetch('subscription')
          expect(subscription.fetch('subscription_plan_id')).to eq(customer_plan[:id])
          expect(subscription.fetch('last_purchase_date')).to eq(Time.now.strftime('%Y-%m-%d'))
          expect(subscription['payment_token']).to eq(nil)
        end
      end
    end

    describe 'invalid request' do
      context 'when expired card provided' do
        let(:expiration_year) { Time.now.year - 1 }
        let(:httparty_response) { { token: nil, success: false, error_code: 1_000_004 } }

        it 'responds with failure' do
          post '/subscription', params: params, headers: json_headers
          expect(response).to have_http_status(422)
          expect(response_json.fetch('status')).to eq('failure')
          expect(response_json.fetch('data').fetch('error')).to eq('Expired card')
        end
      end
    end

    describe 'customer_id provided' do
      context 'when all params provided' do
        let(:customer) do
          Customer.create!(
            name: 'test',
            zip_code: '12345',
            address: 'test 1, test'
          )
        end

        let(:customer_shipping) do
          { name: customer_name, address: customer_address, zip_code: customer_zip_code, customer_id: customer.id }
        end

        it 'reponds with success' do
          post '/subscription', params: params, headers: json_headers

          expect(response).to have_http_status(:ok)
          expect(response_json.fetch('status')).to eq('success')
        end
      end
    end
  end

  def response_json
    JSON.parse(response.body)
  end
end
