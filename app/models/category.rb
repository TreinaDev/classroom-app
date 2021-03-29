class Category
  attr_reader :name

  def initialize(name:)
    @name = name
  end

  def self.all
    response = Faraday.get('smartflix.com.br/api/v1/categories')
    json_response = JSON.parse(response.body, symbolize_names: true)

    json_response.map { |r| new(name: r[:name]) } if response.status == 200
  end
end
