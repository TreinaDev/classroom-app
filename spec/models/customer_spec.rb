require 'rails_helper'

describe Customer do
  context 'validation' do
    it { should validate_presence_of(:full_name) }

    it { should validate_presence_of(:cpf) }

    it { should validate_presence_of(:birth_date) }

    it { should validate_presence_of(:age) }
  end

  context 'post data to enrollments api' do
    it 'should send json data' do
      customer = create(:customer)
      data = customer.build_data
      resp_json = File.read(Rails.root.join('spec/support/apis/get_token.json'))
      resp_double = double('faraday_response', status: 201, body: resp_json)

      allow(Faraday).to receive(:post).with("#{Rails.configuration.external_apis['enrollments_url']}/enrollments",
                                            data,
                                            'Content-Type' => 'application/json')
                                      .and_return(resp_double)

      customer.send_data_to_enrollments_api

      expect(customer.token).to eq('p6Q')
    end

    it 'should return false if any error occur' do
      customer = create(:customer)
      data = customer.build_data
      resp_double = double('faraday_response', status: 401, body: '')

      allow(Faraday).to receive(:post).with("#{Rails.configuration.external_apis['enrollments_url']}/enrollments",
                                            data,
                                            'Content-Type' => 'application/json')
                                      .and_return(resp_double)

      response = customer.send_data_to_enrollments_api

      expect(response).to eq(false)
    end
  end

  context '#plan?' do
    it 'successfully' do
      customer = create(:customer, token: '46465dssafd')
      plan = Plan.new(id: 1, name: 'Plano Black',
                      monthly_rate: 109.90,
                      monthly_class_limit: 30,
                      description: 'Para aqueles que querem entrar em forma',
                      status: 'active',
                      class_categories: [
                        Category.new(id: 1, name: 'Yoga'),
                        Category.new(id: 2, name: 'FitDance'),
                        Category.new(id: 3, name: 'Crossfit')
                      ])
      customer.plan = plan

      expect(customer.plan?).to be_truthy
    end

    it 'failure' do
      customer = create(:customer, token: '46465dssafd')
      customer.plan = nil

      expect(customer.plan?).to be_falsy
    end
  end
end
