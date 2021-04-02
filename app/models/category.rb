class Category
  attr_reader :name, :id

  def initialize(name:, id:)
    @name = name
    @id = id
  end

  def self.all
    response = Faraday.get('smartflix.com.br/api/v1/categories')
    json_response = JSON.parse(response.body, symbolize_names: true)

    json_response.map { |r| new(r) } if response.status == 200
  end

  def ==(other)
    return false if other.class != Category
    return false if other.id != id
    return false if other.name != name

    true
  end

  def eql?(other)
    return false if other.class != Category

    hash == other.hash
  end

  def hash
    (name.hash + id.hash).hash
  end
end
