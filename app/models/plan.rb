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

  def watch_video_class?(video_class)
    categories.map(&:name).include?(video_class.category)
  end

  def self.all
    response = Faraday.get(join_path(PLANS_RELATIVE_PATH))

    return [] if response.status != 200

    json_response = JSON.parse(response.body, symbolize_names: true)

    json_response = json_response.map do |r|
      r[:categories].map! { |category| Category.new(category) }
      r
    end
    json_response.map { |r| new(r) }
  end
end
