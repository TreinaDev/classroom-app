class Payment
  extend Requestable

  BASE_URL = Rails.configuration.external_apis['payments_url']
  PAYMENT_METHODS_RELATIVE_PATH = '/payment_methods'.freeze

  attr_reader :id, :name

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def self.all
    response = Faraday.get(join_path(PAYMENT_METHODS_RELATIVE_PATH))
    return [] if response.status == 400 || response.status == 500

    json_response = JSON.parse(response.body, symbolize_names: true)
    json_response.map.with_object([]) { |r, payments| payments << new(id: r[:id], name: r[:name]) }
  end
end
