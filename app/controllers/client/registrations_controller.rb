class Client::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    cookies[:promoter_email] = params[:promoter] if params[:promoter]
    super
  end

  def create
    super do |resource|
      promoter_email = cookies[:promoter_email]
      if promoter_email.present?
        promoter = User.find_by(email: promoter_email)
        resource.parent_id = promoter.id if promoter
      end
      if resource.save
        resource.check_parent_member_level if promoter.present?
        flash[:notice] = "Successfully registered"
        cookies.delete(:promoter_email) # Specify the cookie to delete
      else
        flash[:alert] = "Registration failed"
      end
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    if resource.update_with_password(account_update_params)
      flash[:notice] = "Account successfully updated!"
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords resource
      flash[:alert] = "Could not update your account: #{resource.errors.full_messages.join(', ')}"
      render :edit
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number, :coins, :total_deposit, :children_members, :username, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number, :username, :password, :image])
  end
end
