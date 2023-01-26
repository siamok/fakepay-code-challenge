# frozen_string_literal: true

module FakePay
  class PurchaseError < StandardError; end

  class Gateway
    attr_reader :url, :token

    def initialize
      @url = Rails.configuration.x.fakepay[:url]
      @token = Rails.configuration.x.fakepay[:token]
    end

    def purchase(credit_card_information, plan_price)
      response = HTTParty.post(
        url,
        body: credit_card_body(credit_card_information, plan_price),
        headers: headers
      )

      parse_response(response)
    end

    def purchase_with_token(payment_token, plan_price)
      response = HTTParty.post(
        url,
        body: payment_token_body(payment_token, plan_price),
        headers: headers
      )

      parse_response(response)
    end

    private

    def parse_response(response)
      response_body = JSON.parse(response.body).symbolize_keys

      raise PurchaseError, ERROR_CODES[response_body.fetch(:error_code, nil)] unless response_body.fetch(:success)

      response_body.fetch(:token, nil)
    end

    def credit_card_body(credit_card_information, plan_price)
      {
        amount: plan_price,
        card_number: credit_card_information[:card_number],
        cvv: credit_card_information[:cvv],
        expiration_month: credit_card_information[:expiration_month],
        expiration_year: credit_card_information[:expiration_year],
        zip_code: credit_card_information[:billing_zip_code]
      }
    end

    def payment_token_body(payment_token, plan_price)
      {
        amount: plan_price,
        token: payment_token
      }
    end

    def headers
      {
        'Content-Type': 'application/json',
        'Authorization': "Token token=#{token}"
      }
    end
  end
end
