# Fakepay Code Challenge

The API should accept a request to create a subscription. Included in the request will be:

- The customer's shipping information: their name, address, zip code.
- The customer's billing information: card number, expiration date, CVV, and billing zip code.
- The ID of the plan the customer is subscribing to.

Your API will integrate with the Fakepay payment gateway with an API key.

When a request to your API endpoint is made with the above data, you will attempt a "purchase" with the customer's payment information. If the purchase is successful, a new subscription will be created. If it is not, helpful errors should be returned, so that frontend developers can render those to the customer.

The data that is stored upon a successful signup should be sufficient to charge the customer every month for the product they are subscribed to, on their billing date, without any manual intervention. For our purposes, we will bill monthly, from the date of the customer's signup. You don't have to write the code that renews customer subscriptions, but you can optionally do so as a bonus.

Because of PCI requirements, we cannot store the customer's credit card number, anywhere. We will only have access to it at their initial signup.

For simplicity's sake, assume that the frontend will pre-validate customer data before a request is sent to your API endpoint

# Setup
```
bundle install
rake db:create
rake db:migrate
rake db:seed
cp config/fakeapi.template.yml config/fakeapi.yml
# replace TOKEN with your API token
rspec
```

### Cron

To schedule cron task

`bundle exec whenever --update-crontab --set environment='development'`

To clear crontab

`bundle exec whenever --clear-crontab`

(cron does not work in my WSL env :S)


# Example

Check [Example](doc/example.md)