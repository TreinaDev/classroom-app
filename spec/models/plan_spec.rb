require 'rails_helper'

describe Plan do
  context 'PORO' do
    it 'should initialize a new plan' do
      plan = Plan.new(name: 'Plano Black', price: '109,90')

      expect(plan.name).to eq('Plano Black')
      expect(plan.price).to eq('109,90')
    end
  end

  context 'Fetch API data' do
    it 'should get all plans' do
      resp_json = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json)

      allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/plans')
                                     .and_return(resp_double)

      plans = Plan.all

      expect(plans.length).to eq 2
      expect(plans.first.name).to eq 'Plano Black'
      expect(plans.first.price).to eq '109,90'
      expect(plans.last.name).to eq 'Plano Smart'
      expect(plans.last.price).to eq '69,90'
    end

    it 'should get all plans of a customer' do
      resp_json = File.read(Rails.root.join('spec/support/apis/get_user_plans.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json)
      allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/enrollment/a2w5q8y10ei/plans')
                                     .and_return(resp_double)

      plans = Plan.find_by('a2w5q8y10ei')

      expect(plans.length).to eq 1
      expect(plans.first.name).to eq 'Plano Black'
      expect(plans.first.price).to eq '109,90'
      expect(plans.first.categories.length).to eq 2
      expect(plans.first.categories.first[:name]).to eq 'Bodybuilding'
      expect(plans.first.categories.last[:name]).to eq 'Crossfit'
    end
  end
end
