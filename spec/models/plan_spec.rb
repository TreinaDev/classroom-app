require 'rails_helper'

describe Plan do
  context 'PORO' do
    it 'should initialize a new plan' do
      plan = Plan.new(id: 1, name: 'Plano Black',
                      price: '109,90',
                      categories: [
                        {
                          id: 1,
                          name: 'Yoga'
                        },
                        {
                          id: 2,
                          name: 'FitDance'
                        },
                        {
                          id: 3,
                          name: 'Crossfit'
                        }
                      ],
                      num_classes_available: 30)

      expect(plan.name).to eq('Plano Black')
      expect(plan.categories).to eq [{ id: 1, name: 'Yoga' }, { id: 2, name: 'FitDance' }, { id: 3, name: 'Crossfit' }]
      expect(plan.num_classes_available).to eq(30)
      expect(plan.price).to eq('109,90')
    end
  end

  context 'Fetch API data to get plans' do
    it 'should get all plans' do
      resp_json = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json)

      allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/plans')
                                     .and_return(resp_double)

      plans = Plan.all

      expect(plans.length).to eq 2

      expect(plans.first.name).to eq 'Plano Black'
      expect(plans.first.categories[0].name).to eq 'Yoga'
      expect(plans.first.categories[1].name).to eq 'FitDance'
      expect(plans.first.categories[2].name).to eq 'Crossfit'
      expect(plans.first.num_classes_available).to eq 30
      expect(plans.first.price).to eq '109,90'

      expect(plans.last.name).to eq 'Plano Smart'
      expect(plans.last.categories[0].name).to eq 'Yoga'
      expect(plans.last.categories[1].name).to eq 'FitDance'
      expect(plans.last.num_classes_available).to eq 15
      expect(plans.last.price).to eq '69,90'
    end

    it 'should return empty if not authorized' do
      resp_double = double('faraday_response', status: 401, body: '')

      allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/plans')
                                     .and_return(resp_double)

      plans = Plan.all

      expect(plans.length).to eq 0
    end
  end

  context 'Fetch API data to get customer plan' do
    it 'should get customer plan' do
      resp_json = File.read(Rails.root.join('spec/support/apis/customer_plan.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json)
      customer = create(:customer, token: '46465dssafd')

      allow(Faraday).to receive(:get).with("smartflix.com.br/api/v1/enrollment/#{customer.token}/plans")
                                     .and_return(resp_double)

      plan = Plan.find_customer_plans(customer.token).first
      categories = plan.categories

      expect(plan.name).to eq 'Plano Smart'
      expect(categories.size).to eq(2)
      expect(categories.first.name).to eq('Yoga')
      expect(categories.last.name).to eq('FitDance')
      expect(plan.num_classes_available).to eq 15
      expect(plan.price).to eq '69,90'
    end

    it 'should return empty if not authorized' do
      resp_double = double('faraday_response', status: 401, body: '[]')
      customer = create(:customer, token: '46465dssafd')

      allow(Faraday).to receive(:get).with("smartflix.com.br/api/v1/enrollment/#{customer.token}/plans")
                                     .and_return(resp_double)

      plans = Plan.find_customer_plans(customer.token)

      expect(plans).to eq []
    end
  end

  context '#watch_video_class?' do
    it 'successfully' do
      video_class = create(:video_class, category: 3)
      plan = Plan.new(id: 1, name: 'Plano Black',
                      price: '109,90',
                      categories: [
                        Category.new(id: 1, name: 'Yoga'),
                        Category.new(id: 2, name: 'FitDance'),
                        Category.new(id: 3, name: 'Crossfit')
                      ],
                      num_classes_available: 30)

      expect(plan.watch_video_class?(video_class)).to be_truthy
    end

    it 'failure' do
      video_class = create(:video_class, category: 3)
      plan = Plan.new(id: 1, name: 'Plano Black',
                      price: '109,90',
                      categories: [
                        Category.new(id: 1, name: 'Yoga'),
                        Category.new(id: 2, name: 'FitDance')
                      ],
                      num_classes_available: 30)

      expect(plan.watch_video_class?(video_class)).not_to be_truthy
    end
  end
end
