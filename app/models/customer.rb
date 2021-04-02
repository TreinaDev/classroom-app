class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :watched_classes, dependent: :destroy
  has_many :video_classes, through: :watched_classes

  validates :full_name, :cpf, :age, :birth_date, presence: true
  validates :token, presence: true, on: :update

  attr_accessor :plan

  def send_data_to_enrollments_api
    url = "#{Rails.configuration.external_apis['enrollments_url']}/enrollments"
    response = Faraday.post(url, build_data, 'Content-Type' => 'application/json')
    return false if response.status == 401

    hashed_response = JSON.parse(response.body, symbolize_names: true)
    add_token(hashed_response[:token])

    return hashed_response if response.status == 201
  end

  def build_data
    { full_name: self.full_name,
      cpf: self.cpf,
      birth_date: self.birth_date,
      email: self.email,
      payment_methods: self.payment_methods }.to_json
  end

  def plan?
    !!plan
  end

  private

  def add_token(token)
    update(token: token)
  end
end
