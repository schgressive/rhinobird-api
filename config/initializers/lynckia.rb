require "nuve"
superserviceID = '51a4f2b4c80d2484cb87b51c'
superserviceKey = '20927'
NUVE = Nuve.new(superserviceID, superserviceKey, "http://192.168.1.7:3000/")

ActionDispatch::Callbacks.to_prepare do
  # configure stuff or initialize
  Stream.send :include, NuveHook unless Rails.env.test?
end
