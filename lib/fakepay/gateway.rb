# frozen_string_literal: true

module FakePay
  class GatewayError < StandardError; end

  class Gateway
    def purchase(_, _)
      'token'
    end
  end
end
