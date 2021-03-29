class ApplicationController < ActionController::Base
  protected

  def devise_parameter_sanitizer
    if resource_class == Customer
      Customer::ParameterSanitizer.new(Customer, :customer, params)
    elsif resource_class == User
      Users::ParameterSanitizer.new(User, :user, params)
    else
      super # Use the default one
    end
  end

  def authenticate_user_or_customer!
    return if user_signed_in? || customer_signed_in?

    redirect_to root_path, notice: t('video_classes.messages.must_be_signed')
  end
end
