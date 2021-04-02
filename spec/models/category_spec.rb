require 'rails_helper'

describe Plan do
  context 'PORO' do
    it 'should initialize a new category' do
      category = Category.new(id: 1, name: 'Crossfit')

      expect(category.name).to eq('Crossfit')
    end
  end

  context 'Fetch API data' do
    it 'should get all categories' do
      resp_json = File.read(Rails.root.join('spec/support/apis/get_categories.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json)

      allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['enrollments_url']}/categories")
                                     .and_return(resp_double)

      categories = Category.all

      expect(categories.length).to eq 3
      expect(categories[0].name).to eq 'Crossfit'
      expect(categories[1].name).to eq 'Bodybuilding'
      expect(categories[2].name).to eq 'Zumba'
    end
  end

  context '#==' do
    it 'successfully' do
      category1 = Category.new(id: 1, name: 'undefined')
      category2 = Category.new(id: 1, name: 'undefined')
      expect(category1 == category2).to be_truthy
    end

    it 'failure: different ids' do
      category1 = Category.new(id: 1, name: 'undefined')
      category2 = Category.new(id: 2, name: 'undefined')
      expect(category1 == category2).to be_falsy
    end

    it 'failure: different names' do
      category1 = Category.new(id: 1, name: 'undefined')
      category2 = Category.new(id: 1, name: 'defined')
      expect(category1 == category2).to be_falsy
    end
  end

  context '#eql?' do
    it 'successfully' do
      category1 = Category.new(id: 1, name: 'undefined')
      category2 = Category.new(id: 1, name: 'undefined')
      expect(category1.eql?(category2)).to be_truthy
    end

    it 'failure: different ids' do
      category1 = Category.new(id: 1, name: 'undefined')
      category2 = Category.new(id: 2, name: 'undefined')
      expect(category1.eql?(category2)).to be_falsy
    end

    it 'failure: different names' do
      category1 = Category.new(id: 1, name: 'undefined')
      category2 = Category.new(id: 1, name: 'defined')
      expect(category1.eql?(category2)).to be_falsy
    end
  end

  context '#hash' do
    it 'successfully' do
      category1 = Category.new(id: 1, name: 'undefined')
      category2 = Category.new(id: 1, name: 'undefined')
      expect(category1.hash == category2.hash).to be_truthy
    end

    it 'failure: different ids' do
      category1 = Category.new(id: 1, name: 'undefined')
      category2 = Category.new(id: 2, name: 'undefined')
      expect(category1.hash == category2.hash).to be_falsy
    end

    it 'failure: different names' do
      category1 = Category.new(id: 1, name: 'undefined')
      category2 = Category.new(id: 1, name: 'defined')
      expect(category1.hash == category2.hash).to be_falsy
    end
  end
end
