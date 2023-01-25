# frozen_string_literal: true

class SubscriptionController < ApplicationController
  def create
    render json: { status: 'succesful' }, status: 200
  end
end
