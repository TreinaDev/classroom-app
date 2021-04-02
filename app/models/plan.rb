class Plan
  extend Requestable

  BASE_URL = Rails.configuration.external_apis['enrollments_url']
  PLANS_RELATIVE_PATH = '/plans'.freeze

  def initialize(attributes)
    attributes.each do |key, value|
      instance_variable_set("@#{key}", value)
      define_singleton_method(key) do
        instance_variable_get("@#{key}")
      end
      define_singleton_method("#{key}=".to_sym) do |val|
        instance_variable_set("@#{key}", val)
      end
    end
  end

  def watch_video_class?(category)
    class_categories.include?(category)
  end

  def ==(other)
    return false if other.class != Plan
    return false if instance_variables.any? do |var|
      instance_variable_get(var) != other.instance_variable_get(var)
    end

    true
  end

  def eql?(other)
    return false if other.class != Plan

    hash == other.hash
  end

<<<<<<< HEAD
    new(id: json_response, name: json_response, price: json_response, 
        num_classes_available: json_response, categories: json_response)
=======
  def hash
    instance_variables.map { |var| instance_variable_get(var).hash }
                      .sum
                      .hash
>>>>>>> 5eca136a1c6b81204f614e43e59d38604df6f5e0
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
        r[:class_categories].map! { |category| Category.new(id: category[:id], name: category[:name]) }
        r
      end
      plans_hash_array.map { |r| new(r) }
    rescue JSON::ParserError
      []
    end

    def build_plan(body)
      plan_hash = JSON.parse(body, symbolize_names: true)
      plan_hash[:class_categories].map! { |category| Category.new(id: category[:id], name: category[:name]) }
      new(plan_hash)
    rescue JSON::ParserError
      nil
    end
  end
end
