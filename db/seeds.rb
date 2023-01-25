# frozen_string_literal: true

SubscriptionPlan.find_or_create_by(id: 1, name: 'BRONZE BOX', price: 1999)
SubscriptionPlan.find_or_create_by(id: 2, name: 'SILVER BOX', price: 4900)
SubscriptionPlan.find_or_create_by(id: 3, name: 'GOLD BOX', price: 9900)
