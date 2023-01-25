# frozen_string_literal: true

Rails.application.routes.draw do
  post '/subscription', to: 'subscription#create'
end
