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

  private

  def find_customer_plan
    if session[:current_customer_plan]
      Plan.build_plan(session[:current_customer_plan])
    elsif customer_signed_in?
      plan = Enrollment.find_customer_plan(current_customer.token)
      session[:current_customer_plan] = plan.to_json
      plan
    end
  end
end
