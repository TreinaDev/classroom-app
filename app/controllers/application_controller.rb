class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name photo])
  end

  def authenticate_user_or_customer!
    return redirect_to root_path, notice: t("video_classes.messages.must_be_signed") unless user_signed_in? || customer_signed_in?
  end
end
