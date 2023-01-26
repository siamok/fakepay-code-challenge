# frozen_string_literal: true

require 'rails_helper'

Rails.application.load_tasks
TASK_NAME = 'cron:renew_subscription'

describe 'renew_subscription.rake' do
  let(:customer) do
    Customer.create!(
      name: 'test',
      zip_code: '12345',
      address: 'test 1, test'
    )
  end

  after do
    Rake::Task[TASK_NAME].reenable
  end

  describe 'successful operation' do
    context 'when valid is found' do
      let!(:subscription) do
        Subscription.create!(
          customer_id: customer.id,
          subscription_plan_id: 2,
          payment_token: 'test',
          last_purchase_date: Time.zone.now - 1.month
        )
      end

      let(:httparty_response) { { token: subscription.payment_token, success: true, error_code: nil } }

      before do
        http_response = double('httparty', body: httparty_response.to_json)
        allow(HTTParty).to receive(:post).and_return(http_response)
      end

      it 'renews that subscription' do
        Rake::Task[TASK_NAME].invoke

        expect(subscription.reload.last_purchase_date.to_s).to eq(Time.zone.now.strftime('%Y-%m-%d'))
      end
    end
  end

  describe 'subscription removal' do
    context 'when cannot be renewed' do
      let!(:subscription) do
        Subscription.create!(
          customer_id: customer.id,
          subscription_plan_id: 3,
          payment_token: 'test2',
          last_purchase_date: Time.zone.now - 1.month
        )
      end

      let(:httparty_response) { { token: nil, success: false, error_code: 1_000_004 } }

      before do
        http_response = double('httparty', body: httparty_response.to_json)
        allow(HTTParty).to receive(:post).and_return(http_response)
      end

      it 'removes that subscription' do
        Rake::Task[TASK_NAME].invoke

        expect(Subscription.find_by_id(subscription.id)).to be_nil
      end
    end
  end
end
