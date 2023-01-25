# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :customer, foreign_key: true
      t.references :subscription_plan, foreign_key: true
      t.string :payment_token
      t.date :last_purchase_date

      t.timestamps
    end
  end
end
