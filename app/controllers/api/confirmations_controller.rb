class Api::ConfirmationsController < Devise::ConfirmationsController

  private

  def after_confirmation_path_for(resource_name, resource)
    "http://#{Rails.application.config.public_host}/"
  end

end
