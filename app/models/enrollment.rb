class Enrollment
  extend Requestable

  BASE_URL = Rails.configuration.external_apis['enrollments_url']
  ENROLLMENTS_RELATIVE_PATH = '/enrollments'.freeze

  attr_reader :plan, :status, :enrolled_at

  def initialize(status:, enrolled_at:, plan:)
    @status = status
    @enrolled_at = enrolled_at
    @plan = plan
  end

  def self.find_customer_plan(token)
    response = Faraday.get(join_path(ENROLLMENTS_RELATIVE_PATH, "/#{token}"))

    return nil if response.status != 200

    response_json = JSON.parse(response.body, symbolize_names: true)
    Plan.build_plan(response_json[:plan].to_json)
  end
end
