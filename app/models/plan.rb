class Plan
  attr_reader :name, :price, :categories

  def initialize(name:, price:, categories: nil)
    @name = name
    @price = price
    @categories |= categories
  end

  def self.all
    response = Faraday.get('smartflix.com.br/api/v1/plans')
    json_response = JSON.parse(response.body, symbolize_names: true)

    json_response.map { |r| new(r) }
  end

  def self.find_by(token)
    response = Faraday.get("smartflix.com.br/api/v1/enrollment/#{token}/plans")
    json_response = JSON.parse(response.body, symbolize_names: true)

    json_response.map { |r| new(r) }
  end
end
