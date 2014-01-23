class Api::ConfirmationsController < Devise::ConfirmationsController

  private

  def after_confirmation_path_for(resource_name, resource)
    "#{Rails.application.config.host_protocol}://#{Rails.application.config.public_host}/"
  end

end
