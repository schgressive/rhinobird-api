class Api::ConfirmationsController < Devise::ConfirmationsController

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    if successfully_sent?(resource)
      render status: 200
    else
      render status: 400
    end
  end

  private

  def after_confirmation_path_for(resource_name, resource)
    "#{Rails.application.config.host_protocol}://#{Rails.application.config.public_host}/"
  end

end
