class Admin::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    admin_root_path # Redirect to admin's home page
  end
end


