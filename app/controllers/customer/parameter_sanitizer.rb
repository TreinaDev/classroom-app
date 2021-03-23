class Customer::ParameterSanitizer < Devise::ParameterSanitizer
  def initialize(*)
    super
    permit(:sign_up, keys: [:full_name, :cpf, :age, :payment_methods])
  end
end