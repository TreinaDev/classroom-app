class Category
  extend Requestable

  BASE_URL = Rails.configuration.external_apis['enrollments_url']
  CATEGORIES_RELATIVE_PATH = '/categories'.freeze

  attr_reader :name, :id

  def initialize(name:, id:)
    @name = name
    @id = id
  end

  class << self
    def all
      send_request(join_path(CATEGORIES_RELATIVE_PATH)) do |json_response, response|
        json_response.map { |r| new(id: r[:id], name: r[:name]) } if response.status == 200
      end
    end

    def find_by(id)
      send_request(join_path(CATEGORIES_RELATIVE_PATH, "/#{id}")) do |json_response|
        new(id: json_response[:id], name: json_response[:name]) if response.status == 200
      end
    end

    private

    def send_request(url_path)
      response = Faraday.get(url_path)
      json_response = JSON.parse(response.body, symbolize_names: true)
      yield json_response, response
    end
  end
end
