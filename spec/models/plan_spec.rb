require 'rails_helper'

describe Plan do
  context 'PORO' do
    it 'should initialize a new plan' do
      plan = Plan.new(name: 'Plano Black', price: '109,90', 
                      categories: [{ "name": "Yoga"}, { "name": "FitDance"}, { "name": "FitDance" }], num_classes_available: 30)

      expect(plan.name).to eq('Plano Black')
      expect(plan.categories).to eq [{ "name": "Yoga"}, { "name": "FitDance"}, { "name": "FitDance" }]
      expect(plan.num_classes_available).to eq(30)
      expect(plan.price).to eq('109,90')
    end
  end

  context 'Fetch API data' do
    it 'should get all plans' do
      resp_json = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json )

      allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/plans')
                                     .and_return(resp_double)

      plans = Plan.all

      expect(plans.length).to eq 2
      expect(plans.first.name).to eq 'Plano Black'
      expect(plans.first.categories).to eq [{ "name": "Yoga"}, { "name": "FitDance"}, { "name": "FitDance" }]
      expect(plans.first.num_classes_available).to eq 30
      expect(plans.first.price).to eq '109,90'
      expect(plans.last.name).to eq 'Plano Smart'
      expect(plans.last.categories).to eq [{ "name": "Yoga"}, { "name": "FitDance"}]
      expect(plans.last.num_classes_available).to eq 15
      expect(plans.last.price).to eq '69,90'
    end
  end
end