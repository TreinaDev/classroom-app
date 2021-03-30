class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :full_name, :cpf, :age, :birth_date, presence: true

  def send_data_to_enrollments_api
    url = Rails.configuration.url['customers_enrollment_url']
    response = Faraday.post(url, build_data, 'Content-Type' => 'application/json')
    return response if response.status == 201

    false
  end

  def build_data
    { full_name: self.full_name,
      email: self.email,
      cpf: self.cpf,
      birth_date: self.birth_date
      payment_methods: self.payment_methods }.to_json
  end

  def add_token(response)
    self.update(token: response.body.token)
  end
end
