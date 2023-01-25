# frozen_string_literal: true

class CreateSubscriptionPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.integer :price

      t.timestamps
    end
  end
end
