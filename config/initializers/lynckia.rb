require "nuve"
superserviceID = ENV['NUVE_SERVICE_ID']
superserviceKey = ENV['NUVE_SERVICE_KEY']
NUVE = Nuve.new(superserviceID, superserviceKey, ENV['NUVE_SERVICE_HOST'])

ActionDispatch::Callbacks.to_prepare do
  # configure stuff or initialize
  Stream.send :include, NuveHook unless Rails.env.test?
end
