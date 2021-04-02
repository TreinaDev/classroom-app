class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :watched_classes, -> { distinct_by_video_class }, inverse_of: false, dependent: :destroy

  validates :full_name, :cpf, :age, :birth_date, presence: true
  validates :token, presence: true, on: :update

  def consumed_video_classes?(plan)
    # FIXME: pegar start_at do plano
    start_date = 15.days.ago
    end_date = start_date + 1.month
    num = watched_classes.created_between(start_date, end_date).size
    plan.num_classes_available <= num
  end

  def send_data_to_enrollments_api
    url = 'smartflix.com.br/api/v1/enrollments'
    response = Faraday.post(url, build_data, 'Content-Type' => 'application/json')
    return false if response.status == 401

    update(token: response.body)
    return response if response.status == 201
  end

  def build_data
    { full_name: self.full_name,
      cpf: self.cpf,
      birth_date: self.birth_date,
      email: self.email,
      payment_methods: self.payment_methods }.to_json
  end
end
