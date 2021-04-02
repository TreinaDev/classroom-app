class Enrollment
  extend Requestable

  BASE_URL = Rails.configuration.external_apis['enrollments_url']
  ENROLLMENTS_RELATIVE_PATH = '/enrollments'.freeze

  attr_reader :plan

  def initialize(plan)
    @plan = plan
  end

  def self.find_customer_plan(token)
    response = Faraday.get(join_path(ENROLLMENTS_RELATIVE_PATH, "/#{token}", '/plan'))
    json_response = JSON.parse(response.body, symbolize_names: true)

    return nil if response.status != 200

    Plan.new(json_response)
  end
end
