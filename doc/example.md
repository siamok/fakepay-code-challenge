# Examples

Run server

`rails s`

### Verification

In other terminal

```
rails c
Subscription.all
Customer.all
# etc
```

## Simple example

```
curl -X POST -H "Content-Type: application/json" \
 -d "{\"shipping\":{\"name\":\"test\",\"address\":\"Testing st, Test \",\"zip_code\":\"12345\"},\"billing\":{\"card_number\":\"4242424242424242\",\"expiration_month\":6,\"expiration_year\":2024,\"cvv\":\"123\",\"billing_zip_code\":\"12345\"},\"plan\":{\"id\":1}}" \
  localhost:3000/subscription
```

## With customer_id

After completing first subscription and receiving id (`shipping: { customer_id: 1}`)

```
curl -X POST -H "Content-Type: application/json" \
 -d "{\"shipping\":{\"name\":\"test\",\"address\":\"Testing st, Test \",\"zip_code\":\"12345\",\"customer_id\":\"1\"},\"billing\":{\"card_number\":\"4242424242424242\",\"expiration_month\":6,\"expiration_year\":2024,\"cvv\":\"123\",\"billing_zip_code\":\"12345\"},\"plan\":{\"id\":1}}" \
  localhost:3000/subscription
```

## Use payment_token in cron

For testing purposes, change `config/schedule.rb`:

```
every 1.day -> every 1.minute
```

and `lib/tasks/cron.rake`:

```
subscriptions = Subscription.where('last_purchase_date <= ?', Time.now - 1.day) ->
subscriptions = Subscription.where('last_purchase_date <= ?', Time.now - 1.minute)
```

and after 1 minute execute

`rake cron:renew_subscription`

Should have `last_purchase_date` updated.