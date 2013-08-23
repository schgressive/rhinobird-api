class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!
  skip_before_filter :require_no_authentication
  skip_before_filter :verify_authenticity_token
  def create
    resource = User.new(resource_params)
    if resource.save
      resource.ensure_authentication_token!
      sign_in resource
      render :status => 200,
        :json => { :success => true,
                   :info => "Registered",
                   :data => { :user => resource, auth_token: resource.authentication_token }  }


    else
      render :status => :unprocessable_entity,
        :json => { :success => false,
                   :info => resource.errors,
                   :data => {} }
    end
  end

  private
  def resource_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :username)
  end
end
