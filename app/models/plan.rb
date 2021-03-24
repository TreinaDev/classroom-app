class Plan
  attr_reader :name, :price, :categories, :num_classes_available

  def initialize(name:, price:, categories:, num_classes_available:)
    @name = name
    @price = price
    @categories = categories
    @num_classes_available = num_classes_available
  end

  def self.all
    response = Faraday.get('smartflix.com.br/api/v1/plans')
    json_response = JSON.parse(response.body, symbolize_names: true)

    plans = []
    json_response.each do |r|
      plans << new(name: r[:name], price: r[:price], categories: r[:categories], num_classes_available: r[:num_classes_available])
    end
    return plans
  end

  def self.find_customer_plan(token)
    response = Faraday.get("smartflix.com.br/api/v1/plans/#{token}")
    
    return [] if response.status == 403

    json_response = JSON.parse(response.body, symbolize_names: true)
    r = json_response.first
      
    plan = new(name: r[:name], price: r[:price], categories: r[:categories], num_classes_available: r[:num_classes_available])
  end
end
