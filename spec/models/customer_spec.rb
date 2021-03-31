require 'rails_helper'

describe Customer do
  context 'validation' do
    it { should validate_presence_of(:full_name) }

    it { should validate_presence_of(:cpf) }

    it { should validate_presence_of(:age) }
  end

  context 'post data to enrollments api' do
    it 'should send json data' do
      customer = create(:customer)
      data = customer.build_data
      resp_json = File.read(Rails.root.join('spec/support/apis/get_token.json'))
      resp_double = double('faraday_response', status: 201, body: resp_json)

      allow(Faraday).to receive(:post).with('smartflix.com.br/api/v1/enrollments',
                                            data,
                                            'Content-Type' => 'application/json')
                                      .and_return(resp_double)

      customer.send_data_to_enrollments_api

      expect(customer.token).to eq('gFM')
    end

    it 'should return false if any error occur' do
      customer = create(:customer)
      data = customer.build_data
      resp_double = double('faraday_response', status: 401, body: '')

      allow(Faraday).to receive(:post).with('smartflix.com.br/api/v1/enrollments',
                                            data,
                                            'Content-Type' => 'application/json')
                                      .and_return(resp_double)

      response = customer.send_data_to_enrollments_api

      expect(response).to eq(false)
    end
  end
end
