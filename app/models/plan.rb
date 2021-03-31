class Plan
  attr_reader :name, :price, :categories, :num_classes_available

  def initialize(id:, name:, price:, num_classes_available:, categories: nil)
    @id = id
    @name = name
    @price = price
    @categories ||= categories
    @num_classes_available = num_classes_available
  end

  def watch_video_class?(video_class)
    categories.map(&:id).include?(video_class.category)
  end

  class << self
    def all
      response = Faraday.get('smartflix.com.br/api/v1/plans')

      return [] if response.status != 200

      build_plan(response.body)
    end

    def find_customer_plans(token)
      response = Faraday.get("smartflix.com.br/api/v1/enrollment/#{token}/plans")

      return [] if response.status != 200

      build_plan(response.body)
    end

    def build_plan(body)
      json_response = JSON.parse(body, symbolize_names: true)

      json_response = json_response.map do |r|
        r[:categories].map! { |category| Category.new(category) }
        r
      end
      json_response.map { |r| new(r) }
    end
  end
end
