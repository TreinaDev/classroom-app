require 'rails_helper'

describe Plan do
  context 'PORO' do
    it 'should initialize a new category' do
      category = Category.new(name: 'Crossfit')

      expect(category.name).to eq('Crossfit')
    end
  end

  context 'Fetch API data' do
    it 'should get all categories' do
      resp_json = File.read(Rails.root.join('spec/support/apis/get_categories.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json)

      allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/categories')
                                     .and_return(resp_double)

      categories = Category.all

      expect(categories.length).to eq 3
      expect(categories[0].name).to eq 'Crossfit'
      expect(categories[1].name).to eq 'Bodybuilding'
      expect(categories[2].name).to eq 'Zumba'
    end
  end
end
