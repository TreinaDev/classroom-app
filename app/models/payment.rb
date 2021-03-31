class Payment
  attr_reader :id, :name

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def self.all
    response = Faraday.get(Rails.configuration.external_apis['payments_url'])
    return [] if response.status == 400 || response.status == 500

    json_response = JSON.parse(response.body, symbolize_names: true)
    json_response.map.with_object([]) { |r, payments| payments << new(id: r[:id], name: r[:name]) }
  end
end
