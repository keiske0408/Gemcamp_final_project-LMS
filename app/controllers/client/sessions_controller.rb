<<<<<<< HEAD
class Client::SessionsController < Devise::SessionsController
  # layout 'client' # Use a different layout for client login if needed

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end
end
=======
# frozen_string_literal: true
class Client::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end
  #
  # # POST /resource/sign_in
  # def create
  #   super
  # end
  #
  # # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
  #
  # # protected
  #
  # # If you have extra params to permit, append them to the sanitizer.
  # # def configure_sign_in_params
  # #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # # end
end
>>>>>>> Feature-2-and-3
