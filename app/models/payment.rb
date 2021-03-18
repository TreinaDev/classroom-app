class Payment
  attr_reader :name

  def initialize(name:)
    @name = name
  end

  def self.all
    response = Faraday.get('smartflix.com.br/api/v1/payments')
    json_response = JSON.parse(response.body, symbolize_names: true)
    payments = []
    json_response.each { |r| payments << new(name: r[:name]) }

    payments
  end 
end