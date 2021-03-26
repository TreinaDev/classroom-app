class Users::ParameterSanitizer < Devise::ParameterSanitizer
  def initialize(*)
    super
    permit(:sign_up, keys: %i[name photo])
  end
end
