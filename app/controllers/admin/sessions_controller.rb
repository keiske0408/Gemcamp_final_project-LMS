class Admin::SessionsController < Devise::SessionsController
  layout 'admin'
  def after_sign_in_path_for(resource)
    resource.admin? ? admin_root_path : client_root_path
  end
end


