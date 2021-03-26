class Payment
  attr_reader :name

  def initialize(name:)
    @name = name
  end

  def self.all
    response = Faraday.get('http://localhost/api/v1/payment_methods')
    return [] if response.status == 400 || response.status == 500

    json_response = JSON.parse(response.body, symbolize_names: true)
    json_response.map.with_object([]) { |r, payments| payments << r[:name] }
  end
end
