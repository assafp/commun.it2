TWITTER_CONSUMER = {
  key: 'uay7lJ1i5xS21xqpXYMw',
  secret: 'V0Sx1yX2LiQieJ8HqukITVbA1o5XLbenw4vFxs7J4'
}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_CONSUMER[:key], TWITTER_CONSUMER[:secret]
end