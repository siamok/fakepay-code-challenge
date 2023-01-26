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
    customer = Customer.create!(shipping_params)
    payment_token = FakePay::Gateway.new.purchase(billing_params, subscription_plan.price)

    TransactionPreservation.new(customer, subscription_plan, payment_token).commit_transaction
  end

  private

  def subscription_plan
    @subscription_plan ||= SubscriptionPlan.find(plan_params.fetch('id', nil))
  end
end
