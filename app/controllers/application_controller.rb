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
end
