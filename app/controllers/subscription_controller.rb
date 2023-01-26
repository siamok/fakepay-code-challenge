# frozen_string_literal: true

class SubscriptionController < ApplicationController
  def create
    subscription = SubscriptionAdmission.new(
      shipping_params: shipping_params,
      billing_params: billing_params,
      plan_params: plan_params
    ).purchase

    render json: { status: 'success', data: { subscription: subscription.safe_representation } }, status: :ok
  rescue ActiveRecord::RecordInvalid,
         FakePay::PurchaseError => e
    render json: { status: 'failure', data: { error: e.message } }, status: :unprocessable_entity
  end

  private

  def shipping_params
    params.require(:shipping).permit(:name, :address, :zip_code)
  end

  def billing_params
    params.require(:billing).permit(:card_number, :expiration_month, :expiration_year, :cvv, :billing_zip_code)
  end

  def plan_params
    params.require(:plan).permit(:id)
  end
end
