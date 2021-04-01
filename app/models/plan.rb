class Plan
  attr_reader :name, :price, :categories, :num_classes_available

  def initialize(id:, name:, price:, num_classes_available:, categories: nil)
    @id = id
    @name = name
    @price = price
    @categories ||= categories
    @num_classes_available = num_classes_available
  end

  def self.all
    response = Faraday.get('smartflix.com.br/api/v1/plans')

    return [] if response.status != 200

    json_response = JSON.parse(response.body, symbolize_names: true)

    json_response = json_response.map do |r|
      r[:categories].map! { |category| Category.new(category) }
      r
    end
    json_response.map { |r| new(r) }
  end

  def self.find_customer_plans(token)
    response = Faraday.get("smartflix.com.br/api/v1/enrollment/#{token}/plans")
    json_response = JSON.parse(response.body, symbolize_names: true)

    return [] if response.status != 200

    new(id: json_response, name: json_response, price: json_response, 
        num_classes_available: json_response, categories: json_response)
  end

  def watch_video_class?(video_class)
    categories.map(&:name).include?(video_class.category)
  end
end
