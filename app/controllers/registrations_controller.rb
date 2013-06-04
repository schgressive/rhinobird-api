class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication
  skip_before_filter :verify_authenticity_token
  def create
    build_resource
    resource.skip_confirmation!
    if resource.save
      render :status => 200,
        :json => { :success => true,
                   :info => "Registered",
                   :data => { :user => resource }  }
    else
      render :status => :unprocessable_entity,
        :json => { :success => false,
                   :info => resource.errors,
                   :data => {} }
    end
  end

  private
  def resource_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
