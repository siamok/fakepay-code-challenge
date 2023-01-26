# frozen_string_literal: true

class TransactionPreservation
  attr_reader :customer_info, :subscription_plan, :payment_token

  def initialize(customer_info, subscription_plan, payment_token)
    @customer_info = customer_info
    @subscription_plan = subscription_plan
    @payment_token = payment_token
  end

  def commit_transaction
    subscription = Subscription.new(id: 1,
                                    customer_id: customer_info.id,
                                    subscription_plan_id: subscription_plan.id,
                                    payment_token: payment_token,
                                    last_purchase_date: Time.now)
    subscription.save
    subscription
  end
end
