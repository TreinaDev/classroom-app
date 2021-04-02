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

    return nil if response.status != 200

    Plan.build_plan(response.body)
  end
end
