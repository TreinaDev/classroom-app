class Plan
  attr_reader :name, :price

  def initialize(name:, price:)
    @name = name
    @price = price
  end

  def self.all
    response = Faraday.get('smartflix.com.br/api/v1/plans')
    json_response = JSON.parse(response.body, symbolize_names: true)

    plans = []
    json_response.each do |r|
      plans << new(name: r[:name], price: r[:price])
    end
    return plans
  end
end
