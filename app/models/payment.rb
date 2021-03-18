class Payment
  attr_reader :name

  def initialize(name:)
    @name = name
  end

  def self.all
    response = Faraday.get('smartflix.com.br/api/v1/payments')
    return [] if response.status == 400 || response.status == 500

    json_response = JSON.parse(response.body, symbolize_names: true)
    json_response.map.with_object([]) { |r, payments| payments << new(name: r[:name]) }
  end
end