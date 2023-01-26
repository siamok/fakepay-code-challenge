# frozen_string_literal: true

require 'policy/not_expired_card_policy'

class CreditCardInformation
  class CardValidation < StandardError; end

  attr_reader :card_number, :expiration_month, :expiration_year, :cvv, :billing_zip_code

  def initialize(billing_params)
    @card_number = billing_params.fetch('card_number', nil)
    @expiration_month = billing_params.fetch('expiration_month', nil)
    @expiration_year = billing_params.fetch('expiration_year', nil)
    @cvv = billing_params.fetch('cvv', nil)
    @billing_zip_code = billing_params.fetch('billing_zip_code', nil)
  end

  def validate
    raise CreditCardInformation::CardValidation, 'Missing card information' if missing_argument?
    raise CreditCardInformation::CardValidation, 'Expired card' if NotExpiredCardPolicy.new(self).violates?
  end

  private

  # probably frontend would check it first...
  def missing_argument?
    card_number.empty? ||
      expiration_month.empty? ||
      expiration_year.empty? ||
      cvv.empty? ||
      billing_zip_code.empty?
  end
end
