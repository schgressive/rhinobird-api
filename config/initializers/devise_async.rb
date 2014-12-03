if ["test"].include?(Rails.env)
  Devise::Async.enabled = false
else
  Devise::Async.setup do |config|
    config.enabled  = true
    config.backend  = :sidekiq
    config.queue    = :mailer
  end
end
