# frozen_string_literal: true

require 'fakepay'
require 'rake'

namespace :cron do
  desc 'Schedule subscription renewal'
  task renew_subscription: :environment do
    subscriptions = Subscription.where('last_purchase_date <= ?', Time.now - 1.day)

    subs_to_remove = []
    subscriptions.each do |sub|
      sub_plan = SubscriptionPlan.find(sub.subscription_plan_id)
      FakePay::Gateway.new.purchase_with_token(sub.payment_token, sub_plan.price)
      sub.update(last_purchase_date: Time.zone.now)
    rescue FakePay::PurchaseError
      # handling, for example
      subs_to_remove << sub
      # or could be just added 'cancelled'
    end

    subs_to_remove.each(&:destroy!)
  end
end
