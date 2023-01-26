# frozen_string_literal: true

require 'fakepay'

class SubscriptionAdmission
  attr_reader :shipping_params, :billing_params, :plan_params

  def initialize(shipping_params:, billing_params:, plan_params:)
    @shipping_params = shipping_params
    @billing_params = billing_params
    @plan_params = plan_params
  end

  def purchase
    payment_token = FakePay::Gateway.new.purchase(billing_params, subscription_plan.price)

    TransactionPreservation.new(customer, subscription_plan, payment_token).commit_transaction
  end

  private

  def subscription_plan
    @subscription_plan ||= SubscriptionPlan.find(plan_params.fetch('id', nil))
  end

  def customer
    shipping_params.key?(:customer_id) ? existing_customer(shipping_params[:customer_id]) : Customer.create!(shipping_params)
  end

  def existing_customer(customer_id)
    Customer.find_by_id(customer_id)
  end
end
