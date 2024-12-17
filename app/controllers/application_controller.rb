class ApplicationController < ActionController::Base
  before_action :set_locale

  # def after_sign_in_path_for(resource)
  #   if resource.admin?
  #     admin_root_path
  #   else
  #     client_root_path
  #   end
  # end
  def set_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
  end
end
