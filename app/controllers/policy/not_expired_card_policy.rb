# frozen_string_literal: true

class NotExpiredCardPolicy
  attr_reader :credit_card

  def initialize(credit_card)
    @credit_card = credit_card
  end

  def violates?
    card_expired?
  end

  private

  def card_expired?
    year_expired? || month_expired?
  end

  def year_expired?
    Time.now.year > credit_card.expiration_year.to_i
  end

  def month_expired?
    (Time.now.year == credit_card.expiration_year.to_i && Time.now.month > credit_card.expiration_month.to_i)
  end
end
