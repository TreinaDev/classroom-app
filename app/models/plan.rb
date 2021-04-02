class Plan
  extend Requestable

  BASE_URL = Rails.configuration.external_apis['enrollments_url']
  PLANS_RELATIVE_PATH = '/plans'.freeze

  attr_accessor :id, :name, :price, :num_classes_available, :categories

  def initialize(id:, name:, price:, num_classes_available:, categories: nil)
    @id = id
    @name = name
    @price = price
    @categories ||= categories
    @num_classes_available = num_classes_available
  end

  def watch_video_class?(category)
    categories.include?(category)
  end

  def ==(other)
    return false if other.class != Plan
    return false if other.id != id
    return false if other.name != name
    return false if other.price != price
    return false if other.num_classes_available != num_classes_available
    return false if other.categories != categories

    true
  end

  def eql?(other)
    return false if other.class != Plan

    hash == other.hash
  end

  def hash
    (id.hash + name.hash + price.hash + num_classes_available.hash + categories.hash).hash
  end

  class << self
    def all
      response = Faraday.get(join_path(PLANS_RELATIVE_PATH))

      return [] if response.status != 200

      build_plans(response.body)
    end

    def build_plans(body)
      plans_hash_array = JSON.parse(body, symbolize_names: true)
      plans_hash_array = plans_hash_array.map do |r|
        r[:categories].map! { |category| Category.new(id: category[:id], name: category[:name]) }
        r
      end
      plans_hash_array.map { |r| new(r) }
    rescue JSON::ParserError
      []
    end

    def build_plan(body)
      plan_hash = JSON.parse(body, symbolize_names: true)
      plan_hash[:categories].map! { |category| Category.new(id: category[:id], name: category[:name]) }
      new(plan_hash)
    rescue JSON::ParserError
      nil
    end
  end
end
