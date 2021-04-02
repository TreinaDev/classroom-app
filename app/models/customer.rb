class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :watched_classes, -> { distinct_by_video_class }, inverse_of: false, dependent: :destroy

  validates :full_name, :cpf, :age, :birth_date, presence: true
  validates :token, presence: true, on: :update

  def consumed_video_classes?(plan)
    total_watched = watched_classes.created_between(generate_month_period(plan)).count
    plan.num_classes_available <= total_watched
  end

  def generate_month_period(plan)
    range_date = (plan.enrolled_at..(plan.enrolled_at + 1.month))
    if range_date.include?(Date.current)
      range_date
    else
      search_period(plan.enrolled_at)
    end
  end

  def search_period(enrolled_at)
    start_month_period = enrolled_at + 1.month
    final_month_period = start_month_period + 1.month
    loop do
      range_date = (start_month_period)..(final_month_period)
      if range_date.include?(Date.current)
        return range_date
      end
      start_month_period += 1.month
      final_month_period += 1.month
    end
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
