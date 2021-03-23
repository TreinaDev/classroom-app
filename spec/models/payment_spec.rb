require 'rails_helper'

describe Payment do
  context 'PORO' do
    it 'should initialize a new payment' do
      payment = Payment.new(name: 'Cartão de Crédito')

      expect(payment.name).to eq 'Cartão de Crédito'
    end
  end

  context 'Fetch API data' do
    it 'should get all payments' do
      resp_json = File.read(Rails.root.join('spec/support/apis/payment_methods.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json)

      allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/payments')
                                     .and_return(resp_double)
      
      payments = Payment.all

      expect(payments.length).to eq(3)
      expect(payments.first).to eq('Cartão de Crédito')
      expect(payments.second).to eq('Boleto')
      expect(payments.third).to eq('Pix')
    end

    it 'should return empty if bad request' do
      resp_double = double('faraday_response', status: 400, body: '')

      allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/payments')
                                     .and_return(resp_double)
      
      payments = Payment.all

      expect(payments.empty?).to eq(true)
    end

    it 'should return empty if internal server error' do
      resp_double = double('faraday_response', status: 500, body: '')

      allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/payments')
                                     .and_return(resp_double)
      
      payments = Payment.all

      expect(payments.empty?).to eq(true)
    end
  end
end