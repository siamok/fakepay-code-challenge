# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :subscription_plan
  belongs_to :customer

  def safe_representation
    attributes.except(:payment_token.to_s)
  end
end
