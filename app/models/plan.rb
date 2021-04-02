class Plan
  extend Requestable

  BASE_URL = Rails.configuration.external_apis['enrollments_url']
  PLANS_RELATIVE_PATH = '/plans'.freeze

  attr_reader :name, :price, :categories, :num_classes_available

  def initialize(id:, name:, price:, num_classes_available:, categories: nil)
    @id = id
    @name = name
    @price = price
    @categories ||= categories
    @num_classes_available = num_classes_available
  end

  def watch_video_class?(category)
    categories.include?(category)
  end

  class << self
    def all
      response = Faraday.get(join_path(PLANS_RELATIVE_PATH))

      return [] if response.status != 200

      build_plans(response.body)
    end

    def build_plans(body)
      plans_hash_array = JSON.parse(body, symbolize_names: true)
      plans_hash_array = plans_hash_array.map do |r|
        r[:categories].map! { |category| Category.new(id: category[:id], name: category[:name]) }
        r
      end
      plans_hash_array.map { |r| new(r) }
    end

    def build_plan(body)
      plan_hash = JSON.parse(body, symbolize_names: true)
      plan_hash[:categories].map! { |category| Category.new(id: category[:id], name: category[:name]) }
      new(plan_hash)
    end
  end
end
