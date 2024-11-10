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
      resource.save if resource.valid? # Ensure parent_id is saved
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number, :coins, :total_deposit, :children_members, :username, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number, :username, :password, :image])
  end
end
