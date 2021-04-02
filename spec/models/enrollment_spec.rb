require 'rails_helper'

describe Enrollment do
  context 'PORO' do
    it 'should initialize a new enrollment' do
      plan = Plan.new(id: 1, name: 'Plano Black',
                      monthly_rate: 109.90,
                      monthly_class_limit: 30,
                      description: 'Para aqueles que querem entrar em forma',
                      status: 'active')

      enrollment = Enrollment.new(status: 'active', enrolled_at: '2021-04-01', plan: plan)
      expect(enrollment.plan).to eq(plan)
    end
  end

  context 'Fetch API data to get customer plan' do
    it 'should get customer plan' do
      resp_json = File.read(Rails.root.join('spec/support/apis/get_customer_enrollment.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json)
      customer = create(:customer, token: '46465dssafd')

      allow(Faraday).to receive(:get)
        .with(
          "#{Rails.configuration.external_apis['enrollments_url']}" \
          "/enrollments/#{customer.token}"
        )
        .and_return(resp_double)

      plan = Enrollment.find_customer_plan(customer.token)

      expect(plan.name).to eq 'Plano Smart'
      expect(plan.class_categories).to eq [Category.new(id: 1, name: 'Yoga'), Category.new(id: 2, name: 'FitDance')]
      expect(plan.monthly_class_limit).to eq 15
      expect(plan.monthly_rate).to eq 69.90
    end

    it 'should return empty if not authorized' do
      resp_double = double('faraday_response', status: 401, body: '[]')
      customer = create(:customer, token: '46465dssafd')

      allow(Faraday).to receive(:get)
        .with("#{Rails.configuration.external_apis['enrollments_url']}/enrollments/#{customer.token}")
        .and_return(resp_double)

      plan = Enrollment.find_customer_plan(customer.token)

      expect(plan).to eq nil
    end
  end
end
