# app/controllers/users/client/registrations_controller.rb
class Client::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_promoter, only: [:create]
  # You can customize registration actions here if needed
  def create
    super do |resource|
      if @promoter
        resource.update(parent_id: @promoter.id)
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number, :coins, :total_deposit, :children_members, :username, :email, :password, :password_confirmation, :parent_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number, :username, :password, :image])
  end

  private

  def set_promoter
    # Get the promoter email from the URL params
    promoter_email = params[:promoter]
    Rails.logger.debug "Promoter email: #{promoter_email}"
    if promoter_email.present?
      @promoter = User.find_by(email: promoter_email)
    end
  end
end


