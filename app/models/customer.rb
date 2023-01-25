# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :subscription_plans

  validates_presence_of :name, :address, :zip_code
end
