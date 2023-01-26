# frozen_string_literal: true

require 'fakepay'
require 'transaction_preservation'

class SubscriptionAdmission
  attr_reader :shipping_params, :billing_params, :plan_params

  def initialize(shipping_params:, billing_params:, plan_params:)
    @shipping_params = shipping_params
    @billing_params = billing_params
    @plan_params = plan_params
  end

  def purchase
    credit_card_information = CreditCardInformation.new(billing_params)
    credit_card_information.validate

    customer = Customer.new(shipping_params)
    customer.save # TODO: returns false/true

    payment_token = fakepay_gateway.purchase(credit_card_information, subscription_plan.price)

    TransactionPreservation.new(customer, subscription_plan, payment_token).commit_transaction
  end

  private

  def fakepay_gateway
    @fakepay_gateway ||= FakePay::Gateway.new
  end

  def subscription_plan
    @subscription_plan ||= SubscriptionPlan.find(plan_params.fetch('id', nil))
  end
end